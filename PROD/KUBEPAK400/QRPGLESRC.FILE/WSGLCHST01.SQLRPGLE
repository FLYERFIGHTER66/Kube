      *? Program        : WSGLCHST01
      *?
      *? Description    : This pgm to Show GL Cash History Summary in Subfile
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 08 Aug 2019
      //--------------------------------------------------------------------
      *? Special Notes  : Summary Current Year GL Vs Last Year GL
      *?
      *? Called Program : WSSFLMSG - WS - Send and Clear message from subfile
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
           AlwNull(*UsrCtl) BndDir('*LIBL/KPFUNCTION') DatFmt(*usa);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Display file for GL Cash History Summary Screen
      *?Key : Current Year Date
        Dcl-F WSGLCHSTPF Disk Usage(*Delete:*Output);

      *?File: Display file for GL Cash History Summary Screen
        Dcl-F WSGLCHSTFM Workstn Indds(Dspf) Sfile(GLCHSTS01:S01Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSGLCHST01;
        End-Pi;
      *
      *?Procedure Prototype Declaration : CL Program for Message Subfile
        Dcl-Pr WSSFLMSG  ExtPgm;
           PMsgf  Char(10);
           PMsgId Char(7);
           POpt   Char(1);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Program to rebuild current year data
        Dcl-Pr WSGLCHST00 ExtPgm;
        End-Pr;
      *
      *?Subfile Data Structure          :
        Dcl-Ds SflRec Qualified;
           Wk          Packed(2:0);                // GL Week
           WkDay       Packed(2:0);                // GL Week Day
           TransDesc   Char(30);                   // GL Transaction Desc
           Year        Packed(4:0);                // GL Year
           Date        Date(*USA);                 // GL Date
           Bank        Packed(11:2);               // GL Bank Amount
           AP          Packed(11:2);               // GL AR Amount
           AR          Packed(11:2);               // GL AP Amount
           LYear       Packed(4:0);                // Last Year
           LDate       Date(*USA);                 // Last Year Date
           LBank       Packed(11:2);               // Last Year Bank Amount
           LAP         Packed(11:2);               // Last Year AR Amount
           LAR         Packed(11:2);               // Last Year AP Amount
        End-Ds;
      *
      *?Subfile Data Structure 2        :
        Dcl-Ds SflDs   Qualified;
           Year        Packed(4:0);                             // GL Year
           Seq#        Packed(4:0);                             // GL Date
           CDate       Char(10);                                // GL Date
           LDate       Char(10);                                // Last Year Date
           CBank       Packed(11:2);                            // GL Bank Amount
           CAP         Packed(11:2);                            // GL AR Amount
           CAR         Packed(11:2);                            // GL AP Amount
           CCash       Packed(11:2);                            // Cash Position Amount
           LBank       Packed(11:2);                            // Last Year Bank Amount
           LAP         Packed(11:2);                            // Last Year AR Amount
           LAR         Packed(11:2);                            // Last Year AP Amount
           LCash       Packed(11:2);                            // Last Year Cash Position Amount
        End-Ds;
      *
      *?Program Status Data Structure   :
        Dcl-Ds Pgmstatus PSDS;
           Job      Char(10) Pos(244);
           User     Char(10) Pos(254);
           Rundate  Zoned(6) Pos(276);
           Runtime  Zoned(6) Pos(282);
           Pgm      Char(10) Pos(334);
        End-Ds;
      *
      *?Global Variable Declaration     :
        Dcl-S ModReq    Char(10)        Inz;
        Dcl-S FunReq    Char(10)        Inz;
        Dcl-S NullInd   Int(5)  Dim(12) Inz(0);
        Dcl-S NullInd1  Int(5)  Dim(13) Inz(0);
        Dcl-S NullValue Like(NullInd)   Inz(-1);
        Dcl-S NullValu1 Like(NullInd1)  Inz(-1);
      *
      *?Work Variable Declaration       :
        Dcl-S WkRrn     Like(S01Rrn);
        Dcl-S WkYear    Zoned(4)    Inz;
        Dcl-S WkDate    Date(*USA)  Inz;
        Dcl-S WkPDate   Date(*USA)  Inz;
        Dcl-S WkDateC   Date(*USA)  Inz;
        Dcl-S WkCount   Int(5)      Inz;
        Dcl-S WkCDate   Char(10)    Inz;
        Dcl-S WkNDate   Char(10)    Inz;
        Dcl-S WkPDatC   Char(10)    Inz;
        Dcl-S WkTFlag   Char(1)     Inz('Y');
      *
      *?Parameter Variable Declaration  :
        Dcl-S PMsgf   Char(10);
        Dcl-S PMsgId  Char(7);
        Dcl-S POpt    Char(1);
      *
      *?Program Indicators Declaration  :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration  :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(3);          // Exit Function Key
           Toggle          Ind Pos(8);          // Toggle Function Key
      *
           S01SflDsp       Ind Pos(21);         // Subfile Display Ind
           S01SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S01SflClr       Ind Pos(23);         // Subfile Clear Ind
           S01SflEnd       Ind Pos(24);         // Subfile End Ind
           S01SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
      *
           S01DateRi       Ind Pos(27);         // Reverse Image Ind
        End-Ds;

      /Include QFunctDefn,$_DATES

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
           Exec Sql Close A3;

      *?   // End Program
           *InLr = *On;

      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1M Subroutine :
      *?                :-----------------:
      *
      *?Logic : Call subroutine based on functional request
      *?
        Begsr SN1M;

      *?   // Initialization
           If FunReq = 'INITIAL';
              Exsr SN1I;
           Endif;

      *?   // Display
           If FunReq = 'DISPLAY';
              Exsr SN1D;
           Endif;

      *?   // Display
           If FunReq = 'VALIDATE';
              Exsr SN1V;
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
           Dspf.S01SflClr = True;                      // Clear Ind ON
           Dspf.S01SflDsp = False;                     // Display Ind OFF

      *?   // Write Control Part
           Write GLCHSTC01;

      *?   // Clear Rrn
           S01Rrn = *Zeros;

      *?   // Clear Indicator Off
           Dspf.S01SflClr    = False;                  // Clear Ind OFF
           Dspf.S01SflDspCtl = True;                   // Display Control Ind ON

      *?   // Build the Subfile
           Exsr SN1B;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Build Subfile from the Data Structure
      *?
        Begsr SN1B;

      *?   // Initialise Rrn
           S01Rrn = *Zeros;

      *?   // Get Subfile Records for Normal Order
           If WkTFlag = 'N';
              Exec Sql Declare A2 Cursor For
                 Select * from WSGLCHSTPF
                 Where WSYEAR = :C01Year
                 Order by WSSeq;

      *?      // Open Cursor
              Exec Sql Open A2;
              If SqlCode = -502 ;
                 Exec Sql Close A2;
                 Exec Sql Open A2;
              Endif;
              Exec Sql Fetch A2 into :SflDs :NullInd;

      *?   // Get Subfile Records for Reverse Order
           Elseif WkTFlag = 'Y';
              Exec Sql Declare A3 Cursor For
                 Select * from WSGLCHSTPF
                 Where WSYEAR = :C01Year
                 Order by WSSeq Desc;

      *?      // Open Cursor
              Exec Sql Open A3;
              If SqlCode = -502 ;
                 Exec Sql Close A3;
                 Exec Sql Open A3;
              Endif;
              Exec Sql Fetch A3 into :SflDs :NullInd;
           Endif;

      *?   // Load Subfile
           Dow SqlCod = 0;

      *?      // Last Year Data
              If SflDs.CDate <> *Blanks;
                 S01DATE = SflDs.CDate;
              Else;
                 S01DATE = *Blanks;
              Endif;
              S01CASH = SflDs.CBank;
              S01AR   = SflDs.CAP;
              S01AP   = SflDs.CAR;
              S01CPOS = SflDs.CCash;

      *?      // Last Year Data
              If SflDs.LDate <> *Blanks;
                 S01LYDATE = SflDs.LDate;
              Else;
                 S01LYDATE = *Blanks;
              Endif;
              S01LYCASH = SflDs.LBank;
              S01LYAR   = SflDs.LAP;
              S01LYAP   = SflDs.LAR;
              S01LYCPOS = SflDs.LCash;

      *?      // Increment Rrn and Set Indicator
              S01Rrn += 1;
              If C01Date <> *Zeros;
                 If WkNDate = SflDs.CDate;
                    Dspf.S01DateRi = True;
                    WkRrn = S01Rrn;
                 Else;
                    Dspf.S01DateRi = False;
                 Endif;
              Else;
                 If WkPDatC = SflDs.CDate;
                    WkRrn = S01Rrn;
                    Dspf.S01DateRi = True;
                 Else;
                    Dspf.S01DateRi = False;
                 Endif;
              Endif;

      *?      // Write Subfile Record
              S01Diff = S01CPOS - S01LYCPOS;
              Write GLCHSTS01;

      *?      // Clear Record
              Exsr ClearSr;
              Clear SflDs;

              If WKTFlag = 'N';
                 Exec Sql Fetch A2 into :SflDs :NullInd;
              Elseif WKTFlag = 'Y';
                 Exec Sql Fetch A3 into :SflDs :NullInd;
              Endif;
           Enddo;

      *?   // End Indicator
           Dspf.S01SflEnd = *On;

      *?   // Check RRN and Show Subfile
           If S01Rrn <> *Zeros;
              If WkRrn <> *Zeros;
                 S01Rrn = WkRrn;
              Else;
                 S01Rrn = 1;
              Endif;
              Dspf.S01SflDsp = True;

      *?   // No Records Found
           Else;
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
           Write GLCHSTF01;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt GLCHSTC01;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';

      *?      // F8 Pressed
              When Dspf.Toggle;
                 If WkTFlag = 'N';
                    WkTFlag = 'Y';
                 Else;
                    WkTFlag = 'N';
                 Endif;
                 FunReq = 'INITIAL';

      *?      // Other Pressed
              Other;
                 FunReq = 'VALIDATE';
           Endsl;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1V Subroutine :
      *?                :-----------------:
      *
      *?Logic : Validate Controrl field and Load the Subfile
      *?
        Begsr SN1V;

      *?   // Check  Date Control Field Value
           If C01Date <> *Zeros;
              //WkNDate = %Char(%Date(C01Date:*USA):*USA/);
              WkNDate = %Char(%Date(C01Date:*YMD):*YMD/);
           Else;
              WkNDate = *Blanks;
           Endif;

      *?   // Check  Year Control Field Value
           If C01Year <> WkYear and C01Year <> *Zeros;
              WkCount = 0;
              Exec SQL
                 Select Count(*) Into :WkCount From WSGLCHSTPF
                 Where WSYEAR = :C01Year;
              If WkCount = 0;
                 Exsr LoadDsSr;
              Endif;
           Endif;

      *?   // If C01Year , Then Load for Current Year
           If C01Year = *Zero;
              C01Year = WkYear;
           Endif;
           C01HDG = %Char(C01year) + ' - ' + %Char(C01year - 1);

      *?   // Load Subfile
           FunReq = 'INITIAL';

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : LoadDsSr Subroutine :
      *?                :---------------------:
      *
      *?Logic : Load Records into Data Structure
      *?
        Begsr LoadDsSr;

      *?   // Initialise Rrn and Count
           Clear WkDate;
           Clear SflRec;

      *?   // Execute Sql to get Subfile Records for :C01Year
           Exec Sql Declare A1 Cursor For
              Select
              TY.WEEK_NUMBER                      as GL_Week,
              TY.DOTW                             as GL_WeekDay,
              coalesce(ThisYear.Description,  '') as Trans_Desc,

              TY.YEAR4                            as This_Year,
              TY.DATEFLD                          as Transaction_Date_This_Year,
              Case
                  When ThisYear.GL_NUMBER = 10500000
                    or ThisYear.GL_NUMBER = 10700000
                    or ThisYear.GL_NUMBER = 24000000
                  then ThisYear.TRANSACTION_AMOUNT
              End                                 as This_Year_Bank,
              Case
                  When ThisYear.GL_NUMBER = 15000000
                  then ThisYear.TRANSACTION_AMOUNT
              End                                 as This_Year_AR,
              Case
                  When ThisYear.GL_NUMBER = 20000000
                  then ThisYear.TRANSACTION_AMOUNT
              End                                 as This_Year_AP,
              LY.YEAR4                            as Last_Year,
              LY.DATEFLD                          as Transaction_Date_Last_Year,
              0                                   as Last_Year_Bank,
              0                                   as Last_Year_AR,
              0                                   as Last_Year_AP
              from S105R9YM.TGMSDATA.fcalen_all   as TY
              left outer join S105R9YM.TGMSDATA.fcalen_all   as LY
                        on TY.YEAR4 - 1     = LY.YEAR4
                       and TY.WEEK_NUMBER   = LY.WEEK_NUMBER
                       and TY.DOTW          = LY.DOTW
              left outer join S105R9YM.TGMSDATA.GL_Cash_Position_History_File
                                                  as ThisYear
                      on ThisYear.TRANSACTION_DATE = TY.DATEFLD
              Where ThisYear.GL_Year = :C01Year
                and TY.DATEFLD <= current date

              UNION

              Select
              LY.WEEK_NUMBER                      as GL_Week,
              LY.DOTW                             as GL_WeekDay,
              coalesce(LastYear.Description, '')  as Trans_Desc,
              TY.YEAR4                            as This_Year,
              TY.DATEFLD                          as Transaction_Date_This_Year,
              0                                   as This_Year_Bank,
              0                                   as This_Year_AR,
              0                                   as This_Year_AP,
              LastYear.GL_Year                    as Last_Year,
              LY.DATEFLD                          as Transaction_Date_Last_Year,
              Case
                  When LastYear.GL_NUMBER = 10500000
                    or LastYear.GL_NUMBER = 10700000
                    or LastYear.GL_NUMBER = 24000000
                  then LastYear.TRANSACTION_AMOUNT
              End                                 as Last_Year_Bank,
              Case
                  When LastYear.GL_NUMBER = 15000000
                  then LastYear.TRANSACTION_AMOUNT
              End                                 as Last_Year_AR,
              Case
                  When LastYear.GL_NUMBER = 20000000
                  then LastYear.TRANSACTION_AMOUNT
              End                                 as Last_Year_AP

              from S105R9YM.TGMSDATA.fcalen_all   as LY
              left outer join S105R9YM.TGMSDATA.fcalen_all   as TY
                        on TY.YEAR4 - 1     = LY.YEAR4
                       and TY.WEEK_NUMBER   = LY.WEEK_NUMBER
                       and TY.DOTW          = LY.DOTW
              left outer join S105R9YM.TGMSDATA.GL_Cash_Position_History_File
                                                  as LastYear
                      on LastYear.TRANSACTION_DATE = LY.DATEFLD
              Where LastYear.GL_Year = :C01Year - 1
                and TY.DATEFLD <= current date
              Order by
              Transaction_Date_This_Year,
              Trans_Desc;

      *?   // Open Cursor
           Exec Sql Open A1;
           If SqlCode = -502 ;
              Exec Sql Close A1;
              Exec Sql Open A1;
           Endif;

      *?   // Load Data Structure
           Exec Sql Fetch A1 Into :SflRec :NullInd1;
           Dow SqlCod = 0;
              If SflRec.Date <> WkDate and WkDate <> *Loval;

      *?         // Write Record
                 Exsr WriteSr;
                 Exsr MoveSr;
              Else;
                 Exsr MoveSr;
              Endif;
              Clear SflRec;
              Exec Sql Fetch A1 Into :SflRec :NullInd1;
           Enddo;

      *?   // Write Last Record
           Exsr WriteSr;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : WriteSr Subroutine :
      *?                :--------------------:
      *
      *?Logic : Write Record into File
      *?
        Begsr WriteSr;

      *?   // Write Record
           WSCASH  = WSCBANK + WSCAP + WSCAR;
           WSLCASH = WSLBANK + WSLAP + WSLAR;
           WSYEAR  = C01Year;
           WSSEQ = WkCount;
           WkCount += 1;
           Write WSGLCHSTR;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : MoveSr Subroutine :
      *?                :-------------------:
      *
      *?Logic : Move Values into Data Structure
      *?
        Begsr MoveSr;

      *?    // Current Year Details
            If SflRec.Date <> *Loval;
               WSCDATE = %Char(SflRec.Date);
               WSCDATE = %SubSt(WSCDATE:1:6)+%SubSt(WSCDATE:9:2)+'  ';
            Else;
               WSCDATE = *Blanks;
            Endif;
            WkDate = SflRec.Date;
            WSCBANK = WSCBANK + SflRec.Bank;
            WSCAR   = WSCAR   + SflRec.AR;
            WSCAP   = WSCAP   + SflRec.AP;

      *?    // Last Year Details
            If SflRec.LDate <> *Loval;
               WSLDATE = %Char(SflRec.LDate);
               WSLDATE = %SubSt(WSLDATE:1:6)+%SubSt(WSLDATE:9:2)+'  ';
            Else;
               WSLDATE = *Blanks;
            Endif;
            WSLBANK = WSLBANK + SflRec.LBank;
            WSLAR   = WSLAR   + SflRec.LAR;
            WSLAP   = WSLAP   + SflRec.LAP;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : ClearSr Subroutine :
      *?                :--------------------:
      *
      *?Logic : Clear Subfile Screen Values
      *?
        Begsr ClearSr;

      *?    // Clear values
            S01DATE = *Blanks;
            S01CASH = *Zeros;
            S01AR   = *Zeros;
            S01AP   = *Zeros;
            S01CPOS = *Zeros;
            S01LYDATE = *Blanks;
            S01LYCASH = *Zeros;
            S01LYAR   = *Zeros;
            S01LYAP   = *Zeros;
            S01LYCPOS = *Zeros;
            S01DIFF   = *Zeros;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : INZSR Subroutine :
      *?                :------------------:
      *
      *?Logic : Initialize Screen Inputs
      *?
        Begsr *InzSr;
           WSGLCHST00();  //Rebuild Current Year Data

      *?   // Initialise Values
           PGMQ = Pgm;
           WkDateC = %Date();                      // Current Date in Date Format
           WkPDate = WkDateC - %Days(1);           // Prev Date in Date Format
           WkPDatC = %Char(WkPDate);               // Prev Date in Char Format
           WkCDate = %Char(WkDateC);               // Current Date in Char Format
           WkYear  = %Int(%Subst(WkCDate:7:4));    // Current Year
           C01Hdg  = %Char(Wkyear) + ' - ' + %Char(Wkyear - 1);
           C01Year = WkYear;
           C01DATE = $MDYDate($Date(0));            // Clear Ind OFF


      *?   // Clear Records from Work File
           Exsr DeleteSr;

      *?   // Load Records into Data Structure
           Exsr LoadDsSr;

      *?   // Open Main Screen
           ModReq = 'SCREEN';
           FunReq = 'INITIAL';

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : DeleteSr Subroutine :
      *?                :---------------------:
      *
        Begsr DeleteSr;

      *?   // Delete Records from File
           Setll *Start WSGLCHSTPF;
           Read WSGLCHSTPF;
           Dow Not %Eof;
              Delete WSGLCHSTR;
              Read WSGLCHSTPF;
           Enddo;

      *?   // Clear Fields
           WSCBANK = *Zeros;
           WSCAR   = *Zeros;
           WSCAP   = *Zeros;
           WSCASH  = *Zeros;
           WSLBANK = *Zeros;
           WSLAR   = *Zeros;
           WSLAP   = *Zeros;
           WSLCASH = *Zeros;

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
