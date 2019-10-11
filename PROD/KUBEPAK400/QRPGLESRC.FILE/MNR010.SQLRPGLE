     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      //??:````````````````````````````````````````````````````````````:?
      //??:            Manual Master                                   :?
      //??:............................................................:?
      //? :````````````````````````````````````````````````````````````:
      //? : Created:  April 2004           ? Kube-Pak Corporation ?    :
      //? :      by:  William J. Behr                                  :
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :   Program Description                                     ?:
      //? : ```````````````````````                                   ?:
      //? :                                                           ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Subroutine Usage                                        ?:
      //? :                                                           ?:
      //? :  Scrn01   -?Display Screen 01                             ?:
      //? :  Load01   -?Load Screen 01                                ?:
      //? :  Edit01   -?EDIT Screen 01                                ?:
      //? :  ClrError -?Clear Error MEssage Subfile                   ?:
      //? :  SndError -?Send an Error Message to the PGMMSGQ          ?:
      //? :  SRMSGF   -?Clear or send messages to Pgm msg queue       ?:
      //? :  *INZSR   -?Initialization Subroutine                     ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Function Usage                                          ?:
      //? :                                                           ?:
      //? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Indicator Usage                                         ?:
      //? :                                                           ?:
      //? :  01 - 24 ?Return Screen Functions                         ?:
      //? :  03      ?Exit                                            ?:
      //? :  06      ?Restart                                         ?:
      //? :          ?                                                ?:
      //? :  25      ?SFLDSP, SFLDSPCTL, SFLCLR(N)                    ?:
      //? :  26      ?SFLDSP (Subfile has Data)                       ?:
      //? :  27      ?SFLEND                                          ?:
      //? :  28      ?SFLNXTCHG                                       ?:
      //? :  40      ?Lookup Indicator                                ?:
      //? :  50      ?Error Indicator (All Errors)                    ?:
      //? :  70      ?Push Buttone Default 70 = Yes, N70 = No         ?:
      //? :  LR      ?Does this really need a description ?           ?:
      //? :............................................................:
     FMNR010FM  CF   E             WORKSTN
     F                                     SFILE(MNR01001:RRN01)
     F                                     SFILE(MNR01002:RRN02)
     F                                     SFILE(MNR01003:RRN03)
     F                                     SFILE(MNR01004:RRN04)
     F                                     SFILE(MNR01006:RRN06)
     F                                     DEVID(WSID)
     FMNR010P   O    E             PRINTER OFLIND(*IN60) USROPN

     FFMANUAL   UF A E           K DISK                                         ?Manual Master Head
     FFMANUALD  UF A E           K DISK                                         ?Manual Master Detl.
     FFTRSCHDCO IF   E           K DISK                                         ?Truck Schedule
     FFTRSCHD   IF   E           K DISK    Rename(RTRSCHD:RTRSCHD2)             ?Truck Schedule TRK#
     FFTRSCHDS  IF   E           K DISK    Rename(RTRSCHD:RTRSCHD3)             ?Truck Schedule Date
     FFFINLOC02 IF   E           K DISK                                         ?Finished Locations
     FFHORDRCSTMIF   E           K DISK                                         ?Custom Orders
     FFMSTCRTS  UF A E           K DISK                                         ?Master Carts File

     D PrintFinPick    PR                  ExtPgm('PCK030CL')
     D  #ThisDate7                    7P 0 Const
     D  #ThisMaster                   2P 0 Const
     D  #Printer                     10A   Const

     D PRTCRTREQR      PR                  ExtPgm('BIR106')
     D  #PRINTER                     10A   Const
     D  #DateMMDDYY                   6P 0 Const
     D  #Master                       2P 0 Const

     D ReleaseMM       PR                  ExtPgm('MNR020')                     Release Man. Master
     D  #DATE7#                            CONST Like(MNDATE)
     D  #MAST#                             CONST Like(MNSEQ#)

     D GetCarts        PR                  ExtPgm('BIR103CL')
     D  #OIDTRQ                       6P 0 Const
     D  #OIORD#                       6P 0 Const
     D  #QTCART                       5P 2
     D  #SHOWYN                       1A   Const
     D  #CART01                       3P 0
     D  #CART02                       3P 0
     D  #CART03                       3P 0
     D  #CART04                       3P 0
     D  #CART05                       3P 0
     D  #CART06                       3P 0
     D  #CART07                       3P 0
     D  #CART08                       3P 0
     D  #CART09                       3P 0
     D  #CART10                       3P 0
     D  #CART11                       3P 0
     D  #CART12                       3P 0
     D  #CART13                       3P 0
     D  #CART14                       3P 0
     D  #CART15                       3P 0

     DDockPickByGroup  PR                  ExtPgm('PCK050CL9')
     D  #SelDate                      6P 0 CONST
     D  #SelMast                      2P 0 CONST
     D  #SelGrup                     10    CONST
     D  #SelTruk                      4    CONST
     D  #SelList                      6    CONST
     D  #Printer                     10    CONST
     D  #SelCopy                      2P 0 CONST


      //? Function Prototypes
     D/COPY QFunctDefn,$_Dates
     D/COPY QFunctDefn,$Monday
     D/COPY QFunctDefn,QCmdExc
     D/COPY QFunctDefn,$NeedDir
     D/COPY QFunctDefn,$Center
     D/COPY QFunctDefn,$isPrinter
     D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$PlugOrd

      //? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

     D LDA_DS          DS                  DTAARA(*LDA)
     D  UDSEXT              1000   1000
     D  UDSDAT              1001   1004P 0
     D  UDSTRK              1005   1008

     D RTRSCHD_DS    E DS                  ExtName(FTRSCHD)
     D FMORLS_DS     E DS                  ExtName(FMORLS)

     D Screen03DS      DS
     D  C3_IMITEM                          Like(IMITEM )
     D  C3_IMSIZE                          Like(IMSIZE )
     D  C3_OLLIST                          Like(OLLIST )
     D  C3_OLSEQ#                          Like(OLSEQ# )
     D  C3_OLLOOK                          Like(OLLOOK )
     D  C3_ItemQty                         Like(ItemQty)
     D  C3_IMDES1                          Like(IMDES1 )
     D  C3_IMLOOK                          Like(IMLOOK )

     D Screen04DS      DS
     D  C4_OHROUT                          Like(OHROUT )
     D  C4_OHSTOP                          Like(OHSTOP )
     D  C4_OHORD#                          Like(OHORD# )
     D  C4_OHCUST                          Like(OHCUST )
     D  C4_OHNAME                          Like(OHNAME )
     D  C4_ORDQTY                          Like(ORDQTY )

     D Screen06DS      DS
     D  C6_MNDATE                          Like(MNDATE)
     D  C6_MNSEQ#                          Like(MNSEQ#)
     D  C6_MNSEQD                          Like(MNSEQD)
     D  C6_OIALPF                    15A
     D  C6_OIORD#                     6S 0
     D  C6_OISEQ#                     3S 0
     D  C6_OISIZE                     3A
     D  C6_OIITEM                    12A
     D  C6_OIDES1                    30A
     D  C6_QTYONORDER                11S 2


      //? Field Definitions
     D   Screen        S              2  0 Inz(0)                               Current Screen
     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   RRN02         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   RRN03         S              4  0 Inz(0)                               ?SFLRRN Screen 03
     D   RRN04         S              4  0 Inz(0)                               ?SFLRRN Screen 04
     D   RRN06         S              4  0 Inz(0)                               ?SFLRRN Screen 06
     D   Today         S               D                                        ?Today
     D   SDate         S              6S 0 Inz(0)                               ?Ship Date MDY
     D   SDelt         S              6S 0 Inz(0)                               ?Delete Date MDY
     D   SDateYMD7     S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   SDeltYMD7     S              7S 0 Inz(0)                               ?Delete Date YMD7
     D   ErrCount      S              3S 0 Inz(0)                               ?Error Count
     D   SavePRTR      S             10A                                        ?Save Curr PRTR
     D   Command       S            100A   Inz(*Blanks)                         ?System Command
     D   NewSeq        S                   Like(MNSEQ#)                         ?Next Seq #
     D   X             S              4S 0                                      ?Generic Counter
     D   LastOHCUST    S                   Like(OHCUST)                         ?Last OHCUST
     D   HoldORDQTY    S                   Like(ORDQTY)                         ?Hold ORDQTY
     D   HoldOHNAME    S                   Like(OHNAME)                         ?Hold OHNAME
     D   HoldOHROUT    S                   Like(OHROUT)                         ?Hold OHROUT
     D   HoldOHSTOP    S                   Like(OHSTOP)                         ?Hold OHSTOP
     D   CustTot       S              6  0
     D   GrandTot      S             11  0
     D   GrandTot06    S             11  0
     D   OVRPRTF       S            256A   Inz(' ')
     D   CARTS         S              5P 2 Inz(0)
     D   MNDATE6       S              6P 0 Inz(0)
     D   Loop          S              4P 0 Inz(0)
     D   Last_OLLIST   S                   Like(OLLIST)
     D   RC_DESC       S             15A

      //? Indicators
     D   EndOfFile03   S               N   Inz(*Off)                            ?%EOF for C3
     D   EndOfFile04   S               N   Inz(*Off)                            ?%EOF for C4
     D   EndOfFile06   S               N   Inz(*Off)                            ?%EOF for C6
     D   FirstPage     S               N   Inz(*Off)                            ?First Page of Print


      /FREE
    ?  DOU *INLR = *ON;                                                       //?COMMENT

    ?    SELECT;
    ?    WHEN Screen = 01;
    ?      ExSr Edit01;
    ?    WHEN Screen = 02;
    ?      ExSr Edit02;
    ?    WHEN Screen = 03;
           ExSr Edit03;
         WHEN Screen = 04;
           ExSr Edit04;
         WHEN Screen = 05;
           ExSr Edit05;
         WHEN Screen = 06;
           ExSr Edit06;
         OTHER;
           ExSr DeleteOld;
           ExSr Load01;
           ExSr Scrn01;
         ENDSL;

       ENDDO;

       //?  ...........................................................
       //?  :      Scrn01 - Display Screen 01                         :
       //?  :.........................................................:
       BegSr Scrn01;
        Screen = 1;
         *In25 = *On;
         Write ASSUME;
         Write MNR01001F;
         Write MSGCTL;
         ExFmt MNR01001C;
         ExSr ClrError;
         *In25 = *Off;
       EndSr;
       //?  ...........................................................
       //?  :      Load01 - Load Screen 01                            :
       //?  :.........................................................:
       BegSr Load01;

         If PRINTER = ' ';
           Printer = $DftPrt($User():'MNR010':'*USER');
           OVRPRTF = 'OVRPRTF FILE(MNR010P) FORMTYPE(*NAR) ' +
            'CPI(10) PAGRTT(0) OVRSCOPE(*JOB) '     +
            'OUTQ(' + %trim(PRINTER) + ')';
           QCmdExc(OVRPRTF : %len(%trim(OVRPRTF)));
         EndIf;

         //? Clear the Subfile
         *In25 = *Off;
         *In26 = *Off;
         *In27 = *Off;
         Write MNR01001C;

         //? Load the Subfile
        *In28 = *On;                                                         //?Write w/ SFLNXTCHG
        RRN01 = *Zero;
         SetLL SDateYMD7 FMANUAL;
         ReadE SDateYMD7 FMANUAL;
         DoW not %EOF(FMANUAL );
           ExSr SQLCount;
          RRN01 += 1;
           Write MNR01001;
           ReadE SDateYMD7 FMANUAL;
         EndDo;

         Clear MNR01001;
        RRN01 += 1;
        *In27 = *On;                                                         //?SFLEND Indicator
        *In26 = *On;
         Write MNR01001;

       EndSr;
       //?  ...........................................................
       //?  :      Edit01 - EDIT Screen 01                            :
       //?  :.........................................................:
       BegSr Edit01;

          SELECT;
           //? Exit Requested
          When *In03 = *ON;
           *INLR = *On;
           LeaveSR;
           //? When Date is invalid
         When not $isDate#(SDATE:'*MDY');
           $#MSID = 'DATE901';
           $#MSGD = %EditW(SDATE:'      ');
           EXSR SndError;
           *In26 = *Off;                                                      //?Do not Display SFL
           ExSr Scrn01;
           //? When Date is Changed
         When $DateMDY(SDate) <> $Date(SDateYMD7);
           SDateYMD7 = $Date7($DateMDY(SDate));
           ExSr Load01;
           ExSr Scrn01;
           //? When Previous Date is Requested
         When *In08 = *ON;
           SDate=$MDYDate($AddDate($DateMDY(SDate):-1));
           SDateYMD7 = $Date7($DateMDY(SDate));
           ExSr Load01;
           ExSr Scrn01;
           //? When Next Date is Requested
         When *In09 = *ON;
           SDate=$MDYDate($AddDate($DateMDY(SDate):+1));
           SDateYMD7 = $Date7($DateMDY(SDate));
           ExSr Load01;

           ExSr Scrn01;
           //? When Refresh is Requested
         When *In05 = *ON;
           ExSr Load01;
           ExSr Scrn01;
           //? When Delete is Requested
         When *In23 = *ON;
           Chain SFLCSRRRN MNR01001;
           Chain (MNDATE:MNSEQ#) FMANUAL;
           If %Found(FMANUAL);
             Delete RMANUAL;
           EndIF;
           ExSr Load01;
           ExSr Scrn01;
           //? When Orders is Requested
         When *In10 = *ON;
           Chain SFLCSRRRN MNR01001;
           ExSr Load02;
           ExSr Scrn02;
           //? If no Functions, Check for Options and Re-display
         OTHER;
           ReadC MNR01001;
           *In28 = *On;

           DoW not %EOF(MNR010FM);
             Select;
             When MNSEQ# = *Zero and MNSEQD <> *Blanks;
               SetGT SdateYMD7 FMANUAL;
               ReadPE SdateYMD7 FMANUAL;
               NewSeq = MNSEQ# + 1;
               Chain RRN01 MNR01001;
               MNSEQ# = NewSeq;
               MNDATE = SDateYMD7;
               Write RMANUAL;
             When MNSEQ# <> *Zero;
               Chain (MNDATE:MNSEQ#) FMANUAL;
               Chain RRN01 MNR01001;
               Update RMANUAL;
             EndSL;
             Update MNR01001;
             ReadC MNR01001;
           EndDo;

           ExSr Load01;
           ExSr Scrn01;
         ENDSL;

       EndSr;

       //?  ...........................................................
       //?  :      Scrn02 - Display Screen 02                         :
       //?  :.........................................................:
       BegSr Scrn02;
         Screen= 02;
         *In25 = *On;
         Write ASSUME;
         Write MNR01002F;
         Write MSGCTL;
         ExFmt MNR01002C;
         ExSr ClrError;
         *In25 = *Off;
       EndSr;
       //?  ...........................................................
       //?  :      Load02 - Load Screen 02                            :
       //?  :.........................................................:
       BegSr Load02;

         MNSEQDc = $Center(MNSEQD:35);
         //? Clear the Subfile
         *In25 = *Off;
         *In26 = *Off;
         *In27 = *Off;
         Write MNR01002C;

         //? Load the Subfile
         *In28 = *On;                                                         //?Write w/ SFLNXTCHG
         RRN02 = *Zero;
         SetLL (MNDATE:MNSEQ#) FMANUALD;
         ReadE (MNDATE:MNSEQ#) FMANUALD;
         DoW not %EOF(FMANUALD);
         RRN02 += 1;
         SavMNORD# = MNORD#;
         Write MNR01002;
         ReadE (MNDATE:MNSEQ#) FMANUALD;
         EndDo;

         MNORD#    = *Zero;
         SavMNORD# = *Zero;
         DoW RRN02 < 165;
           RRN02 += 1;
           Write MNR01002;
         EndDo;
         *In26 = *On;
         Chain RRN02 MNR01002;
         *In27 = *On;                                                         //?SFLEND Indicator
         Update MNR01002;

       EndSr;
       //?  ...........................................................
       //?  :      Edit02 - EDIT Screen 02                            :
       //?  :.........................................................:
       BegSr Edit02;

         SELECT;
           //? Exit Requested
         When *In03 = *ON;
           *InLR = *On;
           LeaveSR;
           //? When Refresh is Requested
         When *In05 = *ON;
           ExSr Load02;
           ExSr Scrn02;
           // When Change Printer
         When *In10;
           ExSr PrinterSR;
           ExSr Scrn02;
           //? When Previous is Requested
         When *In12 = *ON;
           ExSr Load01;
           ExSr Scrn01;
           //? When Print Pics is Selected
         When PrintMe = 1;
           ExSr Prnt02;
           ExSr Scrn02;
           //? When Print Carts is Selected
         When PrintMe = 5;
           ExSr PrintCarts;
           ExSr Scrn02;
           //? When View Master is Selected
         When ViewMe = 03;
           ExSr Load03;
           ExSr Scrn03;
           //? When View Summary is Selected
         When ViewMe = 04;
           ExSr Load04;
           ExSr Scrn04;
           //? When Import is Selected
         When IMPORT = 1;
           ExSr Load05;
           ExSr Scrn05;
           //? When Release is Selected
         When RELEASE = 1;
           ReleaseMM(MNDATE:MNSEQ#);  //MNR020 processes release MM function
           ExSr Scrn02;
           //? If no Functions, Check for Options and Re-display
         OTHER;
           ReadC MNR01002;
           *In28 = *On;

           DoW not %EOF(MNR010FM);
             Select;
               //?      Entry Changed
             When SavMNORD# <> MNORD#
                   and MNORD# <> *Zero
                   and SavMNORD# <> *Zero;
               SetLL (MNDATE:MNSEQ#:MNORD#) FMANUALD;
               If not %Equal(FMANUALD);
                 Write RMANUALD;
               EndIf;
               Chain (MNDATE:MNSEQ#:SavMNORD#) FMANUALD;
               If %Found(FMANUALD);
                 Delete FMANUALD;
               EndIf;
               //?      Entry Deleted
             When SavMNORD# <> MNORD#
                   and MNORD# = *Zero
                   and SavMNORD# <> *Zero;
               Chain (MNDATE:MNSEQ#:SavMNORD#) FMANUALD;
               If %Found(FMANUALD);
                 Delete FMANUALD;
               EndIf;
         //?      New Entry
             When SavMNORD# <> MNORD#
                   and MNORD# <> *Zero
                   and SavMNORD# = *Zero;
               SetLL (MNDATE:MNSEQ#:MNORD#) FMANUALD;
               If not %Equal(FMANUALD);
                 Write RMANUALD;
               EndIf;
             EndSL;
             SavMNORD# = MNORD#;
             Update MNR01002;
             ReadC MNR01002;
           EndDo;

           ExSr Load02;
           ExSr Scrn02;
         ENDSL;

       EndSr;


       //?  ...........................................................
       //?  :      Prnt02 - Print Screen 02                           :
       //?  :.........................................................:
       BegSr Prnt02;

         //PrintFinPick(MNDATE:MNSEQ#:Printer);
         DockPickByGroup(SDATE:MNSEQ#:'*ALL':'*ALL':'*ALL':PRINTER:1);

       EndSr;

       //?  ...........................................................
       //?  :      Scrn03 - Display Screen 03                         :
       //?  :.........................................................:
       BegSr Scrn03;
         Screen = 03;
         *In25 = *On;
         Write ASSUME;
         Write MNR01003F;
         Write MSGCTL;
         ExFmt MNR01003C;
         ExSr ClrError;
         *In25 = *Off;
       EndSr;
       //?  ...........................................................
       //?  :      Load03 - Load Screen 03                            :
       //?  :.........................................................:
       BegSr Load03;


         //? Clear the Subfile
         *In25 = *Off;
         *In26 = *Off;
         *In27 = *Off;
         Write MNR01003C;
         GrandTot = *Zero;

         //? Load the Subfile
         *In28 = *On;                                                         //?Write w/ SFLNXTCHG
         RRN03 = *Zero;
         ExSr GetData03;
         ExSr ReadData03;
         DoW not EndOfFile03;
           RRN03 += 1;
           GrandTot += ItemQty;
           ITEM5 = %Subst(IMITEM:1:5);
           *In42 = *off; // RC_OR_LOC Color GRN
           *In43 = *off; // RC_OR_LOC Color YLW
           *In44 = *off; // RC_OR_LOC Color PNK
           *In45 = *off; // RC_OR_LOC Color RED

           // Get Ready Color
           Exec SQL
             Select coalesce(OLRDYC,' ')
                  , coalesce(TBSHRT,'*RC NOT LISTED*')
             Into :RC_CODE, :RC_DESC
             from fmorls
             left outer join XATABE1 on OLRDYC = TBC6 and TBTB = 'RC'
             Where OLITEM = :IMITEM and OLSIZE = :IMSIZE;
           Select;
           When RC_CODE = 'READY'
             or RC_CODE = 'R C';
             *In42 = *on;           // GREEN
           When RC_CODE = 'C C'
             or RC_CODE = 'R B'
             or RC_CODE = 'R L C'
             or RC_CODE = 'CC-SM'
             or RC_CODE = 'RB-SM'
             or RC_CODE = 'RC-SM';
             *In44 = *on;           // PINK
           When RC_CODE = 'R GR'
             or RC_CODE = 'GONE'
             or RC_CODE = 'N R';
             *In45 = *on;           // RED
           Other;
             *In43 = *on;           // YELLOW
           ENDSL;

           // Get Location
           Chain (IMITEM:IMSIZE) FFINLOC02;
           If %Found(FFINLOC02);
             LOCATION = %Trim(%EditC(FLSECT:'Z')) + '-' +
               %Trim(%EditC(FLBAY :'Z')) + FLNORS + FLEORW;
             Else;
               LOCATION = *Blanks;
           EndIf;


           If *In62; // *In62 = ShowReadyColor
             *In41 = *off; // RC_OR_LOC Color BLU
             RC_OR_LOC = RC_DESC;
            Else; // Then Show Location
             *In41 = *On; // RC_OR_LOC Color BLU
             RC_OR_LOC = LOCATION;
           ENDIF;



           Write MNR01003;
           ExSr ReadData03;
         EndDo;
         ExSr CloseData03;

         Clear MNR01003;
         RRN03 += 1;
         *In27 = *On;
         *In26 = *On;
         EVAL IMDES1 = '<== Grand Total';
         ItemQty = GrandTot;
         Write MNR01003;

       EndSr;
       //?  ...........................................................
       //?  :      Edit03 - EDIT Screen 03                            :
       //?  :.........................................................:
       BegSr Edit03;

         SELECT;
           //? Exit Requested
         When *In03 = *ON;
           *InLR = *On;
           LeaveSR;
           // When Change Printer
         When *In10;
           ExSr PrinterSR;
           ExSr Scrn03;
           //? When Previous is Requested
         When *In12 = *ON;
           ExSr Load02;
           ExSr Scrn02;
           //? When Refresh is Requested
         When *In05 = *ON;
           ExSr Load03;
           ExSr Scrn03;
           //? When Toggle RC/Location is Requested
         When *In06 = *ON;
           *In62 = not *In62;
           ExSr Load03;
           ExSr Scrn03;
           //? When Print Master is Selected
         When PrintMe = 03;
           ExSr Prnt03;
           ExSr Scrn03;
           //? When Print Summary is Selected
         When PrintMe = 04;
           ExSr Load04;
           ExSr Prnt04;
           ExSr Scrn03;
           //? When Print Carts is Selected
         When PrintMe = 05;
           ExSr PrintCarts;
           ExSr Scrn03;
           //? When Cart Chart is Selected
         When PrintMe = 06;
           ExSr Load06;
           ExSr Scrn06;
           //? If no Functions, Check for Options and Re-display
         OTHER;
           ReadC MNR01003;
           *In28 = *On;

           DoW not %EOF(MNR010FM);
             Select;
             When MNSEQ# = *Zero and MNSEQD <> *Blanks;
               SetGT SdateYMD7 FMANUAL;
               ReadPE SdateYMD7 FMANUAL;
               NewSeq = MNSEQ# + 1;
               Chain RRN03 MNR01003;
               MNSEQ# = NewSeq;
               MNDATE = SDateYMD7;
               Write RMANUAL;
             When MNSEQ# <> *Zero;
               Chain (MNDATE:MNSEQ#) FMANUAL;
               Chain RRN03 MNR01003;
               Update RMANUAL;
             EndSL;
             Update MNR01003;
             ReadC MNR01003;
           EndDo;

           ExSr Load03;
           ExSr Scrn03;
         ENDSL;

       EndSr;

       //?  ...........................................................
       //?  :      Prnt03 - Print Screen 03                           :
       //?  :.........................................................:
       BegSr Prnt03;

         If not %OPEN(MNR010P);
           Open MNR010P;
         EndIf;
         RRN03 = 1;
         FirstPage = *On;
         Last_OLLIST = *Blanks;
         Chain RRN03 MNR01003;
         DoW %Found(MNR010FM);
           If FirstPage or *In60 or OLLIST <> Last_OLLIST;
             ORDERLIST = 'Items not on an Order List';
             Exec SQL //
               SELECT HLLIST||' - '||HLDESC INTO :ORDERLIST
               FROM fmorlh WHERE HLLIST = :OLLIST;
             Write MNR01003H;
             FirstPage = *Off;
             Last_OLLIST = OLLIST;
             *In60     = *Off;
           EndIf;
           Write MNR01003P;
           RRN03 = RRN03 + 1;
           Chain RRN03 MNR01003;
         EndDo;
         If %OPEN(MNR010P);
           Close MNR010P;
         EndIf;

       EndSr;

       //?  ...........................................................
       //?  :      GetData03 -  Get selected Open information         :
       //?  :.........................................................:

       BegSr GetData03;

         //exec sql

         //  DECLARE
         //          C3 cursor for

         //  SELECT
         //          FMINVT.IMITEM
         //       ,  FMINVT.IMSIZE
         //       ,  FMSIZE.SZDESC
         //       ,  SUM(FIORDR.OIQORD - FIORDR.OIQSHP)
         //       ,  FMINVT.IMDES1
         //       ,  FMINVT.IMLOOK

         //  FROM
         //          FMANUAL
         //     ,    FMANUALD
         //     ,    FIORDR
         //     ,    FMINVT
         //     ,    FMSIZE

         //  WHERE
         //          FMANUAL.MNDATE  = :SDateYMD7
         //    and   FIORDR.OIRVDT   = :SDateYMD7
         //    and   FMANUAL.MNSEQ#  = :MNSEQ#

         //    and   FMANUAL.MNDATE  = FMANUALD.MNDATE
         //    and   FMANUAL.MNSEQ#  = FMANUALD.MNSEQ#
         //    and   FMANUALD.MNORD# = FIORDR.OIORD#
         //    and   FIORDR.OIITEM   = FMINVT.IMITEM
         //    and   FIORDR.OISIZE   = FMINVT.IMSIZE
         //    and   FMINVT.IMSIZE   = FMSIZE.SZCODE

         //  GROUP BY
         //          IMSIZE
         //       ,  IMLOOK
         //       ,  IMITEM
         //       ,  SZDESC
         //       ,  IMDES1

         //  ORDER BY
         //          IMSIZE
         //       ,  IMLOOK
         //       ,  IMITEM
         //       ,  SZDESC
         //       ,  IMDES1
         //
         //For Read only;
    ?  //NEW
         exec sql   DECLARE C3 cursor for
    ?      SELECT   OLITEM
    ?           ,   OLSIZE
    ?           ,   OLLIST
    ?           ,   OLSEQ#
    ?           ,   OLLOOK
    ?           ,   SUM(FIORDR.OIQORD - FIORDR.OIQSHP)
    ?           ,   FMINVT.IMDES1
    ?           ,   FMINVT.IMLOOK
    ?      FROM     FMANUAL,
                    FMANUALD,
                    FIORDR,
                    FMINVT,
                    FMSIZE,
                    FMORLSj1 as fmorls
    ?      WHERE    FMANUAL.MNDATE  = :SDateYMD7
    ?        and    FIORDR.OIRVDT   = :SDateYMD7
    ?        and    FMANUAL.MNSEQ#  = :MNSEQ#
    ?        and    FMANUAL.MNDATE  = FMANUALD.MNDATE
    ?        and    FMANUAL.MNSEQ#  = FMANUALD.MNSEQ#
    ?        and    FMANUALD.MNORD# = FIORDR.OIORD#
    ?        and    FIORDR.OIITEM   = FMINVT.IMITEM
    ?        and    FIORDR.OISIZE   = FMINVT.IMSIZE
    ?        and    FIORDR.OIITEM   = FMORLS.OLITEM
    ?        and    FIORDR.OISIZE   = FMORLS.OLSIZE
    ?        and    FMINVT.IMSIZE   = FMSIZE.SZCODE
    ?      GROUP BY OLLIST,OLSEQ#,OLLOOK,OLITEM,OLSIZE,OLWHSE,IMDES1,IMLOOK
    ?
    ?        UNION
    ?
    ?      SELECT   IMITEM
    ?           ,   IMSIZE
    ?           ,   '999999' AS OLLIST
    ?           ,   0        AS OLSEQ#
    ?           ,   IMLOOK   AS OLLOOK
    ?           ,   SUM(FIORDR.OIQORD - FIORDR.OIQSHP)
    ?           ,   FMINVT.IMDES1
    ?           ,   FMINVT.IMLOOK
    ?      FROM     FMANUAL, FMANUALD, FIORDR, FMINVT, FMSIZE
    ?      WHERE    FMANUAL.MNDATE  = :SDateYMD7
    ?        and    FIORDR.OIRVDT   = :SDateYMD7
    ?        and    FMANUAL.MNSEQ#  = :MNSEQ#
    ?        and    FMANUAL.MNDATE  = FMANUALD.MNDATE
    ?        and    FMANUAL.MNSEQ#  = FMANUALD.MNSEQ#
    ?        and    FMANUALD.MNORD# = FIORDR.OIORD#
    ?        and    FIORDR.OIITEM   = FMINVT.IMITEM
    ?        and    FIORDR.OISIZE   = FMINVT.IMSIZE
    ?        and    FMINVT.IMSIZE   = FMSIZE.SZCODE
    ?        and    IMITEM||IMSIZE not in (Select OLITEM||OLSIZE from FMORLSj1)
    ?      GROUP BY IMSIZE, IMITEM, IMLOOK, IMDES1
    ?
           ORDER BY OLLIST, OLSEQ#, OLLOOK
           For Read only;

         //  Open the SQL recordset for Screen 03
         exec sql        Open      C3;

       EndSr;

       //?  ...........................................................
       //?  :      CloseData03 - Close the Data Set                   :
       //?  :.........................................................:

       BegSr CloseData03;

         //  Close the SQL recordset for Screen 01
         exec sql        Close     C3;

       EndSr;

       //?  ...........................................................
       //?  :      ReadData03 - Read In Screen 03 Data                :
       //?  :.........................................................:

       BegSr ReadData03;

         //  Read Master Info
         Exec Sql Fetch C3 into :Screen03DS;

         If SQLSTT = '02000';   //?Read until EOF
           EndOfFile03 = *On;
         Else;
           EndOfFile03 = *Off;
           IMITEM  = C3_IMITEM;
           IMSIZE  = C3_IMSIZE;
           OLLIST  = C3_OLLIST;
           OLSEQ#  = C3_OLSEQ#;
           OLLOOK  = C3_OLLOOK;
           ItemQty = C3_ItemQty;
           IMDES1  = C3_IMDES1;
           IMLOOK  = C3_IMLOOK;
         EndIf;

       EndSr;

       //?  ...........................................................
       //?  :      Scrn04 - Display Screen 04                         :
       //?  :.........................................................:
       BegSr Scrn04;
         Screen = 04;
         *In25 = *On;
         Write ASSUME;
         Write MNR01004F;
         Write MSGCTL;
         ExFmt MNR01004C;
         ExSr ClrError;
         *In25 = *Off;
       EndSr;
       //?  ...........................................................
       //?  :      Load04 - Load Screen 04                            :
       //?  :.........................................................:
       BegSr Load04;

         //? Clear the Subfile
         *In25 = *Off;
         *In26 = *Off;
         *In27 = *Off;
         Write MNR01004C;
         CustTot  = *Zero;
         GrandTot = *Zero;

         //? Load the Subfile
         *In28 = *On;                                                         //?Write w/ SFLNXTCHG
         RRN04 = *Zero;
         ExSr GetData04;
         ExSr ReadData04;
         DoW not EndOfFile04;
           If OHCUST <> LastOHCUST and RRN04 <> *Zero;
             HoldORDQTY = ORDQTY;
             HoldOHNAME = OHNAME;
             HoldOHROUT = OHROUT;
             HoldOHSTOP = OHSTOP;
             ORDQTY = CustTot;
             EVALR OHNAME = 'Cust Tot==>';
             RRN04 += 1;
             *In29 = *On;
             Write MNR01004;
             *In29 = *Off;
             ORDQTY = HoldORDQTY;
             OHNAME = HoldOHNAME;
             OHROUT = HoldOHROUT;
             OHSTOP = HoldOHSTOP;
             CustTot = *Zero;
           EndIf;
           LastOHCUST = OHCUST;
           TR_RTSP = '00-0';
           OH_RTSP = '00-0';
           TRSTP#  = 0;
           OHSTOP  = 0;
           Chain (SdateYMD7:OHCUST:OHORD#) FTRSCHDCO;
           If %Found(FTRSCHDCO);
             TR_RTSP = %Trim(TRTRK#) +'-'+ %Trim(%editc(TRSTP#:'Z'));
             OH_RTSP = %Trim(OHROUT) +'-'+ %Trim(%editc(OHSTOP:'Z'));
           EndIf;
           RRN04    += 1;
           GrandTot += OrdQty;
           CustTot  += OrdQty;
           Write MNR01004;
           ExSr ReadData04;
         EndDo;
         ExSr CloseData04;

         ORDQTY = CustTot;
         EVALR OHNAME = 'Cust Tot==>';
         RRN04    += 1;
         *In29 = *On;
         Write MNR01004;
         Clear MNR01004;
         RRN04    += 1;
         *In27 = *On;                                                         //?SFLEND Indicator
         *In26 = *On;
         EVALR OHNAME = 'Grand Total===>';
         ORDQTY = GrandTot;
         Write MNR01004;
         *In29 = *Off;

       EndSr;
       //?  ...........................................................
       //?  :      Edit04 - EDIT Screen 04                            :
       //?  :.........................................................:
       BegSr Edit04;

         SELECT;
           //? Exit Requested
         When *In03 = *ON;
           *InLR = *On;
           LeaveSR;
           //? When Previous is Requested
         When *In12 = *ON;
           ExSr Load02;
           ExSr Scrn02;
           //? When Refresh is Requested
         When *In05 = *ON;
           ExSr Load04;
           ExSr Scrn04;
           // When Change Printer
         When *In10;
           ExSr PrinterSR;
           ExSr Scrn04;
           //? When Print Master is Selected
         When PrintMe = 03;
           ExSr Load03;
           ExSr Prnt03;
           ExSr Scrn04;
           //? When Print Summary is Selected
         When PrintMe = 04;
           ExSr Prnt04;
           ExSr Scrn04;
           //? When Cart Chart is Selected
         When PrintMe = 05;
           ExSr PrintCarts;
           ExSr Scrn04;
           //? If no Functions, Check for Options and Re-display
         OTHER;
           ReadC MNR01004;
           *In28 = *On;

           DoW not %EOF(MNR010FM);
             Select;
             When MNSEQ# = *Zero and MNSEQD <> *Blanks;
               SetGT SdateYMD7 FMANUAL;
               ReadPE SdateYMD7 FMANUAL;
               NewSeq = MNSEQ# + 1;
               Chain RRN04 MNR01004;
               MNSEQ# = NewSeq;
               MNDATE = SdateYMD7;
               Write RMANUAL;
             When MNSEQ# <> *Zero;
               Chain (MNDATE:MNSEQ#) FMANUAL;
               Chain RRN04 MNR01004;
               Update RMANUAL;
             EndSL;
             Update MNR01004;
             ReadC MNR01004;
           EndDo;

           ExSr Load04;
           ExSr Scrn04;
         ENDSL;

       EndSr;

       //?  ...........................................................
       //?  :      PrintCarts - Print Cart Report                     :
       //?  :.........................................................:
       BegSr PrintCarts;

         Exec SQL // Clear this Date/Master from the FMSTCRTS file
           Delete
           from    FMSTCRTS
           Where   OIRVDT = :SDateYMD7
             and   MASTER = :MNSEQ#;

         // Read through MNR01001 Subfile and process all orders
         Loop = RRN02;
         MNDATE6 = $MDYDate($Date(MNDATE));
         For x = 1 to Loop;
           Chain x MNR01002;
           If MNORD# <> 0;
             Chain (MNDATE:MNSEQ#:MNORD#) FMSTCRTS;
             // Get Truck Info
             Exec SQL //
               Select   *
               into    :RTRSCHD_DS
               from     FTRSCHD
               Where    TRSHDT = :MNDATE
                 and    TRORD# = :MNORD#
               Fetch First Row Only;
             // Call BIR103 to get cart information
             GetCarts(MNDATE6:MNORD#:Carts:'N'
                      :CART01
                      :CART02
                      :CART03
                      :CART04
                      :CART05
                      :CART06
                      :CART07
                      :CART08
                      :CART09
                      :CART10
                      :CART11
                      :CART12
                      :CART13
                      :CART14
                      :CART15);
             If %Found(FMSTCRTS);
               Update RMSTCRTS;
              Else;
               OIRVDT = MNDATE;
               MASTER = MNSEQ#;
               OIORD# = MNORD#;
               OICUST = TRCUST;
               //TRTRK# = TRTRK#;
               //TRSTOP = TRSTOP;
               Write RMSTCRTS;
             EndIf;
           EndIf;
         EndFor;
         PRTCRTREQR(PRINTER:MNDATE6:MNSEQ#);
       EndSr;

       //?  ...........................................................
       //?  :      Prnt04 - Print Screen 04                           :
       //?  :.........................................................:
       BegSr Prnt04;

         If not %OPEN(MNR010P);
           Open MNR010P;
         EndIf;
         RRN04 = 1;
         FirstPage = *On;
         Chain RRN04 MNR01004;
         DoW %Found(MNR010FM);
           If FirstPage or *In60;
             Write MNR01004H;
             FirstPage = *Off;
             *In60     = *Off;
           EndIf;
           If %Trim(OHNAME) = 'Cust Tot==>' or
                 %Trim(OHNAME) = 'Grand Total===>';
             *In61 = *On;
             Write MNR01004U;
           Else;
             *In61 = *Off;
           EndIf;
           Write MNR01004P;
           RRN04 = RRN04 + 1;
           Chain RRN04 MNR01004;
         EndDo;
         If %OPEN(MNR010P);
           Close MNR010P;
         EndIf;

       EndSr;

       //?  ...........................................................
       //?  :      GetData04 -  Get selected Open information         :
       //?  :.........................................................:

       BegSr GetData04;

       exec sql
           DECLARE
                   C4 cursor for
           SELECT
                   FHORDR.OHROUT
                ,  FHORDR.OHSTOP
                ,  FHORDR.OHORD#
                ,  FHORDR.OHCUST
                ,  FHORDR.OHNAME
                ,  SUM(FIORDR.OIQORD - FIORDR.OIQSHP)
           FROM
                   FHORDR
              ,    FIORDR
              ,    FMANUALD
           WHERE
                   FIORDR.OIRVDT    = :SDateYMD7
             and   FMANUALD.MNDATE  = :SDateYMD7
             and   FMANUALD.MNSEQ#  = :MNSEQ#
             and   FMANUALD.MNORD# = FHORDR.OHORD#
             and   FHORDR.OHORD#   = FIORDR.OIORD#
           GROUP BY
                   FHORDR.OHROUT
                ,  FHORDR.OHSTOP
                ,  FHORDR.OHORD#
                ,  FHORDR.OHCUST
                ,  FHORDR.OHORD#
                ,  FHORDR.OHNAME
           ORDER BY
                   FHORDR.OHROUT
                ,  FHORDR.OHSTOP
                ,  FHORDR.OHORD#
           For Read only;

         //  Open the SQL recordset for Screen 04
         exec sql        Open      C4;

       EndSr;

       //?  ...........................................................
       //?  :      CloseData04 - Close the Data Set                   :
       //?  :.........................................................:

       BegSr CloseData04;

         //  Close the SQL recordset for Screen 04
         Exec Sql        Close     C4;

       EndSr;

       //?  ...........................................................
       //?  :      ReadData04 - Read In Screen 04 Data                :
       //?  :.........................................................:

       BegSr ReadData04;

         //  Read Master Info
         Exec SQL Fetch C4 into :Screen04DS;

         If SQLSTT = '02000';                                                 //?Read until EOF
           EndOfFile04 = *On;
         Else;
           EndOfFile04 = *Off;
           OHROUT  = C4_OHROUT;
           OHSTOP  = C4_OHSTOP;
           OHORD#  = C4_OHORD#;
           OHCUST  = C4_OHCUST;
           OHNAME  = C4_OHNAME;
           ORDQTY  = C4_ORDQTY;
         EndIf;

       EndSr;




       //?  ...........................................................
       //?  :      Scrn05 - Display Screen 05                         :
       //?  :.........................................................:
       BegSr Scrn05;
         Screen = 05;
         ExFmt MNR01005;
         ExSr ClrError;
       EndSr;
       //?  ...........................................................
       //?  :      Load05 - Load Screen 05                            :
       //?  :.........................................................:
       BegSr Load05;

         //? Initialize Screen Fields
         Truck    = *Blanks;

       EndSr;
       //?  ...........................................................
       //?  :      Edit05 - EDIT Screen 05                            :
       //?  :.........................................................:
       BegSr Edit05;

         SELECT;
           //? Exit Requested
         When *In03 = *ON;
           *InLR = *On;
           LeaveSR;
           //? When Previous is Requested
         When *In12 = *ON;
           ExSr Load02;
           ExSr Scrn02;
           //? When Refresh is Requested
         When *In05 = *ON;
           ExSr Load05;
           ExSr Scrn05;
           // When Change Printer
         When *In10;
           ExSr PrinterSR;
           ExSr Scrn05;
           //? When Truck is specified
         When TRUCK <> *Blanks;
           ExSr GetTruck;
           ExSr Scrn05;
           //? When Select All is specified
         When SelectAll <> *Zero;
           ExSr GetTrucks;
           ExSr Scrn05;
           //? If no Functions, Check fields
         OTHER;
           ExSr Scrn05;
         ENDSL;

       EndSr;

       //?  ...........................................................
       //?  :      Scrn06 - Display Screen 06                         :
       //?  :.........................................................:
       BegSr Scrn06;
         Screen = 06;
         *In25 = *On;
         Write ASSUME;
         Write MNR01006F;
         Write MSGCTL;
         ExFmt MNR01006C;
         ExSr ClrError;
         *In25 = *Off;
       EndSr;
       //?  ...........................................................
       //?  :      Load06 - Load Screen 06                            :
       //?  :.........................................................:
       BegSr Load06;


         //? Clear the Subfile
         *In25 = *Off;
         *In26 = *Off;
         *In27 = *Off;
         Write MNR01006C;
         GrandTot = *Zero;

         //? Load the Subfile
         *In28 = *On;                                                         //?Write w/ SFLNXTCHG
         RRN06 = *Zero;
         ExSr GetData06;
         ExSr ReadData06;
         DoW not EndOfFile06;
           RRN06 += 1;
           GrandTot += C6_QTY;
           ITEM5 = %Subst(IMITEM:1:5);
           *In42 = *off; // RC_OR_LOC Color GRN
           *In43 = *off; // RC_OR_LOC Color YLW
           *In44 = *off; // RC_OR_LOC Color PNK
           *In45 = *off; // RC_OR_LOC Color RED

           // Get Ready Color
           Exec SQL
             Select coalesce(OLRDYC,' ')
                  , coalesce(TBSHRT,'*RC NOT LISTED*')
             Into :RC_CODE, :RC_DESC
             from fmorls
             left outer join XATABE1 on OLRDYC = TBC6 and TBTB = 'RC'
             Where OLITEM = :IMITEM and OLSIZE = :IMSIZE;
           Select;
           When RC_CODE = 'READY'
             or RC_CODE = 'R C';
             *In42 = *on;           // GREEN
           When RC_CODE = 'C C'
             or RC_CODE = 'R B'
             or RC_CODE = 'R L C'
             or RC_CODE = 'CC-SM'
             or RC_CODE = 'RB-SM'
             or RC_CODE = 'RC-SM';
             *In44 = *on;           // PINK
           When RC_CODE = 'R GR'
             or RC_CODE = 'GONE'
             or RC_CODE = 'N R';
             *In45 = *on;           // RED
           Other;
             *In43 = *on;           // YELLOW
           ENDSL;

           // Get Location
           Chain (IMITEM:IMSIZE) FFINLOC02;
           If %Found(FFINLOC02);
             LOCATION = %Trim(%EditC(FLSECT:'Z')) + '-' +
               %Trim(%EditC(FLBAY :'Z')) + FLNORS + FLEORW;
             Else;
               LOCATION = *Blanks;
           EndIf;


           If *In62; // *In62 = ShowReadyColor
             *In41 = *off; // RC_OR_LOC Color BLU
             RC_OR_LOC = RC_DESC;
            Else; // Then Show Location
             *In41 = *On; // RC_OR_LOC Color BLU
             RC_OR_LOC = LOCATION;
           ENDIF;



           Write MNR01006;
           ExSr ReadData06;
         EndDo;
         ExSr CloseData06;

         Clear MNR01006;
         RRN06 += 1;
         *In27 = *On;
         *In26 = *On;
         EVAL IMDES1 = '<== Grand Total';
         C6_QTY = GrandTot06;
         Write MNR01006;

       EndSr;
       //?  ...........................................................
       //?  :      Edit06 - EDIT Screen 06                            :
       //?  :.........................................................:
       BegSr Edit06;

         SELECT;
           //? Exit Requested
         When *In03 = *ON;
           *InLR = *On;
           LeaveSR;
           // When Change Printer
         When *In10;
           ExSr PrinterSR;
           ExSr Scrn06;
           //? When Previous is Requested
         When *In12 = *ON;
           ExSr Load03;
           ExSr Scrn03;
           //? When Refresh is Requested
         When *In05 = *ON;
           ExSr Load06;
           ExSr Scrn06;
         When *In23 = *ON;
           ReadC MNR01006;
           *In28 = *On;

           DoW not %EOF(MNR010FM);
             Select;
             When DELETEITEM = 'Y';
               Exec SQL  // Delete item from order
                 Update FIORDR
                   Set   OISTAT = 'D'
                       , OIQORD = 0
                       , OIRQTY = 0
                       , OICOFL = 'Y'
                   Where OIORD# = :C6_OIORD#
                     and OISEQ# = :C6_OISEQ#
                     and OIITEM = :C6_OIITEM
                     and OISIZE = :C6_OISIZE;
               Exec SQL  // Put item back in inventory
                 Update FMINVT
                   Set   IMQTAL = IMQTAL - :C6_QTY
                       , IMQTAV = IMQTAV + :C6_QTY
                   Where IMITEM = :C6_OIITEM
                     and IMSIZE = :C6_OISIZE;
             When DELETEITEM <> 'Y';
               // Do Nothing
             ENDSL;
             ReadC MNR01006;
           EndDo;

           ExSr Load06;
           ExSr Scrn06;
           //? If no Functions, Check for Options and Re-display
         OTHER;
           ExSr Load06;
           ExSr Scrn06;
         ENDSL;

       EndSr;


       //?  ...........................................................
       //?  :      GetData06 -  Get selected Open information         :
       //?  :.........................................................:

       BegSr GetData06;

         exec sql   DECLARE C6 cursor for
          SELECT
             MAN.MNDATE,
             MAN.MNSEQ#,
             MAN.MNSEQD,
             OIALPH,
             OIORD#,
             OISEQ#,
             OISIZE,
             OIITEM,
             OIDES1,
             cast(OIQORD - OIQSHP as dec(11,2)) as QTYONORDER

             FROM FMANUAL    as  MAN
             join FMANUALD   as  MMD on  MAN.MNDATE  = MMD.MNDATE
                                     and MAN.MNSEQ#  = MMD.MNSEQ#
             join FIORDR     as  ORD on  MMD.MNORD#  = ORD.OIORD#
                                     and MMD.MNDATE  = ORD.OIRVDT
                                     and ORD.OISTAT  = 'A'
                                     and ORD.OIITYP  = ' '

             WHERE   MAN.MNDATE = :SDateYMD7
               AND   MAN.MNSEQ# = :MNSEQ#
               AND   (OIITEM, OISIZE) in
                     (Select OLITEM, OLSIZE from fmorls
                        WHERE OLRDYC in ('N R', 'GONE'))

             ORDER BY
               OIALPH,
               OIORD#,
               OISEQ#,
               OISIZE,
               OIITEM,
               OIDES1
           For Read only;

         //  Open the SQL recordset for Screen 06
         exec sql        Open      C6;

       EndSr;

       //?  ...........................................................
       //?  :      CloseData06 - Close the Data Set                   :
       //?  :.........................................................:

       BegSr CloseData06;

         //  Close the SQL recordset for Screen 01
         exec sql        Close     C6;

       EndSr;

       //?  ...........................................................
       //?  :      ReadData06 - Read In Screen 06 Data                :
       //?  :.........................................................:

       BegSr ReadData06;




         //  Read Master Info
         Exec Sql Fetch C6 into :Screen06DS;

         If SQLSTT = '02000';   //?Read until EOF
           EndOfFile06 = *On;
         Else;
           EndOfFile06 = *Off;
           C6_ITEM5  = %subst(C6_OIITEM:1:5);
           C6_QTY    = C6_QTYONORDER;
           DELETEITEM = 'Y';
         EndIf;

       EndSr;


       //?  ...........................................................
       //?  :      GetTruck - Load a Single Truck into Subfile        :
       //?  :.........................................................:
       BegSr GetTruck;

         SetLL (TRUCK:SDateYMD7) FTRSCHD;
         ReadE (TRUCK:SDATEYMD7) FTRSCHD;
         DoW not %EOF(FTRSCHD) and not $PlugOrd(TRORD#);
           If TRORD# <> *Zero;
             RRN02 += 1;
             MNORD# = TRORD#;
             SetLL TRORD# FHORDRCSTM;
             If INLCSTM = 'Y' and     %Equal(FHORDRCSTM) or
                   INLCSTM = 'N' and not %Equal(FHORDRCSTM) or
                   INLCSTM = 'A';
               Chain (MNDATE:MNSEQ#:MNORD#) FMANUALD;
               If not %Found(FMANUALD);
                 Write RMANUALD;
               EndIf;
             EndIf;
           EndIf;
           ReadE (TRUCK:SDateYMD7) FTRSCHD;
         EndDo;

       EndSr;


       //?  ...........................................................
       //?  :      GetTrucks - Load a Single Truck into Subfile        :
       //?  :.........................................................:
       BegSr GetTrucks;

         SetLL SDateYMD7 FTRSCHDS;
         ReadE SDateYMD7 FTRSCHDS;
         DoW not %EOF(FTRSCHDS);
           If TRORD# <> *Zero and not $PlugOrd(TRORD#);
             If SelectALL = 1 and
                   %Subst(TRTRK#:3:1) <> 'T'                                  // 1 = Vans
                   or SelectALL = 2 and
                   %Subst(TRTRK#:3:1) =  'T';                                 // 2 = Trailers
               RRN02 += 1;
               MNORD# = TRORD#;
               SetLL TRORD# FHORDRCSTM;
               If INLCSTM = 'Y' and     %Equal(FHORDRCSTM) or
                     INLCSTM = 'N' and not %Equal(FHORDRCSTM) or
                     INLCSTM = 'A';
                 Chain (MNDATE:MNSEQ#:MNORD#) FMANUALD;
                 If not %Found(FMANUALD);
                   Write RMANUALD;
                 EndIf;
               EndIf;
             EndIf;
           EndIf;
           ReadE SDateYMD7 FTRSCHDS;
         EndDo;

       EndSr;


       //?  ...........................................................
       //?  :      SQLCount - Record Count Subroutine                 :
       //?  :.........................................................:
       BegSr PrinterSR;

         PRINTER = $ChgPrt($User():'MNR010':PRINTER);
         OVRPRTF = 'OVRPRTF FILE(MNR010P) FORMTYPE(*NAR) ' +
          'CPI(10) PAGRTT(0) OVRSCOPE(*JOB) '     +
          'OUTQ(' + %trim(PRINTER) + ')';
         QCmdExc(OVRPRTF : %len(%trim(OVRPRTF)));

       EndSr;


       //?  ...........................................................
       //?  :      SQLCount - Record Count Subroutine                 :
       //?  :.........................................................:
       BegSr SQLCount;

         RECORDS = *Zero;
         exec sql

           SELECT  count(MNDATE)
           INTO   :RECORDS
           FROM    FMANUALD
           WHERE   MNDATE = :SDateYMD7
             and   MNSEQ# = :MNSEQ#;

       EndSr;

       //?  ...........................................................
       //?  :      DeleteOld - Delete Old Records                     :
       //?  :.........................................................:
       BegSr DeleteOld;

         exec sql
           DELETE
           FROM    FMANUAL
           WHERE   MNDATE < :SDeltYMD7;

         exec sql
           DELETE
           FROM    FMANUALD
           WHERE   MNDATE < :SDeltYMD7;

       EndSr;

       //?  ...........................................................
       //?  :      ClrError - Clear Error Message Subfile             :
       //?  :.........................................................:
       BegSr ClrError;

         $#MSFN = 'C';
         ExSr SRMSGF;
         ErrCount = *Zero;
         *In50 = *Off;                                                        //?Error Indicator

       EndSr;
       //?  ...........................................................
       //?  :      SndError - Send an Error Message to the PGMMSGQ    :
       //?  :.........................................................:
       BegSr SndError;

         $#MSFN = 'S';
         ExSr SRMSGF;
         ErrCount = ErrCount + 1;
         *In50 = *On;                                                         //?Error Indicator

       EndSr;

       //?  ...........................................................
       // ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
       //?  :.........................................................:
       BegSr SRMSGF;

         //? Define Parameter List - define variables         ?

      /END-FREE
     C     PLMSGF        PLIST
     C                   Parm                    $#PGMQ           10          //?Pgm Msg Queue
     C                   Parm                    $#MSGF           10          //?Message File
     C                   Parm                    $#MSGL           10          //?Library
     C                   Parm                    $#MSID            7          //?Message Id
     C                   Parm                    $#MSGD          100          //?Message Data
     C                   Parm                    $#MSKY            4          //?Message Key
     C                   Parm                    $#MSFN            1          //?Send or Clear

      //? Call Msg processing CL                           ?

     C                   CALL      'XAMSFC'      PLMSGF

      /FREE
       EndSr;

       //?  ...........................................................
       //?  :      *INZSR - Initialization Subroutine                 :
       //?  :.........................................................:
       BegSr *INZSR;

         Eval  $#PGMQ = ##PGM     ;                                           //?PGM MSG QUEUE
         EvalR $#MSGF = 'KPMSGF'  ;                                           //?MSG FILE N/A
         EvalR $#MSGL = '*LIBL'   ;                                           //?LIBRARY  N/A
         Eval  $#MSID = '*******' ;                                           //?MESSAGE ID
         Today = $Date(0);                                                    //?Today MDY

         SDate = $MDYDate($AddDate($Date(0):2));                              //?Ship Date MDY
         SDateYMD7 = $Date7($DateMDY(SDate));                                 //?Ship Date YMD7

         SDelt = $MDYDate($AddDate($Date(0):-90));                            //?Delete Date MDY
         SDeltYMD7 = $Date7($DateMDY(SDelt));                                 //?Delete Date YMD7

         INLCSTM = 'A';                                                       //?Include Custom
         *In62 = *On;  // Show Ready Color By Default

       EndSr;
      /END-FREE
