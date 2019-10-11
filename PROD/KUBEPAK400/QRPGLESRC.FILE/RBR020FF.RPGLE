     H/COPY QFunctDefn,@CopyRight                                                Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                                Use KP Functions
     H DatFmt(*Usa)
      // ?:````````````````````````````````````````````````````````````:?
      // ?:                     Ready Bay Check Out                    :?
      // ?:............................................................:?
      //  :````````````````````````````````````````````````````````````:
      //  : Created:  April 2004           ? Kube-Pak Corporation      :
      //  :      by:  William J. Behr                                  :
      //  :............................................................:
      //  :````````````````````````````````````````````````````````````:
      //  :   Program Description                                      :
      //  : ```````````````````````                                    :
      //  :                                                            :
      //  :............................................................:
      //  :````````````````````````````````````````````````````````````:
      //  :?  Subroutine Usage                                         :
      //  :                                                            :
      //  :  Scrn01   - Display Screen 01                              :
      //  :  Scrn02   - Display Screen 02                              :
      //  :  Scrn03   - Display Screen 03                              :
      //  :  Scrn04   - Display Screen 04                              :
      //  :  Scrn05   - Display Screen 05                              :
      //  :  Scrn06   - Display Screen 06                              :
      //  :  Scrn07   - Display Screen 07                              :
      //  :  Load01   - Load Screen 01                                 :
      //  :  Load02   - Load Screen 02                                 :
      //  :  Load03   - Load Screen 03                                 :
      //  :  Load04   - Load Screen 04                                 :
      //  :  Load05   - Load Screen 05                                 :
      //  :  Load06   - Load Screen 06                                 :
      //  :  Load07   - Load Screen 07                                 :
      //  :  Edit01   - EDIT Screen 01                                 :
      //  :  Edit02   - EDIT Screen 02                                 :
      //  :  Edit03   - EDIT Screen 03                                 :
      //  :  Edit04   - EDIT Screen 04                                 :
      //  :  Edit05   - EDIT Screen 05                                 :
      //  :  Edit06   - EDIT Screen 06                                 :
      //  :  Edit07   - EDIT Screen 07                                 :
      //  :  ClrError - Clear Error MEssage Subfile                    :
      //  :  SndError - Send an Error Message to the PGMMSGQ           :
      //  :  SRMSGF   - Clear or send messages to Pgm msg queue        :
      //  :  *INZSR   - Initialization Subroutine                      :
      //  :............................................................:
      //  :````````````````````````````````````````````````````````````:
      //  :?  Function Usage                                           :
      //  :                                                            :
      //  :  FUNCT  - FUNCT DESRIPTION HERE                            :
      //  :............................................................:
      //  :````````````````````````````````````````````````````````````:
      //  :?  Indicator Usage                                          :
      //  :                                                            :
      //  :  01 - 24  Return Screen Functions                          :
      //  :  03       Exit                                             :
      //  :  06       Restart                                          :
      //  :                                                            :
      //  :  25       SFLDSP, SFLDSPCTL, SFLCLR(N)                     :
      //  :  26       SFLDSP (Subfile has Data)                        :
      //  :  27       SFLEND                                           :
      //  :  28       SFLNXTCHG                                        :
      //  :  40       Lookup Indicator                                 :
      //  :  50       Error Indicator (All Errors)                     :
      //  :  70       Push Buttone Default 70 = Yes, N70 = No          :
      //  :  LR       Does this really need a description ?            :
      //  :............................................................:
      //  :````````````````````````````````````````````````````````````:
      //  :?  Edit Log                                                 :
      //  :                                                            :
WJB   //  :  WJB    -  5/11/04 - Added Logic to Update FMCUST          :
WJB   //  :  WJB    -  5/14/04 - Added Logic to write correct info     :
WJB   //  :                      to FALITEM. (Chain to FDLOTRD)        :
      //  :............................................................:
     FRBR020FM  CF   E             WORKSTN
     F                                     SFILE(RBR02002:RRN02)
     F                                     SFILE(RBR02004:RRN04)
     F                                     DEVID(WSID)
WJB  FFMCUST    UF   E           K DISK                                          Customer Master
     FFMCUSTCN  IF   E           K DISK    RENAME(RMCUST:BILLTO)  PREFIX(BT_)    Customer Master
     FFMCUSTAL  IF   E           K DISK    RENAME(RMCUST:ALPHA)                  Customer Master
     FFTRAY     IF   E           K DISK                                          Tray Info
     FFOECTL    IF   E           K DISK                                          Control File
     FFMTERM    IF   E           K DISK                                          Terms File
     FFHORDR    UF A E           K DISK                                          Order Header
     FFOPNORD   UF A E           K DISK                                          Order Value
     FFMINVT    IF   E           K DISK                                          Item Master
     FFMTAXF    IF   E           K DISK                                          Tax File
     FFIORDR    UF A E           K DISK                                          Order Detail
     FFIORDRPARTO  A E           K DISK                                          Partials Detail
     FFALITEML5 UF A E           K DISK                                          Item Allocated
WJB  FFDLOTRD_ARUF   E           K DISK    Rename(RDLOTRD:RDLOTRD_AR)            Lot Inventory AR
WJB  FFDLOTRD_NRUF   E           K DISK    Rename(RDLOTRD:RDLOTRD_NR)            Lot Inventory NR
WJB  FFDLOTRD_X UF A E           K DISK    Rename(RDLOTRD:RDLOTRD_X )            Lot Inventory X
     FFPPO      UF A E           K DISK                                          Order User Info

      //  Function Prototypes
     D/COPY QFunctDefn,$Date
     D/COPY QFunctDefn,$Date7
     D/COPY QFunctDefn,$MDYDate
     D/COPY QFunctDefn,$Monday
     D/COPY QFunctDefn,$GetOrder#
     D/COPY QFunctDefn,$UnitPrice
     D/COPY QFunctDefn,$PrintPick
     D/COPY QFunctDefn,$Allocate
     D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$Now
     D/COPY QFunctDefn,$_LOT
     D/COPY QFunctDefn,$_IC

      //  Field Definitions
     D   RRN02         S              4  0 Inz(0)                                SFLRRN Screen 02
     D   RRN04         S              4  0 Inz(0)                                SFLRRN Screen 04
     D   ErrCount      S              2  0 Inz(0)                                Error Count
     D   Nines8        S              8S 0 Inz(99999999)                         8S 0 all 9's
     D   Nines15       S             15A   Inz('999999999999999')                15A  all 9's
     D   Nines30       S             30A                                         30A  all 9's
     D                                     Inz('999999999999999999999999999999')
     D   x             S              4S 0 Inz(0)                                Array Counter
     D   CountItem     S              4S 0 Inz(0)                                Tray Count for Item
     D   Now           S              6S 0 Inz(0)                                Array Counter
     D   Today         S               D                                         Today
     D   TodayMDY      S              6S 0 Inz(0)                                Today  ( MDY )
     D   TodayYMD7     S              7S 0 Inz(0)                                Today  ( CYMD7 )
     D   ThisMonday    S              6S 0 Inz(0)                                Monday ( MDY )
     D   ThisMonCYMD   S              7S 0 Inz(0)                                Monday ( CYMD )
     D   Tax1          S              5S 2 Inz(0)                                Tax:State Tax
     D   Tax2          S              5S 2 Inz(0)                                Tax:County Tax
     D   Tax3          S              5S 2 Inz(0)                                Tax:Local Tax
     D   TotalTax01    S              7S 2 Inz(0)                                Sum:State Tax
     D   TotalTax02    S              7S 2 Inz(0)                                Sum:County Tax
     D   TotalTax03    S              7S 2 Inz(0)                                Sum:Local Tax
     D   TotalOrder    S              9S 2 Inz(0)                                Total Order Value
     D   CurrentItem   S             15A                                         Item being processe
     D   CurrentLot    S             30A                                         Lot being processed
     D   OrderSeq#     S              3S 0                                       Order Detail Seq. #
     D   Printer       S             10                                          Printer to Use
     D   Cust997       S                   Like(LRCUST) Inz(999997)              Partials Customer #
     D   Loop          S              7S 0
     D   LotPartPct    S              4S 2
     D   PartText      S                   Like(OIDES1)
     D   $SowD         S              7P 0
     D   $Ready        S              7P 0
     D   SaleableTot   S              3S 0
     D   SaleableQty   S              3S 0
     D   Discount      S              4S 1

      //  Indicators
     D   DUMMY         S               N   Inz(*Off)                             Dummy Routine IND
     D   Duplicates    S               N   Inz(*Off)                             Duplicate Tag Flag
     D   BadTag#       S               N   Inz(*Off)                             Tray not found
     D   Clear04       S               N   Inz(*Off)                             Clear S4 Arrays

      //  Arrays
     D   TagsS4        S              8S 0 Dim(0064) Inz(99999999)               Scanned Tags Scrn04
     D   TrayS4        S             15A   Dim(0064) Inz('999999999999999')      Tag Tray Info S04
     D   TrayS4Lot     S             30A   Dim(0064)                             Tag Tray Info S04
     D                                     Inz('999999999999999999999999999999')
     D   Tags          S              8S 0 Dim(3000) Inz(99999999)               Verified Tags
     D   Tray          S             15A   Dim(3000) Inz('999999999999999')      Tag Tray Info
     D   TrayLot       S             30A   Dim(3000)                             Tag Tray Info
     D                                     Inz('999999999999999999999999999999')
      //  Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

      //TrayDS          DS
      // TRITEM                             INZ('999999999999')                   Tray Item Number
      // TRSIZE                             INZ('999')                            Tray Size

     D TrayDSLot       DS
     D  TRITEM                             INZ('999999999999')                   Tray Item Number
     D  TRSIZE                             INZ('999')                            Tray Size
     D  TRSCYM                             INZ( 9999999 )                        Tray Sow Date
     D  TRCRDT                             INZ( 9999999 )                        Tray Ready Date
     D  TRSTAT                             INZ('9')                              Tray Status

      /FREE
       DOU *INLR = *ON;                                                       // COMMENT

         SELECT;                                                              //
         WHEN Screen = 1;                                                     //
           ExSr Edit01;                                                       //
         WHEN Screen = 2;                                                     //
           ExSr Edit02;                                                       //
         WHEN Screen = 3;                                                     //
           ExSr Edit03;                                                       //
         WHEN Screen = 4;                                                     //
           ExSr Edit04;                                                       //
         WHEN Screen = 5;                                                     //
           ExSr Edit05;                                                       //
         WHEN Screen = 6;                                                     //
           ExSr Edit06;                                                       //
         WHEN Screen = 7;                                                     //
           ExSr Edit07;                                                       //
         ENDSL;                                                               //

       ENDDO;                                                                 //

       //   ...........................................................
       //   :      Scrn01 - Display Screen 01                         :
       //   :.........................................................:
       BegSr Scrn01;                                                          //
         Screen = 01;
         Write MSGCTL;                                                        //
         ExFmt RBR02001;                                                      //
         ExSr ClrError;                                                       //
       EndSr;                                                                 //
       //   ...........................................................
       //   :      Scrn02 - Display Screen 02                         :
       //   :.........................................................:
       BegSr Scrn02;                                                          //
         Screen = 02;
         *In25 = *On;                                                         //
         Write MSGCTL;                                                        //
         ExFmt RBR02002C;                                                     //
         ExSr ClrError;                                                       //
         *In25 = *Off;                                                        //
       EndSr;                                                                 //
       //   ...........................................................
       //   :      Scrn03 - Display Screen 03                         :
       //   :.........................................................:
       BegSr Scrn03;                                                          //
         Screen = 03;
         Write MSGCTL;                                                        //
         ExFmt RBR02003;
         ExSr ClrError;                                                       //
       EndSr;                                                                 //
       //   ...........................................................
       //   :      Scrn04 - Display Screen 04                         :
       //   :.........................................................:
       BegSr Scrn04;                                                          //
         Screen = 04;
         Write MSGCTL;                                                        //
         *In25 = *On;                                                         //
         ExFmt RBR02004C;                                                     //
         *In25 = *Off;                                                        //
         ExSr ClrError;                                                       //
       EndSr;                                                                 //
       //   ...........................................................
       //   :      Scrn05 - Display Screen 05                         :
       //   :.........................................................:
       BegSr Scrn05;                                                          //
         Screen = 05;
         Write MSGCTL;                                                        //
         ExFmt RBR02005;                                                      //
         ExSr ClrError;                                                       //
       EndSr;                                                                 //
       //   ...........................................................
       //   :      Scrn06 - Display Screen 06                         :
       //   :.........................................................:
       BegSr Scrn06;                                                          //
         Screen = 06;
         Write MSGCTL;                                                        //
         ExFmt RBR02006;                                                      //
         ExSr ClrError;                                                       //
       EndSr;                                                                 //
       //   ...........................................................
       //   :      Scrn07 - Display Screen 07      NOT USED           :
       //   :.........................................................:
       BegSr Scrn07;                                                          //
         Screen = 07;
         Write MSGCTL;                                                        //
         ExFmt RBR02007;                                                      //
         ExSr ClrError;                                                       //
       EndSr;                                                                 //

       //   ...........................................................
       //   :      Load01 - Load Screen 01                            :
       //   :.........................................................:
       BegSr Load01;                                                          //
         Clear RBR02001;                                                      //
       EndSr;                                                                 //
       //   ...........................................................
       //   :      Load02 - Load Screen 02                            :
       //   :.........................................................:
       BegSr Load02;                                                          //

         //  Clear the Subfile
         *In25 = *Off;                                                        //
         *In26 = *Off;                                                        //
         *In27 = *Off;                                                        //
         Write RBR02002C;                                                     //

         //  Load the Subfile
         SetLL SMLOOK FMCUSTAL;                                               //
         Read FMCUSTAL;                                                       //

         RRN02 = *Zero;
         DoW %Subst(CMLOOK:1:%Len(%Trim(SMLOOK)))=SMLOOK                      //
               and not %EOF(FMCUSTAL);                                        //
         RRN02 += 1;
           Write RBR02002;                                                    //
           *In26 = *On;                                                       //
           Read FMCUSTAL;                                                     //
         EndDo;                                                               //

         IF *In26 = *On;                                                      //
           Chain RRN02 RBR02002;                                              //
           *In27 = *On;                                                       // SFLEND Indicator
           Update RBR02002;                                                   //
         EndIF;                                                               //

       EndSr;                                                                 //
       //   ...........................................................
       //   :      Load03 - Load Screen 03                            :
       //   :.........................................................:
       BegSr Load03;                                                          //
         Chain(N) SMCUST FMCUST;                                              //
         SBNAME = CMNAME;                                                     //
         SBADD1 = CMADD2;                                                     //
         SBADD2 = CMADD3;                                                     //
         SBCITY = CMCITY;                                                     //
         SBSTAT = CMSTST;                                                     //
         *In70 = *On;                                                         // Dft to "Yes"
       EndSr;                                                                 //
       //   ...........................................................
       //   :      Load04 - Load Screen 04                            :
       //   :.........................................................:
       BegSr Load04;                                                          //

         //  Clear Tag/Tray Arrays
         If Clear04;
           Clear04 = *Off;
           Reset Tags;
           Reset Tray;
         EndIF;
         Reset TagsS4;
         Reset TrayS4;
         Reset TrayS4Lot;
         //                  Reset                   TrayDS
         Reset TrayDSLot;

         //  Clear the Subfile
         *In25 = *Off;                                                        //
         *In26 = *Off;                                                        //
         *In27 = *Off;                                                        //
         Write RBR02004C;                                                     //

         //  Load the Subfile
         *In27 = *Off;                                                        // SFLEND Indicator
         RRN04 = *Zero;
         ScanTag = *Zeros;                                                    //
         DoW RRN04 < 64;                                                      //
           RRN04 += 1;
           Write RBR02004;                                                    //
         EndDo;                                                               //

         Chain RRN04 RBR02004;                                                //
         *In26 = *On;                                                         // Subfile has Data
         *In27 = *On;                                                         // SFLEND Indicator
         Update RBR02004;                                                     //
         *In27 = *Off;                                                        // SFLEND Indicator

       EndSr;                                                                 //
       //   ...........................................................
       //   :      Load05 - Load Screen 05                            :
       //   :.........................................................:
       BegSr Load05;                                                          //

         Clear RBR02005;                                                      //
         *In70 = *Off;                                                        // Dft to "No"

       EndSr;                                                                 //
       //   ...........................................................
       //   :      Load06 - Load Screen 06                            :
       //   :.........................................................:
       BegSr Load06;                                                          //

         Clear RBR02006;                                                      //

         SortA Tags;
         x = 0;
         DoW Tags(x+1) < Nines8;
           x = x + 1;
         EndDo;
         SCount = x;
         *In70 = *On;                                                         // Dft to "Yes"

       EndSr;                                                                 //
       //   ...........................................................
       //   :      Load07 - Load Screen 07         NOT USED           :
       //   :.........................................................:
       BegSr Load07;                                                          //
         Clear RBR02007;                                                      //
       EndSr;                                                                 //

       //   ...........................................................
       //   :      Edit01 - EDIT Screen 01                            :
       //   :.........................................................:
       BegSr Edit01;                                                          //

         IF SMCUST <> *Zeros;                                                 //
           SetLL SMCUST FMCUST;                                               //
         EndIF;                                                               //

         IF SMLOOK <> *Zeros;                                                 //
           SetLL SMLOOK FMCUSTAL;                                             //
           Read FMCUSTAL;                                                     //
         EndIF;                                                               //

         //  P R O C E S S   S C R E E N
         SELECT;                                                              //
         When *In03 = *ON;                                                    //
           *INLR = *On;

         When *In06 = *ON;                                                    //
           $#MSID = 'RBR0005';                                                //
           ExSr SndError;                                                     //
           ExSr Load01;                                                       //
           ExSr Scrn01;                                                       //

           //  Cust # and Alpha Search cannot both be Blank
         When SMCUST  =  *Zeros                                               //
               and  SMLOOK  =  *Blanks;                                       //
           $#MSID = 'RBR0001';                                                //
           ExSr SndError;                                                     //
           ExSr Scrn01;                                                       //

           //  Cust # if Entered must be Valid
         When not %Equal(FMCUST)                                              //
               and SMCUST <> *Zeros;                                          //
           $#MSID = 'RBR0003';                                                //
           ExSr SndError;                                                     //
           ExSr Scrn01;                                                       //

           //  Alpha if Entered must have at least one match
         When %Subst(CMLOOK:1:%Len(%Trim(SMLOOK)))<>SMLOOK                    //
               and SMLOOK <> *Blanks;                                         //
           $#MSID = 'RBR0004';                                                //
           ExSr SndError;                                                     //
           ExSr Scrn01;                                                       //

         When SMCUST =  *Zero                                                 //
               and  SMLOOK <> *Zero;                                          //
           ExSr Load02;                                                       //
           ExSr Scrn02;                                                       //

         When SMCUST <> *Zero;                                                //
           ExSr Load03;                                                       //
           ExSr Scrn03;                                                       //

         OTHER;                                                               //
           ExSr Load03;                                                       //
           ExSr Scrn03;                                                       //
         ENDSL;                                                               //

       EndSr;                                                                 //
       //   ...........................................................
       //   :      Edit02 - EDIT Screen 02                            :
       //   :.........................................................:
       BegSr Edit02;                                                          //

         SELECT;                                                              //
           //  Check Functions
         WHEN *IN03 = *ON;                                                    //
           *INLR = *On;
           LeaveSR;                                                           //
         WHEN *IN06 = *ON;                                                    //
           $#MSID = 'RBR0005';                                                //
           ExSr SndError;                                                     //
           ExSr Load01;                                                       //
           ExSr Scrn01;                                                       //
           //  When a Subfile record is returned
         When SFLCSRRRN <> *Zero;                                             //
           Chain SFLCSRRRN RBR02002;                                          //
           SMCUST = CMCUST;                                                   //
           ExSr Load03;                                                       //
           ExSr Scrn03;                                                       //
           //  If no Functions then ReDisplay
         OTHER;                                                               //
           ExSr Scrn02;                                                       //
         ENDSL;                                                               //

       EndSr;                                                                 //
       //   ...........................................................
       //   :      Edit03 - EDIT Screen 03                            :
       //   :.........................................................:
       BegSr Edit03;                                                          //

         SELECT;                                                              //
           //  Check Functions
         When *In06 = *ON;                                                    //
           $#MSID = 'RBR0005';                                                //
           ExSr SndError;                                                     //
           ExSr Load01;                                                       //
           ExSr Scrn01;                                                       //

         When SCUSOK <> 1
               and SCUSOK <> 2
               and SCUSOK <> 3;
           $#MSID = 'RBR0002';                                                //
           EXSR SndError;                                                     //
           EXSR Scrn03;                                                       //

         When SCUSOK = 2;
           ExSr Scrn01;                                                       //

         When SCUSOK = 1 or SCUSOK = 3;
           Clear04 = *On;                                                     //
           ExSr Load04;                                                       //
           ExSr Scrn04;                                                       //

           //  If no Actions then ReDisplay
         Other;                                                               //

           ExSr Scrn03;                                                       //
         ENDSL;                                                               //

       EndSr;                                                                 //

       //   ...........................................................
       //   :      Edit04 - EDIT Screen 04                            :
       //   :.........................................................:
       BegSr Edit04;                                                          //

         //  Check that non of the Subfile entries are Dups on Screen
         //    and that the Tag has an entry on the Tray File
         Reset TagsS4;
         Reset TrayS4;
         Reset TrayS4Lot;

         Duplicates = *Off;                                                   // Duplicate Flag
         BadTag#    = *Off;                                                   // Tray Not Found
         ReadC RBR02004;                                                      //
         DoW not %EOF(RBR020FM);                                              //
           *In51 = *Off;                                                      // SFL error Ind
           *In28 = *Off;                                                      // SFLNXTCHG
           If ScanTag <> *Zero;
             *In28 = *On;                                                     // SFLNXTCHG
      /END-FREE
     C     ScanTag       LookUp    TagsS4                                 40
      /FREE
             If %Found;
               *In51 = *On;                                                   // SFL error Ind
               Duplicates = *On;                                              // Duplicate Flag
               $#MSGD = %char(ScanTag);                                       //
               $#MSID = 'RBR0009';                                            //
               ExSr SndError;                                                 //
             EndIf;                                                           //
      /END-FREE
     C     ScanTag       LookUp    Tags                                   40
      /FREE
             If %Found;
               *In51 = *On;                                                   // SFL error Ind
               Duplicates = *On;                                              // Duplicate Flag
               $#MSGD = %char(ScanTag);                                       //
               $#MSID = 'RBR0010';                                            //
               ExSr SndError;                                                 //
             EndIf;                                                           //
             Chain ScanTag FTRAY;
             If not %Found(FTRAY);
               *In51 = *On;                                                   // SFL error Ind
               BadTag#    = *On;                                              // Tray not found
               $#MSGD = %char(ScanTag);                                       //
               $#MSID = 'RBR0008';                                            //
               ExSr SndError;                                                 //
             EndIf;                                                           //
           EndIf;                                                             //
           Update RBR02004;                                                   //
           If ScanTag <> *Zero;
             TagsS4(RRN04) = ScanTag;
             //                  Eval      TrayS4(RRN04) = TrayDS
             TrayS4Lot(RRN04) = TrayDSLot;
           EndIf;                                                             //
           ReadC RBR02004;                                                    //
         EndDo;                                                               //

         //  Load Subfile records into Array if no Dups and no bad tags
         If not Duplicates
               and not BadTag#;
           SortA TagsS4;
           SortA TrayS4;
           SortA TrayS4Lot;
           x = 1;
           DoW Tags(x) < Nines8;
             x = x + 1;
           EndDo;
      /END-FREE
     C                   MoveA     TagsS4        Tags(x)
     C                   MoveA     TrayS4Lot     TrayLot(x)
      /FREE
           SortA Tags;
           SortA Tray;
         EndIf;                                                               //

         Select;                                                              //
           //  Check Functions
         When *In06 = *ON;                                                    //
           $#MSID = 'RBR0005';                                                //
           ExSr SndError;                                                     //
           ExSr Load01;                                                       //
           ExSr Scrn01;                                                       //

         When *In05 = *ON;                                                    //
           ExSr Load04;                                                       //
           ExSr Scrn04;                                                       //

         When Duplicates or BadTag#;
           ExSr Scrn04;                                                       //

         When BadTag#;
           ExSr Scrn04;                                                       //

         Other;                                                               //
           ExSr Load05;                                                       //
           ExSr Scrn05;                                                       //
         EndSl;                                                               //

       EndSr;                                                                 //
       //   ...........................................................
       //   :      Edit05 - EDIT Screen 05                            :
       //   :.........................................................:
       BegSr Edit05;                                                          //

         SELECT;                                                              //
           //  Check Functions
         When *In06 = *ON;                                                    //
           $#MSID = 'RBR0005';                                                //
           ExSr SndError;                                                     //
           ExSr Load01;                                                       //
           ExSr Scrn01;                                                       //

         When SMORES <> 1
               and SMORES <> 2
               and SMORES <> 3;
           $#MSID = 'RBR0002';                                                //
           ExSr SndError;                                                     //
           ExSr Scrn05;                                                       //

         When SMORES = 1                                                      // 1=Yes
               or SMORES = 3;                                                 // 3=Yes
           ExSr Load04;                                                       //
           ExSr Scrn04;                                                       //

         When SMORES = 2;                                                     // 2=No
           ExSr Load06;                                                       //
           ExSr Scrn06;                                                       //

         Other;                                                               //
           ExSr Scrn05;                                                       //
         ENDSL;                                                               //

       EndSr;                                                                 //
       //   ...........................................................
       //   :      Edit06 - EDIT Screen 06                            :
       //   :.........................................................:
       BegSr Edit06;                                                          //

         SELECT;                                                              //
           //  Check Functions
         When *In06 = *ON;                                                    //
           $#MSID = 'RBR0005';                                                //
           ExSr SndError;                                                     //
           ExSr Load01;                                                       //
           ExSr Scrn01;                                                       //

         When Complete <> 1                                                   // 1=Yes
               and Complete <> 2                                              // 2=No
               and Complete <> 3;                                             // 3=Yes
           $#MSID = 'RBR0002';                                                //
           ExSr SndError;                                                     //
           ExSr Scrn06;                                                       //

         When Complete = 1
               or Complete = 3;
           Reset TotalTax01;                                                  // ST Total Tax
           Reset TotalTax02;                                                  // CO Total Tax
           Reset TotalTax03;                                                  // MU Total Tax
           Reset TotalOrder;                                                  // Total Order Value
           Now = %Timestamp();
           ExSr Wrt_HORDR;                                                    //
           $#MSID = 'RBR0007';                                                //
           $#MSGD = %Char(OHORD#);                                            //
           ExSr SndError;                                                     //
           If Printer = *Blanks;
             Printer = 'P6';
           EndIf;
           $PrintPick(OHORD#:Printer:'001':'*NO');
           ExSr Load01;                                                       //
           ExSr Scrn01;                                                       //

         When Complete = 2;
           ExSr Load04;                                                       //
           ExSr Scrn04;                                                       //

         Other;                                                               //
           ExSr Scrn06;                                                       //
         ENDSL;                                                               //

       EndSr;                                                                 //
       //   ...........................................................
       //   :      Edit07 - EDIT Screen 07  NOT USED                  :
       //   :.........................................................:
       BegSr Edit07;                                                          //

         SELECT;                                                              //
           //  Check Functions
         When *In06 = *ON;                                                    //
           $#MSID = 'RBR0005';                                                //
           ExSr SndError;                                                     //
           ExSr Load01;                                                       //
           ExSr Scrn01;                                                       //
         Other;                                                               //
           ExSr Scrn07;                                                       //
         ENDSL;                                                               //

       EndSr;                                                                 //

       //   ...........................................................
       //   :      ClrError - Clear Error MEssage Subfile             :
       //   :.........................................................:
       BegSr ClrError;                                                        //

         $#MSFN = 'C';
         ExSr SRMSGF;                                                         //
         ErrCount = *Zero;                                                    //
         *In50 = *Off;                                                        // Error Indicator

       EndSr;                                                                 //
       //   ...........................................................
       //   :      SndError - Send an Error Message to the PGMMSGQ    :
       //   :.........................................................:
       BegSr SndError;                                                        //

         $#MSFN = 'C';
         ExSr SRMSGF;                                                         //
         ErrCount = ErrCount + 1;                                             //
         *In50 = *On;                                                         // Error Indicator

       EndSr;                                                                 //

       //   ...........................................................
       //   :      SRMSGF - Clear or send messages to Pgm msg queue   :
       //   :.........................................................:
       BegSr SRMSGF;                                                          //

         //  Define Parameter List - define variables         ?

      /END-FREE
     C     PLMSGF        PLIST
     C                   Parm                    $#PGMQ           10             Pgm Msg Queue
     C                   Parm                    $#MSGF           10             Message File
     C                   Parm                    $#MSGL           10             Library
     C                   Parm                    $#MSID            7             Message Id
     C                   Parm                    $#MSGD          100             Message Data
     C                   Parm                    $#MSKY            4             Message Key
     C                   Parm                    $#MSFN            1             Send or Clear

      //  Call Msg processing CL                           ?

     C                   CALL      'XAMSFC'      PLMSGF

      /FREE
       EndSr;                                                                 //

       //   ...........................................................
       //   :      Wrt_HORDR - Write the Order Header                 :
       //   :.........................................................:
       BegSr Wrt_HORDR;                                                       //

         Clear RHORDR;
         Clear BillTo;
         Chain CMBLCU FMCUSTCN;                                               // Get billto info
         Clear RMTERM;
         Chain BT_CMTMCD FMTERM;                                              // Get Terms
         Clear ROECTL;
         Chain BT_CMCOMP FOECTL;                                              // Control File

         OHSTAT='A';                                                          // STATUS
         OHORD#=$GetOrder#(00);                                               // ORDER NUMBER
         OHCOMP=01;                                                           // COMPANY #
         OHCUST=SMCUST;                                                       // CUSTOMER #
         OHNAME=CMNAME;                                                       // SHIP TO NAME
         OHSHP2=CMADD2;                                                       // ADDRESS LINE #1
         OHSHP3=CMADD3;                                                       // ADDRESS LINE #2
         OHSHP4=CMADD4;                                                       // ADDRESS LINE #3
         OHSHCT=CMCITY;                                                       // CITY
         OHSHST=CMSTST;                                                       // STATE
         OHSHZP=CMZIP;                                                        // ZIP CODE
         OHPONO=*Blank;                                                       // P.O. NUMBER
         OHDTOR=ThisMonday;                                                   // ORDER DATE
         OHDTRQ=ThisMonday;                                                   // REQ SHIP DATE
         OHDTRY=ThisMonCYMD;                                                  // REQ. DATE CYMD
         OHDTCN=TodayMDY;                                                     // CANCEL DATE
         OHSHIN='   Rcv''d in good';                                          // SHIPPING INSTRUCTIO
         OHSPIN='Condition By:__________________';                            // SPECIAL INSTRUCTION
         OHTERM=TCDESC;                                                       // TERMS
         OHTRAT=*Zero;                                                        // CASH DISC PERCENT
         OHTDAY=*Zero;                                                        // CASH DISCOUNT DAYS
         OHTXST=CMTXST;                                                       // TAX EXEMPT
         OHTXJU=CMTXJU;                                                       // JURISDICTION
         // calc'd below     Eval      OHAMT1=TotalTax01                             TAX AMT 1
         // calc'd below     Eval      OHAMT2=TotalTax02                             TAX AMT 2
         // calc'd below     Eval      OHAMT3=TotalTax03                             TAX AMT 3
         OHTYPE=CMCTYP;                                                       // CUSTOMER TYPE
         OHSHPC='02';                                                         // SHIP VIA CODE
         OHSTA ='N';                                                          // SUB TO AVAIL
         OHACK ='N';                                                          // ORD. ACK. PRINTED
         OHSLD1=BT_CMNAME;                                                    // BILL TO
         OHSLD2=BT_CMADD2;                                                    // ADDRESS LINE #1
         OHSLD3=BT_CMADD3;                                                    // ADDRESS LINE #2
         OHSLD4=BT_CMADD4;                                                    // ADDRESS LINE #3
         OHSLCT=BT_CMCITY;                                                    // CITY
         OHSLST=BT_CMSTST;                                                    // STATE
         OHSLZP=BT_CMZIP;                                                     // ZIP CODE
         OHSLM1='01';                                                         // SALESPERSON 1
         OHSCM1=*Zero;                                                        // COMM % 1
         OHSLM2=*Blanks;                                                      // SALESPERSON 2
         OHSCM2=*Zero;                                                        // COMM % 2
         OHFRT$=*Zero;                                                        // FREIGHT AMT
         OHMER$=*Zero;                                                        // MERCHANDISE AMT
         OHDIS$=*Zero;                                                        // DISCOUNT AMT
         OHMIS$=*Zero;                                                        // MISC. CHARGE AMT
         OHTAX$=*Zero;                                                        // TAX AMOUNT
         OHFET$=*Zero;                                                        // FET AMOUNT
         OHIOCD='N';                                                          // INVOICE ONLY
         OHBOCD=CMBOOK;                                                       // CUST B/O ALLOWED
         OHCOFL='N';                                                          // CLOSED ORDER FLAG
         OHHOLD='N';                                                          // HOLD ORDER FLAG
         OHTDAT=TodayMDY;                                                     // DATE OF TRANS
         OHPLPT=*Blank;                                                       // PICK LIST PRINTED P
         OHIVCD='N';                                                          // INVOICED CODE
         OHDTLA=TodayMDY;                                                     // LAST ACTIVITY DATE
         OHTIME=Now;                                                          // TIME
         OHUSER=User;                                                         // USER
         OHORDY=ThisMonCYMD;                                                  // ORDER DATE CYMD
         OHPPCD='P';                                                          // PREPAID/COLLECT
         OHPRCD=CMPRCD;                                                       // PRICE CODE
         OHTRDC=CMTRDC;                                                       // TRADE DISC. %
         OHTMCD=CMTMCD;                                                       // TERMS CODE
         OHTDAS=TCTDAS;                                                       // TERMS DAYS
         OHINV#=*Zero;                                                        // INVOICE NUMBER
         OHINDT=*Zero;                                                        // INVOICE DATE CYMD
         OHUPSZ=CMUPSZ;                                                       // FREIGHT ZONE
         OHFRTX='N';                                                          // TAX FREIGHT
         OHSPTX='N';                                                          // TAX SPECIAL CHRGS
         OHTXID=CMTXID;                                                       // TAX ID #
         OHROUT=*Blank;                                                       // ROUTE #
         OHSTOP=*Zero;                                                        // STOP
         OHARCU=CMARCU;                                                       // AR CUST #
         OHSACU=CMSACU;                                                       // SA CUST #
         OHBLCU=CMBLCU;                                                       // BILLING CUST #
         OHTBLK=*Zero;                                                        // TOTAL BULK PIECES
         OHTBRK=*Zero;                                                        // TOTAL BROKEN PIECES
         OHDTAC=*Zero;                                                        // SHIP DATE
         OHALPH=CMLOOK;                                                       // CUSTOMER ALPHA
         OHSHFR=CMTERR;                                                       // SHIP FROM
         OHSHFR=*Blanks;                                                      // SHIP FROM
         OHPLST='000001';                                                     // FREIGHT CODE
         OHIMED='N';                                                          // IMMED PRINT
         OHIMED=*Blanks;                                                      // IMMED PRINT
         OHCASH=*Zero;                                                        // CASH APPLICATION
         OHORDT=ThisMonday;                                                   // ORIGINAL REQ DATE
         OHOLST=CMORLS;                                                       // ORDER PRICE LIST
         OHLOC ='R';                                                          // ORDER LOCATION
         OHLOC =*Blanks;                                                      // ORDER LOCATION
         OHOORD=*Zeros;                                                       // ORIGINAL ORDER #
         OHDISC=*Zero;                                                        // C&C OR SALE DISC. %
         OHPHYT=CMPHYT;                                                       // PHYTO CODE
         OHOPLP=*Blank;                                                       // ORDER PROOF PRINTED
         OHPOS =*Blank;                                                       // INVOICE TYPE
         OHSALE=*Blank;                                                       // SALE TYPE
         OHQTPR='N';                                                          // QUOTE PRINTED
         OHQUOT=*Blank;                                                       // QUOTE Y OR BLANK
         OHLOTC='Y';                                                          // LOT CONTROL ORDER?
         OHIMFG='N';                                                          // IMMED INVOICE PRINT

         Chain OHORD# FHORDR;
         If %found(FHORDR);
           *InH1 = *On;
         Else;
           ExSr Wrt_IORDR;                                                    //
           OHAMT1=TotalTax01;                                                 // TAX AMT 1
           OHAMT2=TotalTax01;                                                 // TAX AMT 2
           OHAMT3=TotalTax01;                                                 // TAX AMT 3
           //   Update Order User File Information
           POORD# = OHORD#;                                                   // ORDER NUMBER
           POTAKN = User;                                                     // ORDER TAKEN BY
           POENTR = User;                                                     // ORDER ENTERED BY
           POPICK = User;                                                     // PICKED BY
           POPACK = User;                                                     // PACKED BY
           Write RPPO;

           Write RHORDR;
           ExSr Wrt_OPNORD;                                                   // Write Order Value

           Chain CMCUST FMCUST;                                               // Chain for Update
           CMOCUR = CMOCUR + 1;                                               // QTY ORDERS CURRENT
           CMOYTD = CMOYTD + 1;                                               // QTY ORDERS YTD
           CMDTLO = TodayMDY;                                                 // DATE LAST ORDER
           CMVOPO = CMVOPO + TotalOrder;                                      // VALUE OF OPEN ORDER
           Update RMCUST;                                                     // Update Cust Master

         EndIf;

       EndSr;                                                                 //

       //   ...........................................................
       //   :      Wrt_IORDR - Write Order Detail Record              :
       //   :.........................................................:
       BegSr Wrt_IORDR;                                                       //

         SortA Tray;
         x = 1;
         OrderSeq# = 10;
         CountItem   = *Zero;
         //                  Dow       Tray(x) <  Nines15
         Dow TrayLot(x) <  Nines30
               //                            and  x  <= %Elem(Tray)
               and  x  <= %Elem(TrayLot);
           OrderSeq# = OrderSeq# + 2;
           //                  Eval      CurrentItem = Tray(x)
           CurrentLot  = TrayLot(x);
           CountItem   = *Zero;
           //                  Dow       CurrentItem = Tray(x)
           Dow CurrentLot  = TrayLot(x);
             CountItem = CountItem + 1;
             x = x + 1;
           EndDo;

           //                  If        X > 1 and CurrentItem <> *Blanks
           If X > 1 and CurrentLot  <> *Blanks;
             Clear RIORDR;
             //                  Eval      TrayDS = Tray(x-1)
             TrayDSLot = TrayLot(x-1);
      /END-FREE
     C     ItemKey       KList
     C                   KFld                    TRITEM
     C                   KFld                    TRSIZE
      /FREE
             Chain ItemKey FMINVT;                                            // Item Master

             //   Tax calculations
             Clear RMTAXF;
             OITXCD = 'N';                                                    // TAX ITEM CODE 1
             OITXST = 'N';                                                    // TAX ITEM CODE 2
             OITXCT = 'N';                                                    // TAX ITEM CODE 3
             OITXLC = 'N';                                                    // TAX ITEM CODE 4
             If CMTXST = 'N';                                                 // Tax Exempt ?
               Chain CMTXJU FMTAXF;                                           // Item Master File
               If %found(FMTAXF);
                 OIAMT1=TXPCT1;                                               // TAX AMT RATE 1
                 OIAMT2=TXPCT2;                                               // TAX AMT RATE 2
                 OIAMT3=TXPCT3;                                               // TAX AMT RATE 3
                 If OIAMT1<>*Zero
                       or OIAMT2<>*Zero
                       or OIAMT3<>*Zero;
                   OITXCD='Y';                                                // TAX ITEM CODE 1
                 EndIf;
                 If OIAMT1<>*Zero;
                   OITXST='Y';                                                // TAX ITEM CODE 2
                 EndIf;
                 If OIAMT2<>*Zero;
                   OITXCT='Y';                                                // TAX ITEM CODE 3
                 EndIf;
                 If OIAMT3<>*Zero;
                   OITXLC='Y';                                                // TAX ITEM CODE 4
                 EndIf;
               EndIf;
             EndIf;

             OISTAT='A';                                                      // STATUS
             OIORD#=OHORD#;                                                   // ORDER NUMBER
             OISEQ#=OrderSeq#;                                                // SEQ NUMBER
             OIITEM=IMITEM;                                                   // ITEM NUMBER
             OISIZE=IMSIZE;                                                   // SIZE
             OIDES1=IMDES1;                                                   // DESCRIPTION 1
             OIDES2=IMDES2;                                                   // COMMENT
             OICOMP=IMCOMP;                                                   // COMPANY #
             OIWHSE=IMWHSE;                                                   // LOCATION
             OIBIN#=IMBIN#;                                                   // BIN #
             OIUUOM=IMPUOM;                                                   // UNIT OF MEASURE
             OIMULT=IMMULT;                                                   // MULT 1
             OIUWGT=IMUWGT;                                                   // UNIT WGT
             OIUCST=IMUCST;                                                   // UNIT COST
             OIUPRI=$UnitPrice(IMITEM:IMSIZE:CMCUST);                         // UNIT PRICE
             OIOVER=%CHAR(CMPRCD);                                            // OVERRIDE CODE
             OIOVER='N';                                                      // OVERRIDE CODE
             If TRSTAT = 'P';
               $SowD  = TRSCYM;
               $Ready = TRCRDT;
               LotPartPct =
                   $LotPartPct(TRITEM:TRSIZE:$SowD:$Ready);
               If LotPartPct = *Zero;
                 LotPartPct = 1;
               EndIf;
               OIUPRI = OIUPRI * LotPartPct;
               PartText = 'Adj: (xxx of xxx) Disc: xx.x%';
               SaleableTot =
                   $Saleable(TRSIZE);
               SaleableQty =
                   $Saleable(TRSIZE)*(LotPartPct);
               Discount    =
                   100 - (LotPartPct*100);
               %Subst(PartText:07:3) =
                   %EditW(SaleableQty:'  0');
               %Subst(PartText:14:3) =
                   %EditW(SaleableTot:'  0');
               %Subst(PartText:24:5) =
                   %EditW(Discount:'   .0');
               OIOVER = 'Y';
               OIPCTF = LotPartPct;
               Write RIORDRPART;
             EndIf;
             OIQDDC=IMDIS1;                                                   // QTY DISCOUNT
             OIEXT$=CountItem*OIUPRI;                                         // EXT AMOUNT
             OIQORD=CountItem;                                                // QTY ORDERED
             OIQSHP=*Zero;                                                    // QTY SHIPPED
             OIQBOO=*Zero;                                                    // QTY BACKORDERED
             OISHPC='02';                                                     // SHIP VIA CODE
             //  see above       Eval      OIAMT1=TXPCT1                                 TAX AMT RAT
             //  see above       Eval      OIAMT2=TXPCT2                                 TAX AMT RAT
             //  see above       Eval      OIAMT3=TXPCT3                                 TAX AMT RAT
             OIDISC=*Zero;                                                    // DISCOUNT AMT
             OISHCD=*Blanks;                                                  // SHIP RELEASE CODE
             OISHCD='N';                                                      // SHIP RELEASE CODE
             OIBOCD=IMBOOK;                                                   // ITEM B/O ALLOWED
             OISLM1=OHSLM1;                                                   // SALESPERSON 1
             OICOM1=OICOM1;                                                   // COMMISSION 1
             OISLM2=OISLM2;                                                   // SALESPERSON 2
             OICOM2=OICOM2;                                                   // COMMISSION 2
             OICUST=SMCUST;                                                   // CUSTOMER #
             OIDTRQ=ThisMonday;                                               // REQ SHIP DATE
             OIDTLA=TodayMDY;                                                 // LAST ACTIVITY DATE
             OITIME=Now;                                                      // TIME
             OIUSER=User;                                                     // USER
             OITRDC=BT_CMTRDC;                                                // TRADE DISC %
             OICTCD=CMCTCD;                                                   // CONTRACT PRICE CODE
             OICTCD='N';                                                      // CONTRACT PRICE CODE
             OICOFL='N';                                                      // CLOSED ORDER FLAG
             OIITYP=*Blanks;                                                  // ITEM TYPE
             OIQINV=*Zero;                                                    // INVOICE QTY SHIPPED
             OIPLPT='N';                                                      // PICK LIST PRINTED
             //  see above       Eval      OITXCD=IMTXBL                                 TAX ITEM CO
             //  see above       Eval      OITXST=IMTCD1                                 TAX ITEM CO
             //  see above       Eval      OITXCT=IMTCD2                                 TAX ITEM CO
             //  see above       Eval      OITXLC=IMTCD3                                 TAX ITEM CO
             OIROUT=*Blanks;                                                  // ROUTE NUMBER
             OISTOP=*Zero;                                                    // STOP
             OICWT =*Zero;                                                    // CATCH WEIGHT
             OILBS#=*Zero;                                                    // POUNDS
             OIWGSH=*Zero;                                                    // WEIGHT SHIPPED
             OIRSCD=*Blanks;                                                  // REASON
             OISEQP=*Zero;                                                    // PRIMARY SEQ #
             OIPRAL=*Blanks;                                                  // PROMO ALLOW
             OIBPUM=IMBPUM;                                                   // BASE PRICE UNIT OF
             OISUOM=IMBPUM;                                                   // SHIP UOM
             OIBLUM=IMBPUM;                                                   // BILL UOM
             OIMUL2=*Zero;                                                    // MULT 2
             OILOTC='Y';                                                      // LOT CONTROL
             OIOPFL=*Blanks;                                                  // OPEN ORDER POST FLA
             OIBOLN=*Blanks;                                                  // LINE ITEM PUT ON BO
             OIBORQ=ThisMonday;                                               // ORIG B/O REQ SHIP D
             OIPRBO='N';                                                      // PREVIOUS BACKORDER
             OIPRBO=' ';                                                      // PREVIOUS BACKORDER
             OISTA ='N';                                                      // SUBJ TO AVAIL FLAG
             OIINV#=*Zero;                                                    // INVOICE NUMBER
             OISHFR=CMSHFR;                                                   // SHIP FROM
             OITAGS=*Zero;                                                    // # TAGS
             OIPPDC='N';                                                      // PROMPT PAY DSC Y/N
             OIPHYT=CMPHYT;                                                   // PHYTO CODE
             OISCHM='N';                                                      // SCHED. TO MOVE FLAG
             OISCHS='N';                                                      // SCHED. TO SOW FLAG
             OIQTAL=*Zero;                                                    // QTY ALLOCATED
             OIGLNO=*Zero;                                                    // G/L # SPEC CHARGES
             OIITMA=IMLOOK;                                                   // ITEM ALPHA SEARCH
             OISEDP=*Blanks;                                                  // SEED ORDERED Y/N
             OIRVCD=*Zero;                                                    // EXPIRE DATE - CYMD
             OIQTE =*Blanks;                                                  // QUOTE LINE ITEM
             OIORDT=ThisMonday;                                               // HOLD ORIG REQ SHIP
             OIRVDT=TodayYMD7;                                                // REQ SHIP DATE CYMD
             OILOT#=*Blanks;                                                  // LOT NUMBER
             OIFRQD='N';                                                      // FORCE QTY DISC Y/N
             OISPFL=*Blanks;                                                  // SUMMARY PICKSLIP FL
             OIALPH=CMLOOK;                                                   // CUST ALPHA SEARCH
             OIPRCL=IMPCL1;                                                   // PROD CLASS 1
             OINPSL=*Blanks;                                                  // NO PICKSLIP FUTURE
             OIRQTY=*Zero;                                                    // PRE RELEASE QTY
             OIPOST=*Blanks;                                                  // POST FLAG
             OISOW =*Zero;                                                    // SOW DATE CYMD
             OICCDC=*Zero;                                                    // C&C OR SALE DISC. %
             OILIST=*Blanks;                                                  // LIST CODE
             OIROY =IMROYL;                                                   // ROYALTY EACH

             Tax1  = OIAMT1 * OIUPRI;                                         // ST Tax on Item
             Tax2  = OIAMT2 * OIUPRI;                                         // CO Tax on Item
             Tax3  = OIAMT3 * OIUPRI;                                         // MU Tax on Item

             TotalTax01 = TotalTax01 + Tax1;                                  // ST Total Tax
             TotalTax02 = TotalTax02 + Tax2;                                  // CO Total Tax
             TotalTax03 = TotalTax03 + Tax3;                                  // MU Total Tax
             TotalOrder = TotalOrder + OIEXT$;                                // Total Order Value

      /END-FREE
     C     DetailKey     KList
     C                   KFld                    OIORD#
     C                   KFld                    OISEQ#
      /FREE
             Chain DetailKey FIORDR;
             If %found(FIORDR);
               *InH2 = *On;
             Else;
               //                  CallP     $Allocate(OIITEM:OISIZE:OIQORD:'O')           Allocate
               Write RIORDR;
               ExSr Wrt_ALITEM;
               If TRSTAT = 'P';
                 ExSr Wrt_Partial;
               EndIf;
               If OIROY > 0;
      /END-FREE
     C                   Z-ADD     OIQORD        QTYOR
     C                   Z-ADD     OIQSHP        QTYSHP
     C                   Call      'GETROY'
     C                   PARM                    OICOMP
     C                   PARM                    OIORD#
     C                   PARM                    OISEQ#
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    QTYOR            11 1
     C                   PARM                    QTYSHP           11 1
     C                   PARM      *Blanks       DESCR            60
     C                   PARM                    ORUPRI            9 4
     C                   PARM                    OREXT$            9 2
     C                   Z-Add     ORUPRI        OIROY
      /FREE
               EndIf;
             EndIf;

           EndIf;                                                             // At least 1 (x)
         EndDo;
       EndSr;                                                                 //


       //   ...........................................................
       //   :      Wrt_Partial - Write Partial Comment Record         :
       //   :.........................................................:
       BegSr Wrt_Partial;                                                     //

         OISEQ# += 1;
         OIITYP = 'C';
         OIQORD = *Zero;
         OIQSHP = *Zero;
         OIUPRI = *Zero;
         OIEXT$ = *Zero;
         OIDES1 = PartText;
         Write RIORDR;

       EndSr;                                                                 //


       //   ...........................................................
       //   :      Wrt_ALITEM - Write Item Allocation Record          :
       //   :.........................................................:
       BegSr Wrt_ALITEM;                                                      //

      /END-FREE
      /Free
         For Loop = 1 to CountItem;
           If TRSTAT <> 'P';
             Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM) FDLOTRD_AR;
            Else;
             Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM:999997) FDLOTRD_AR;
           EndIf;

           If %Found(FDLOTRD_AR);
             LRQTAL += 1;
             LRQTAV -= 1;
             Update RDLOTRD_AR;
            Else;

             If TRSTAT <> 'P';
               Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM) FDLOTRD_NR;
              Else;
               Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM:999997) FDLOTRD_NR;
             EndIf;
             If %Found(FDLOTRD_AR);
               LRQTAL += 1;
               LRQTAV -= 1;
               LRDTLA  = $MDYDate($Date(0));
               LRTIME  = $Now();
               LRUSER  = 'RBR020_NR';
               Update RDLOTRD_AR;
              Else;
               If TRSTAT <> 'P';
                 Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM) FDLOTRD_X;
                Else;
                 Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM:999997) FDLOTRD_X;
               EndIf;
               If %Found(FDLOTRD_X);
                 LRQTAL += 1;
                 LRQTAV -= 1;
                 LRDTLA  = $MDYDate($Date(0));
                 LRTIME  = $Now();
                 LRUSER  = 'RBR020_AR';
                 Update RDLOTRD_X;
                Else;
                 LRSTAT = 'A';
                 LRITEM = TRITEM;
                 LRSIZE = TRSIZE;
                 LRWHSE = *Blanks;
                 LRSOWD = TRSCYM;
                 LRGLOC = 'X';
                 LRPHYT = *Blanks;
                 LRCRDY = TRCRDT;
                 LRCPHY = *Blanks;
                 LRCLOC = *Blanks;
                 LRCODE = *Blanks;
                 If TRSTAT = 'P';
                   LRCUST = 999997;
                  Else;
                   LRCUST = 000000;
                 EndIf;
                 LRAREA = *Blanks;
                 LRCOMP = 1;
                 LRQTOH = *Zero;
                 LRDTLA = $MDYDate($Date(0));
                 LRTIME = $Now();
                 LRUSER = 'RBR020_AR';
                 LRALPH = *Blanks;
                 LRPRCL = TRALPH;
                 LRQTAL = +1;
                 LRDESC = TRALPH;
                 LRQTCM = *Zero;
                 LRQTSL = *Zero;
                 LRQADJ = *Zero;
                 LRQTAV = -1;
                 Write RDLOTRD_X;
               EndIf;
             EndIf;
           EndIf;

           Clear RALITEM;

           AIORD# = OHORD#;
           AIOSEQ = OrderSeq#;
           AIITEM = IMITEM;
           AISIZE = IMSIZE;
           AISOWD = LRSOWD;
           AICRDY = LRCRDY;
           AICUST = LRCUST;
           AIGLOC = LRGLOC;

           Chain
            (AIORD#:AIOSEQ:AIITEM:AISIZE:AISOWD:AICRDY:AICUST:AIGLOC)
             FALITEML5;

           AIPHYT  = LRPHYT;
           AIWHSE  = LRWHSE;
           AISHPD  = ThisMonCYMD;
           AISTAT  = 'A';
           AICOMP  = 1;
           AIQTOA += 1;
           AIDTLA  = TodayMDY;
           AITIME  = Now;
           AIUSER  = User;
           AIPRCL  = IMPCL1;

           If %Found(FALITEML5);
             Update RALITEM;
            Else;
             Write RALITEM;
           Endif;
         EndFor;
      /End-Free
      /FREE
       EndSr;


       //   ...........................................................
       //   :      Wrt_OPNORD - Write Open Order Value Record         :
       //   :.........................................................:
       BegSr Wrt_OPNORD;                                                      //

         OOORD# = OHORD#;                                                     // ORDER NUMBER
         OOCOMP = 1;                                                          // COMPANY #
         OOCUST = SMCUST;                                                     // CUSTOMER #
         OODTRY = ThisMonCYMD;                                                // REQ. DATE CYMD
         OOORDY = TodayYMD7;                                                  // ORDER DATE CYMD
         OOARCU = CMARCU;                                                     // AR CUST #
         OOSACU = CMSACU;                                                     // SA CUST #
         OOBLCU = CMBLCU;                                                     // BILLING CUST #
         OOSHFR = CMTERR;                                                     // SHIP FROM
         OOEXT$ = TotalOrder;                                                 // ORDER VALUE

         Write ROPNORD;

       EndSr;                                                                 //


       //   ...........................................................
       //   :      *INZSR - Initialization Subroutine                 :
       //   :.........................................................:
       BegSr *INZSR;                                                          //

      /END-FREE
     C                   MOVE      ##PGM         $#PGMQ                          PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                          MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                          LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                          MESSAGE ID

     C                   Time                    Now                             Time Now
      /FREE
         Today = $Date(0);                                                    // Today MDY
         TodayMDY = $MDYDate(Today);                                          // Today MDY
         TodayYMD7 = $Date7(Today);                                           // Today CYMD7
         ThisMonday = $MDYDate($Monday(Today:'FRI'));                         // Monday MDY
         ThisMonCYMD = $Date7($Monday(Today:'FRI'));                          // Monday CYMD
         Printer = $DftPrt('*NONE':'RBR010':'*PGM');

         If Dummy;
           Chain OHORD# FHORDR;
      /END-FREE
     C     Dummy_Key     KList
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#
      /FREE
           Chain Dummy_Key FIORDR;
         EndIf;

         ExSr Load01;                                                         //
         ExSr Scrn01;                                                         //

       EndSr;                                                                 //
      /END-FREE
