      /COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
?     // ?:````````````````````````````````````````````````````````````:?
?     // ?:         Tool for Allocation of Fixers &  Un-sown           :?
?     // ?:............................................................:?
?     //  :````````````````````````````````````````````````````````````:
?     //  : Created:  June 2004            ? Kube-Pak Corporation ?    :
?     //  :      by:  William J. Behr                                  :
?     //  :............................................................:
?     //  :````````````````````````````````````````````````````````````:
?     //  :   Program Description                                     ?:
?     //  : ```````````````````````                                   ?:
?     //  :                                                           ?:
?     //  :............................................................:
     FLOT200FM  CF   E             WORKSTN
     F                                     SFILE(LOT20001:RRN01)
     F                                     SFILE(LOT20002:RRN02)
     F                                     DEVID(WSID)

     FFDLOTRDCLTIF   E           K DISK
     FFALITEMLOTIF   E           K DISK
     FFDLOT     IF   E           K DISK
     FFMCUST    IF   E           K DISK

      //? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$isFile
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$EditOrder

      //? Called Program Prototypes
     D LOT_TRN_N       PR                  ExtPgm('LOT_TRN_N')                  Prototype
     D Dim_ORDER                      6  0                                      Order Number
     D Dim_SEQ#                       3  0                                      Order Seq# to Start
     D Dim_990Item                   12                                         990 Item Number
     D Dim_990Size                    3                                         990 Size Code
     D Dim_990CRDY                    7  0                                      990 Current Ready
     D Dim_990SOWD                    7  0                                      990 Sow Date
     D Dim_990SHPD                    7  0                                      990 Ship Date
     D Dim_QTY                        6  0                                      Quantity
     D Dim_COMMENT                     N                                        Include Comment

     D LOT_TRN_J       PR                  ExtPgm('LOT_TRN_J')                  Prototype
     D Dim_ORDER                      6  0                                      Order Number
     D Dim_SEQ#                       3  0                                      Order Seq# to Start
     D Dim_990Item                   12                                         990 Item Number
     D Dim_990Size                    3                                         990 Size Code
     D Dim_990CRDY                    7  0                                      990 Current Ready
     D Dim_990SOWD                    7  0                                      990 Sow Date
     D Dim_990SHPD                    7  0                                      990 Ship Date
     D Dim_QTY                        6  0                                      Quantity
     D Dim_COMMENT                     N                                        Include Comment

      //? Field Definitions
     D  User           S             10A                                        ?Current User ID
     D  RRN01          S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D  RRN02          S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D  ErrorCount     S              3S 0 Inz(0)                               ?Error Count
     D  ErrorCount01   S              3S 0 Inz(0)                               ?Error Count
     D  ErrorCount02   S              3S 0 Inz(0)                               ?Error Count
     D  RecordCount    S              5S 0 INZ(0)                               ?Record Count
     D  RecordCount02  S              5S 0 INZ(0)                               ?Record Count
     D  Today          S              6S 0                                      ?Todays Date MDY
     D  Now            S              6S 0                                      ?The Time at *Init
     D  ChainRRN01     S              4S 0 Inz(*Zero)                           ?Key by RRN
     D  ChainRRN02     S              4S 0 Inz(*Zero)                           ?Key by RRN
     D  Program        S             10A                                        ?Program
     D  Option         S              1A                                        ?Temp Option
     D  Change         S              4S 0 Inz(*Zero)                           ?Qty Changed
     D  PQTY           S              6P 0 Inz(*Zero)                           ?Qty Changed
     D  TRUE           S               N   Inz(*On)                             ?True

     D  SelLDSOWD      S                   Like(LDSOWD)                         ?Select Sow Date
     D  SelLDCRDY      S                   Like(LDCRDY)                         ?Select Ready Date
     D  SqlIMLOOK      S             +2    Like(SelIMLOOK)                      ?IMLOOK with '%'
     D  SqlIMDES1      S             +2    Like(SelIMDES1)                      ?IMDES1 with '%'
     D  SqlSEARCH      S             +2    Like(SEARCH)                         ?Search with '%'

     D  SavLDSOWD6     S                   Like(SelLDSOWD6)                     ?Save SelLDSOWD6
     D  SavLDCRDY6     S                   Like(SelLDCRDY6)                     ?Save SelLDCRDY6
     D  SavLDSIZE      S                   Like(LDSIZE)                         ?Save SelLDSIZE
     D  SavLDITEM5     S                   Like(SelLDITEM5)                     ?Save SelLDITEM5
     D  SavLDGLOC      S                   Like(LDGLOC)                         ?Save SelLDGLOC
     D  SavLDFIXD      S                   Like(LDFIXD)                         ?Save SelLDFIXD
     D  SavIMLOOK      S                   Like(IMLOOK)                         ?Save SelIMLOOK
     D  SavIMDES1      S                   Like(IMDES1)                         ?Save SelIMDES1
     D  SavSEARCH      S                   Like(SEARCH)                         ?Save SEARCH

     D  Screen         S              2S 0                                      ?Screen Number

      //? Indicators
      //D  Done02         S               N   INZ(*Off)
     D  EndOfFile01    S               N   INZ(*Off)
     D  EndOfFile02    S               N   INZ(*Off)
     D  DetailChange   S               N   INZ(*Off)

      //? Data Areas
     D  Read01DS       DS
     D  C1_LDITEM                          Like(LDITEM)
     D  C1_LDSIZE                          Like(LDSIZE)
     D  C1_LDSOWD                          Like(LDSOWD)
     D  C1_LDSHPD                          Like(LDSHPD)
     D  C1_LDGLOC                          Like(LDGLOC)
     D  C1_LDFIXD                          Like(LDFIXD)
     D  C1_LDAREA                          Like(LDAREA)
     D  C1_LDQTOH                          Like(LDQTOH)
     D  C1_LDQTAL                          Like(LDQTAL)
     D  C1_LDQTAV                          Like(LDQTAV)
     D  C1_LDQTSP                          Like(LDQTSP)
     D  C1_LDQFIX                          Like(LDQFIX)
     D  C1_LDQDMP                          Like(LDQDMP)
     D  C1_LDCRDY                          Like(LDCRDY)
     D  C1_LDSOWN                          Like(LDSOWN)
     D  C1_IMLOOK                          Like(IMLOOK)
     D  C1_IMDES1                          Like(IMDES1)
     D  C1_LRQTOH                          Like(LRQTOH)

      //? Data Areas
     D  Read02DS       DS
     D  C2_OIORD#                          Like(OIORD#)
     D  C2_OISEQ#                          Like(OISEQ#)
     D  C2_OICUST                          Like(OICUST)
     D  C2_OIPOST                          Like(OIPOST)
     D  C2_OILOTC                          Like(OILOTC)
     D  C2_OILOT#                          Like(OILOT#)
     D  C2_OIQORD                          Like(OIQORD)
     D  C2_OIQSHP                          Like(OIQSHP)
     D  C2_OIRQTY                          Like(OIRQTY)
     D  C2_AIQTOA                          Like(AIQTOA)
     D  C2_AICUST                          Like(AICUST)
     D  C2_OIRVDT                          Like(OIRVDT)

      /FREE

    ?   /COPY QFunctDefn,LASTUSEDCB

       DOU *INLR = *ON;                                                       //?COMMENT

         SELECT;                                                              //?
         WHEN Screen = 1;                                                     //?
           ExSr Edit01;                                                       //?
         WHEN Screen = 2;                                                     //?
           ExSr Edit02;                                                       //?
         ENDSL;                                                               //?

       ENDDO;                                                                 //?

       //?  ...........................................................
       //?  :      Scrn01 - Display Screen 01                         :
       //?  :.........................................................:
       BegSr Scrn01;                                                          //?
         Screen = 1;                                                          //?Screen  Number
         *In25 = *On;                                                         //?
         Write ASSUME132;
         Write LOT20001F;
         If ErrorCount01 <> *Zero;                                            //?Error Count
           Write MSGCTL;                                                      //?
         EndIf;
         ExFmt LOT20001C;                                                     //?
         ExSr ClrError;                                                       //?
         ErrorCount01 = *Zero;                                                //?Error Count
         *In25 = *Off;                                                        //?
       EndSr;                                                                 //?

       //?  ...........................................................
       //?  :      Load01 - Load Screen 01                            :
       //?  :.........................................................:
       BegSr Load01;                                                          //?

         //? Poplate Sav_Fields so that future changes can be detected
         SavLDSOWD6 = SelLDSOWD6;
         SavLDCRDY6 = SelLDCRDY6;
         SavLDSIZE  = SelLDSIZE;
         SavLDITEM5 = SelLDITEM5;
         SavLDGLOC  = SelLDGLOC;
         SavLDFIXD  = SelLDFIXD;
         SavIMLOOK  = SelIMLOOK;
         SavIMDES1  = SelIMDES1;
         SavSEARCH  = SEARCH;


         //? Edit Header Information
         If LDSOWN5 - LDQFIX5 - LDQDMP5 = LDQTOH5;
            *In53 = *Off;
          else;
            *In53 = *On;
         EndIf;

         If LDQTOH5 - LDQTAL5 = LDQTAV5;
            *In54 = *Off;
          else;
            *In54 = *On;
         EndIf;

         //? Clear the Subfile
         Option = *Blanks;
         *In25 = *Off;                                                        //?
         *In26 = *Off;                                                        //?
         *In27 = *Off;                                                        //?
         Write LOT20001C;                                                     //?

         //? Load the Subfile
         *In28 = *On;                                                         //?Write w/ SFLNXTCHG
         RRN01 = 0;
         ExSr GetData01;
         ExSr ReadData01;                                                     //?
         DoW not EndOfFile01 and RRN01 < 9998;

           If ( LRCUST >= 999990 and *In85) or
              ( LRCUST = 0 and not *In85 and LRGLOC = ' ');
             *In84     = *On;                                                 //      Enable Rls Qua
           Else;
             *In84     = *Off;                                                //      Lock Rls Quant
           EndIf;

           //? Write Subfile Record
           RRN01 = RRN01 + 1;
             Write LOT20001;                                                   //?
           *In26 = *On;                                                       //?Have Data Indicator
           ExSr ReadData01;                                                   //?
         EndDo;                                                               //?

         IF *In26 = *On;                                                      //?
           Chain RRN01 LOT20001;                                              //?
           *In27 = *On;                                                       //?SFLEND Indicator
           *In84 = In84;
           Update LOT20001;                                                   //?
         EndIF;                                                               //?

         ExSr CloseData01;

       EndSr;                                                                 //?


       //?  ...........................................................
       //?  :      Edit01 - EDIT Screen 01                            :
       //?  :.........................................................:
       BegSr Edit01;                                                          //?

         //? Process pre-edit Functions F3, F6, F7 & F9
         SELECT;                                                              //?
           //? Cancel Requested
         When *In03 or *In06 or *In07;
         *InLR = *On;
       //? Mouse Click Selection Criteria to add
         When *In10
               and CSRRCD = 'LOT20001';
           Chain SFLCSRRRN1 LOT20001;                                          //?
           SELECT;                                                            //?
           When CSRFLD     = 'LDSOWD6';
             SelLDSOWD6 =  LDSOWD6;
           When CSRFLD     = 'LDCRDY6';
             SelLDCRDY6 =  LDCRDY6;
           When CSRFLD     = 'LDSIZE ';
             SelLDSIZE  =  LDSIZE;
           When CSRFLD     = 'LDITEM5';
             SelLDITEM5 =  LDITEM5;
           When CSRFLD     = 'IMLOOK ';
             SelIMLOOK  =  IMLOOK;
           When CSRFLD     = 'IMDES1 ';
             SelIMDES1  =  IMDES1;
           When CSRFLD     = 'LDGLOC ';
             SelLDGLOC  =  LDGLOC;
           EndSl;
           ExSr Load01;
           ExSr Scrn01;
           //? Mouse Click Selection Criteria to remove
         When *In10
               and CSRRCD = 'LOT20001C';
           SELECT;                                                            //?
           When CSRFLD     = 'SELLDSOWD6';
             SelLDSOWD6 =  *Zeros;
           When CSRFLD     = 'SELLDCRDY6';
             SelLDCRDY6 =  *Zeros;
           When CSRFLD     = 'SELLDSIZE ';
             SelLDSIZE  =  *Blanks;
           When CSRFLD     = 'SELLDITEM5';
             SelLDITEM5 =  *Blanks;
           When CSRFLD     = 'SELIMLOOK ';
             SelIMLOOK  =  *Blanks;
           When CSRFLD     = 'SELIMDES1 ';
             SelIMDES1  =  *Blanks;
           When CSRFLD     = 'SELLDGLOC ';
             SelLDGLOC  = '*  ';
           EndSl;
           ExSr Load01;
           ExSr Scrn01;
           //? Use requested details
         When *In04
               and CSRRCD = 'LOT20001';
           Chain SFLCSRRRN1 LOT20001;
           ExSr Load02;
           ExSr Scrn02;
           //? Refresh/Reselect Requested
         When *In05
               or SelLDSOWD6 <> SavLDSOWD6
               or SelLDCRDY6 <> SavLDCRDY6
               or SelLDSIZE  <> SavLDSIZE
               or SelLDITEM5 <> SavLDITEM5
               or SelLDGLOC  <> SavLDGLOC
               or SelLDFIXD  <> SavLDFIXD
               or SelIMLOOK  <> SavIMLOOK
               or SelIMDES1  <> SavIMDES1
               or SEARCH     <> SavSEARCH;
           ExSr Load01;
           ExSr Scrn01;
           //? If no Functions, Check for Options.
         OTHER;                                                               //?
           ExSr Opts01;                                                       //?Screen 01 Options
           //? If Update Requested then Update file else redisplay
           If *In01 = *On  and
                 ErrorCount01 = *Zero;
             ExSr UpdateFiles01;
             ExSr Load01;
             ExSr Scrn01;
           Else;
             If DetailChange;
               ExSr Load01;
               DetailChange = *Off;
             EndIf;
             ExSr Scrn01;
           EndIf;
         ENDSL;                                                               //?

       EndSr;                                                                 //?

       //?  ...........................................................
       //?  :      Opts01 - Process Screen 01 Options                 :
       //?  :.........................................................:
        BegSr Opts01;                                                          //?

          ReadC LOT20001;
          DoW not %EOF(LOT200FM);
            *In50 = *Off;                         //?Error Indicator
            *In28 = *Off;                                                      //?Subfile Next Chang
            *In84 = In84;                                                      //?Release Qty

           *In28 = *On;                                                       //?Subfile Next Change
           *In84 = In84;                                                      //?Release Qty
           Update LOT20001;
           ReadC LOT20001;
         EndDo;

       EndSr;                                                                 //?

       //?  ...........................................................
       //?  :      Updt01 - Process Screen 01 Options                 :
       //?  :.........................................................:
        BegSr Updt01;                                                          //?

          ReadC LOT20001;
          DoW not %EOF(LOT200FM);
            *In50 = *Off;                         //?Error Indicator
            *In28 = *Off;                                                      //?Subfile Next Chang
            *In84 = In84;                                                      //?Release Qty

           *In28 = *On;                                                       //?Subfile Next Change
           *In84 = In84;                                                      //?Release Qty
           Update LOT20001;
           ReadC LOT20001;
         EndDo;

       EndSr;                                                                 //?


       //?  ...........................................................
       //?  :      Scrn02 - Display Screen 02                         :
       //?  :.........................................................:
       BegSr Scrn02;                                                          //?
         Screen = 2;                                                          //?Screen  Number
         *In25 = *On;                                                         //?
         Write ASSUME132;
         Write LOT20002F;
         If ErrorCount01 <> *Zero;                                            //?Error Count
           Write MSGCTL;                                                      //?
         EndIf;
         ExFmt LOT20002C;                                                     //?
         ExSr ClrError;                                                       //?
         ErrorCount02 = *Zero;                                                //?Error Count
         *In25 = *Off;                                                        //?
       EndSr;                                                                 //?

       //?  ...........................................................
       //?  :      Load02 - Load Screen 02                            :
       //?  :.........................................................:
       BegSr Load02;                                                          //?

         //? Poplate Sav_Fields so that future changes can be detected
         SavLDSOWD6 = SelLDSOWD6;
         SavLDCRDY6 = SelLDCRDY6;
         SavLDSIZE  = SelLDSIZE;
         SavLDITEM5 = SelLDITEM5;
         SavLDGLOC  = SelLDGLOC;
         SavLDFIXD  = SelLDFIXD;
         SavIMLOOK  = SelIMLOOK;
         SavSEARCH  = SEARCH;


         //? Clear the Subfile
         Option = *Blanks;
         *In25 = *Off;                                                        //?
         *In26 = *Off;                                                        //?
         *In27 = *Off;                                                        //?
         Write LOT20002C;                                                     //?

         //? Load the Subfile
         *In28 = *On;                                                         //?Write w/ SFLNXTCHG
         RRN02 = 0;
         NEWQTYP = *Zero;
         NEWQTY  = *Zero;

         ORIGINAL = *Zero;
         CURRENT  = *Zero;
         TARGET   = *Zero;
         TOMOVE   = *Zero;

         ExSr GetData02;
         ExSr ReadData02;                                                     //?
         DoW not EndOfFile02 and RRN02 < 9998;

           //? Write Subfile Record
             RRN02 = RRN02 + 1;
             Write LOT20002;                                                  //?
           *In26 = *On;                                                       //?Have Data Indicator
           ExSr ReadData02;                                                   //?
         EndDo;                                                               //?

         IF *In26 = *On;                                                      //?
           Chain RRN02 LOT20002;                                              //?
           *In27 = *On;                                                       //?SFLEND Indicator
           *In84 = In84;
           Update LOT20002;                                                   //?
         EndIF;                                                               //?

         ExSr CloseData02;

       EndSr;                                                                 //?


       //?  ...........................................................
       //?  :      Edit02 - EDIT Screen 02                            :
       //?  :.........................................................:
       BegSr Edit02;                                                          //?

         //? Process pre-edit Functions F3, F6, F7 & F9
         SELECT;                                                              //?
           //? Cancel Requested
         When *In03 or *In07;
         *InLR = *On;
           //? Back to screen 1
         When *In06;
         exsr load01;
         exsr scrn01;
           //? Use requested details
         When *In11;
           Chain SFLCSRRRN2 LOT20002;
         //      *In55 = $EditOrder(OIORD#:OISEQ#);
      /END-FREE
     C                   Call      'BIR100CLO'
     C                   Parm                    OIORD#
     C                   Parm                    OISEQ#
      /FREE
           ExSr Scrn02;
           //? Refresh/Reselect Requested
         When *In05
               or SelLDSOWD6 <> SavLDSOWD6
               or SelLDCRDY6 <> SavLDCRDY6
               or SelLDSIZE  <> SavLDSIZE
               or SelLDITEM5 <> SavLDITEM5
               or SelLDGLOC  <> SavLDGLOC
               or SelLDFIXD  <> SavLDFIXD
               or SelIMLOOK  <> SavIMLOOK
               or SEARCH     <> SavSEARCH;
           ExSr Load02;
           ExSr Scrn02;
           //? If no Functions, Check for Options.
         OTHER;                                                               //?
           ExSr Opts02;                                                       //?Screen 01 Options
           //? If Update Requested then Update file else redisplay
           If *In01 = *On  and
                 ErrorCount02 = *Zero;
             ExSr Updt02;
             ExSr Load02;
             ExSr Scrn02;
           Else;
             If DetailChange;
               ExSr Load02;
               DetailChange = *Off;
             EndIf;
             ExSr Scrn02;
           EndIf;
         ENDSL;                                                               //?

       EndSr;                                                                 //?

       //?  ...........................................................
       //?  :      Opts02 - Process Screen 02 Options                 :
       //?  :.........................................................:
        BegSr Opts02;                                                          //?

          NEWQTYP = *Zero;
          NEWQTY  = *Zero;
          Current = *Zero;
          ErrorCount02 = 0;
                  //  FYI...  SFLCHG indicator used on all records
          ReadC LOT20002;
          DoW not %EOF(LOT200FM);
            *In50 = *Off;                                                     //?Error Indicator
            *In28 = *Off;                                                     //?Subfile Next Chang
         //?Test that we have only decreased allocations
            If NEW_QTOA > QTOA;
               ErrorCount02 = ErrorCount02 + 1;
               *In51 = *On;
            Else;
               *In51 = *Off;
            EndIf;
            If NEW_QTOA_P > 1;
               ErrorCount02 = ErrorCount02 + 1;
               *In52 = *On;
            Else;
               *In52 = *Off;
            EndIf;
            Current += NEW_QTOA + NEW_QTOA_P;
            NEWQTYP += NEW_QTOA_P;
            NEWQTY  += NEW_QTOA  ;
            *In28 = *On;                                                      //?Subfile Next Change
            *In97 = In97;                                                     //?Conditoning
            *In96 = In96;                                                     //?Conditoning
            Update LOT20002;
            ReadC LOT20002;
         EndDo;
            ToMove  = Current - Target;
       //?Test if we have allocated the correct amount
         If ErrorCount02 = *Zero and
            NEWQTYP = LOT_QTSW_P and
            NEWQTY  = LOT_QTSW_W ;
            *In98 = *On;
         Else;
            *In98 = *Off;
         EndIf;
       EndSr;                                                                 //?


       //?  ...........................................................
       //?  :      Updt02 - Process Screen 01 Options                 :
       //?  :.........................................................:
        BegSr Updt02;                                                          //?

                  //  FYI...  SFLCHG indicator used on all records
          ReadC LOT20002;
          DoW not %EOF(LOT200FM);
            *In50 = *Off;                                                     //?Error Indicator
            *In28 = *Off;                                                     //?Subfile Next Chang
         //?Make adjustments
            Select;
         //?When nothing has changed, change nothing!
              When NEW_QTOA = QTOA and NEW_QTOA_P = QTOA_P;
         //?Only Whole Trays Have Changed Use the "N" process
              When NEW_QTOA < QTOA and NEW_QTOA_P = QTOA_P;
                PQTY = QTOA - NEW_QTOA;

                CallP LOT_TRN_N ( OIORD#:
                                  OISEQ#:
                                  LDITEM:
                                  LDSIZE:
                                  LDCRDY:
                                  LDSOWD:
                                  OIRVDT:
                                  PQTY  :
                                  TRUE  );

         //?Partial was added and Whole Trays reduced by equal amount. Use "J" process
              When NEW_QTOA = QTOA - ( NEW_QTOA_P - QTOA_P )
                   and NEW_QTOA_P > QTOA_P;
                PQTY = NEW_QTOA_P - QTOA_P;

                CallP LOT_TRN_J ( OIORD#:
                                  OISEQ#:
                                  LDITEM:
                                  LDSIZE:
                                  LDCRDY:
                                  LDSOWD:
                                  OIRVDT:
                                  PQTY  :
                                  TRUE  );

         //?Partial was added and Whole Trays reduced by even Larger Amount...
         //?                 Use "N" Process First, then "J" Process
              Other;

                PQTY = QTOA - NEW_QTOA;
                CallP LOT_TRN_N ( OIORD#:
                                  OISEQ#:
                                  LDITEM:
                                  LDSIZE:
                                  LDCRDY:
                                  LDSOWD:
                                  OIRVDT:
                                  PQTY  :
                                  TRUE  );

                PQTY = NEW_QTOA_P - QTOA_P;
                CallP LOT_TRN_J ( OIORD#:
                                  OISEQ#:
                                  LDITEM:
                                  LDSIZE:
                                  LDCRDY:
                                  LDSOWD:
                                  OIRVDT:
                                  PQTY  :
                                  TRUE  );

            EndSl;
            *In28 = *On;                                                      //?Subfile Next Change
            *In97 = In97;                                                     //?Conditoning
            *In96 = In96;                                                     //?Conditoning
            Update LOT20002;
            ReadC LOT20002;
         EndDo;
            ToMove  = Current - Target;
       //?Test if we have allocated the correct amount
         If Current = TARGET and ErrorCount02 = *Zero;
            *In98 = *On;
         Else;
            ErrorCount02 = ErrorCount02 + 1;
            *In98 = *Off;
         EndIf;
       EndSr;                                                                 //?




       //?  ...........................................................
       //?  :      ClrError - Clear Error Message Subfile             :
       //?  :.........................................................:
       BegSr ClrError;                                                        //?

         SndClr = 'C';
         ExSr SRMSGF;                                                         //?
         ErrorCount = *Zero;                                                  //?Error Count
         *In50 = *Off;                                                        //?Error Indicator

       EndSr;                                                                 //?


       //?  ...........................................................
       //?  :      SndError - Send an Error Message to the PGMMSGQ    :
       //?  :.........................................................:
       BegSr SndError;                                                        //?

         SndClr = 'S';
         ExSr SRMSGF;                                                         //?
         ErrorCount = ErrorCount + 1;                                         //?Error Count
         *In50 = *On;                                                         //?Error Indicator

       EndSr;                                                                 //?

       //?  ...........................................................
       //?  :      SRMSGF - Clear or send messages to Pgm msg queue   :
       //?  :.........................................................:
       BegSr SRMSGF;                                                          //?

         //? Define Parameter List - define variables         ?

      /END-FREE
     C     MessageParm   PLIST                                                  ?
     C                   Parm      'LOT200'      PgmQ             10            ?Pgm Msg Queue
     C                   Parm      'KPMSGF'      MsgFile          10            ?Message File
     C                   Parm      '*LIBL'       MsgfLib          10            ?Library
     C                   Parm                    MessageID         7            ?Message Id
     C                   Parm                    MessageDta      100            ?Message Data
     C                   Parm                    MsgKey            4            ?Message Key
     C                   Parm                    SndClr            1            ?Send or Clear

      //? Call Msg processing CL                           ?

     C                   CALL      'XAMSFC'      MessageParm                    ?

      /FREE
       EndSr;                                                                 //?


       //?  ...........................................................
       //?  :      GetData01 - Run SQL to select Data for Screen 01   :
       //?  :.........................................................:

       BegSr GetData01;

         //? Format Wildcard Field Criteria
         SqlIMLOOK  = '%' + %Trim(SelIMLOOK) + '%';
         SqlIMDES1  = '%' + %Trim(SelIMDES1) + '%';
         SqlSEARCH  = '%' + %Trim(SEARCH) + '%';

         //? Format Date7 Criteria
         If SelLDSOWD6 = *Zero;
           SelLDSOWD  = *Zero;
         Else;
           SelLDSOWD  = $Date7($DateMDY(SelLDSOWD6));
         EndIf;

         If SelLDCRDY6 = *Zero;
           SelLDCRDY  = *Zero;
         Else;
           SelLDCRDY  = $Date7($DateMDY(SelLDCRDY6));
         EndIf;
         //? Get FDLOTRD Data matching request
         exec sql

         DECLARE   C1 cursor for

           SELECT
                      LDITEM
                ,     LDSIZE
                ,     LDSOWD
                ,     LDSHPD
                ,     LDGLOC
                ,     LDFIXD
                ,     LDAREA
                ,     LDQTOH
                ,     LDQTAL
                ,     LDQTAV
                ,     LDQTSP
                ,     LDQFIX
                ,     LDQDMP
                ,     LDCRDY
                ,     LDSOWN
                ,     IMLOOK
                ,     IMDES1
                ,     LRQTOH

           FROM       FDLOT, FDLOTRD, FMINVT

           WHERE    ( LDITEM = IMITEM and LDSIZE = IMSIZE )
             and    ( LDITEM = LRITEM and LDSIZE = LRSIZE and
                      LDSOWD = LRSOWD and LDCRDY = LRCRDY and
                      LRQTOH <> 0     and LRCUST = 999990 )
             and    ( LDSOWD   =       :SelLDSOWD  or :SelLDSOWD  = 0    )
             and    ( LDCRDY   =       :SelLDCRDY  or :SelLDCRDY  = 0    )
             and    ( LDSIZE   =       :SelLDSIZE  or :SelLDSIZE  = ' '  )
             and    ( LDITEM   =       :SelLDITEM5 or :SelLDITEM5 = ' '  )
             and    ( LDGLOC   =       :SelLDGLOC  or :SelLDGLOC  = '*'  )
             and    ( LDFIXD   =       :SelLDFIXD  or :SelLDFIXD  = '*'  )
             and    ( IMLOOK like Trim(:SqlIMLOOK) or :SelIMLOOK  = ' '  )
             and    ( IMDES1 like Trim(:SqlIMDES1) or :SelIMDES1  = ' '  )
             and    ( IMLOOK like Trim(:SqlSearch) or
                      IMDES1 like Trim(:SqlSearch) or
                      IMDES2 like Trim(:SqlSearch) or
                      IMDES3 like Trim(:SqlSearch) or
                      IMDES4 like Trim(:SqlSearch) or
                                                      :Search     = ' '  )

           Order By   IMLOOK, IMSIZE

           For Read only;


         //  Open the SQL recordset
         exec sql Open C1;

       EndSr;

       //?  ...........................................................
       //?  :      ReadData01 - Read Data for Screen 01               :
       //?  :.........................................................:

       BegSr ReadData01;

         //? Read Sow Schedule Records for Selected Week
         exec sql Fetch C1 into :Read01DS;


         If SQLSTT = '02000';                                                 //?Read until EOF
           EndOfFile01 = *On;
         Else;
           EndOfFile01 = *Off;
           RecordCount = RecordCount + 1;                                     //?Record Count
           LDITEM   = C1_LDITEM;
           LDSIZE   = C1_LDSIZE;
           LDSOWD   = C1_LDSOWD;
           LDSHPD   = C1_LDSHPD;
           LDGLOC   = C1_LDGLOC;
           LDFIXD   = C1_LDFIXD;
           LDAREA   = C1_LDAREA;
           LDQTOH   = C1_LDQTOH;
           LDQTAL   = C1_LDQTAL;
           LDQTAV   = C1_LDQTAV;
           LDQTSP   = C1_LDQTSP;
           LDQFIX   = C1_LDQFIX;
           LDQDMP   = C1_LDQDMP;
           LDCRDY   = C1_LDCRDY;
           LDSOWN   = C1_LDSOWN;
           IMLOOK   = C1_IMLOOK;
           IMDES1   = C1_IMDES1;
           LRQTOH   = C1_LRQTOH;
       // Load screen specific fields
           If LDSOWD   = *Zero;
             LDSOWD6  = *Zero;
           Else;
             LDSOWD6  = $MDYDate($Date(LDSOWD));
           EndIf;

           If LDCRDY   = *Zero;
             LDCRDY6  = *Zero;
           Else;
             LDCRDY6  = $MDYDate($Date(LDCRDY));
           EndIf;

           QTOH990  = LRQTOH;
           LDITEM5  = LDITEM;
           LDQTOH5  = LDQTOH;
           LDQTAL5  = LDQTAL;
           LDQTAV5  = LDQTAV;
           LDQFIX5  = LDQFIX;
           LDQDMP5  = LDQDMP;
           LDSOWN5  = LDSOWN;

         //? Get Totals
         exec sql
           SELECT sum(LRQTAL)
           INTO   :LOT_QTAL
           FROM   FDLOTRD
           WHERE  LRITEM =  :LDITEM
             and  LRSIZE =  :LDSIZE
             and  LRCRDY =  :LDCRDY
             and  LRSOWD =  :LDSOWD ;

         exec sql
           SELECT count(*)
           INTO   :LOT_QTSW
           FROM   FTRAY
           WHERE  TRITEM =  :LDITEM
             and  TRSIZE =  :LDSIZE
             and  TRCRDT =  :LDCRDY
             and  TRSCYM =  :LDSOWD
             and  TRCNTD in ('Y', 'D');

         exec sql
           SELECT count(*)
           INTO   :LOT_QTLS
           FROM   FTRAY
           WHERE  TRITEM =  :LDITEM
             and  TRSIZE =  :LDSIZE
             and  TRCRDT =  :LDCRDY
             and  TRSCYM =  :LDSOWD
             and  TRCNTD = 'D';

         EndIf;

       EndSr;


       //?  ...........................................................
       //?  :      CloseData01 - Close the Screen 01 Data Set         :
       //?  :.........................................................:

       BegSr CloseData01;
         //?  Close the SQL recordset
       exec sql Close C1;

       EndSr;


       //?  ...........................................................
       //?  :      GetData02 - Run SQL to select Data for Screen 02   :
       //?  :.........................................................:

       BegSr GetData02;

         //? Format Wildcard Field Criteria

         //? Format Date7 Criteria

         //? Get FDLOTRD Data matching request

         exec sql

         DECLARE   C2 cursor for

           SELECT
                      OIORD#
                ,     OISEQ#
                ,     OICUST
                ,     OIPOST
                ,     OILOTC
                ,     OILOT#
                ,     OIQORD
                ,     OIQSHP
                ,     OIRQTY
                ,     AIQTOA
                ,     AICUST
                ,     OIRVDT

           FROM       FALITEM,  FIORDR

           WHERE    ( AIORD# = OIORD#  and AIOSEQ = OISEQ# )
             and      AIITEM = :LDITEM
             and      AISIZE = :LDSIZE
             and      AICRDY = :LDCRDY
             and      AISOWD = :LDSOWD


           Order By   OIORD#, OISEQ#

           For Read only;



         //  Open the SQL recordset
         exec sql Open C2;

       EndSr;

       //?  ...........................................................
       //?  :      ReadData02 - Read Data for Screen 02               :
       //?  :.........................................................:

       BegSr ReadData02;

         //? Read Sow Schedule Records for Selected Week
         exec sql Fetch C2 into :Read02DS;


         If SQLSTT = '02000';                                                 //?Read until EOF
           EndOfFile02 = *On;
         Else;
           EndOfFile02 = *Off;
           RecordCount02 = RecordCount02 + 1;                                 //?Record Count
           OIORD#   = C2_OIORD#;
           OISEQ#   = C2_OISEQ#;
           OICUST   = C2_OICUST;
           OIPOST   = C2_OIPOST;
           OILOTC   = C2_OILOTC;
           OILOT#   = C2_OILOT#;
           OIQORD   = C2_OIQORD;
           OIQSHP   = C2_OIQSHP;
           OIRQTY   = C2_OIRQTY;
           AIQTOA   = C2_AIQTOA;
           AICUST   = C2_AICUST;
           OIRVDT   = C2_OIRVDT;

           //? Load screen specific fields
         IF AICUST = 999997;
           *In97 = *On;
           *In96 = *On;
           QTOA_P = AIQTOA;
           NEW_QTOA_P = AIQTOA;
           NEWQTYP = NEWQTYP + AIQTOA;
         Else;
           *In97 = *Off;
           QTOA = AIQTOA;
           NEW_QTOA = AIQTOA;
           NEWQTY  = NEWQTY  + AIQTOA;
         EndIf;
            In97 = *In97;
            In96 = *In96;

         ORIGINAL = ORIGINAL + AIQTOA;
         CURRENT  = CURRENT  + AIQTOA;
         TARGET   = ORIGINAL + QTOH990;
         TOMOVE   = CURRENT - TARGET;

         CMNAME = 'Customer Not Found';
         Chain OICUST FMCUST;
         CUSNAME = CMNAME;
         EndIf;

         //? Whole Tray Records
         exec sql
           SELECT count(*)
           INTO   :LOT_QTSW_W
           FROM   FTRAY
           WHERE  TRITEM =  :LDITEM
             and  TRSIZE =  :LDSIZE
             and  TRCRDT =  :LDCRDY
             and  TRSCYM =  :LDSOWD
             and  TRCNTD =  'Y';

         //? Partial Tray Records
         exec sql
           SELECT count(*)
           INTO   :LOT_QTSW_P
           FROM   FTRAY
           WHERE  TRITEM =  :LDITEM
             and  TRSIZE =  :LDSIZE
             and  TRCRDT =  :LDCRDY
             and  TRSCYM =  :LDSOWD
             and  TRCNTD =  'P';
           If LOT_QTSW_P <> 0;
             *In96 = *On;
           Else;
             *In96 = *On;
           EndIf;
           IN96 = *In96;

       EndSr;

       //?  ...........................................................
       //?  :      CloseData02 - Close the Screen 02 Data Set         :
       //?  :.........................................................:

       BegSr CloseData02;
         //?  Close the SQL recordset
       exec sql Close C2;

       EndSr;



       //?  ...........................................................
       //?  :      UpdateFiles01 - Screen 01 File Updates             :
       //?  :.........................................................:
       BegSr UpdateFiles01;                                                   //?

         ChainRRN01 = 1;
         Chain ChainRRN01 LOT20001;
         DoW %Found(LOT200FM);

           ChainRRN01 =  ChainRRN01 + 1;
           Chain ChainRRN01 LOT20001;
         EndDo;

       EndSr;

       //?  ...........................................................
       //?  :      UpdateFiles02 - Screen 02 File Updates             :
       //?  :.........................................................:
       BegSr UpdateFiles02;                                                   //?

         ChainRRN02 = 1;
         Chain ChainRRN02 LOT20002;
         DoW %Found(LOT200FM);

           ChainRRN02 =  ChainRRN02 + 1;
           Chain ChainRRN01 LOT20002;
         EndDo;

       EndSr;


       //?  ...........................................................
       //?  :      *INZSR - Initialization Subroutine                 :
       //?  :.........................................................:
       BegSr *INZSR;                                                          //?

         User    = $User();
         Program = 'LOT200';
         Today   = $MDYDate($Date(0));
         Now     = $Now();

         *In85 = *On;
         *In86 = *On;

         SelLDCRDY6 = $MDYDate($Monday($Date(0):'SAT'));
         SelLDCRDY6 = *Zero;
         SelLDGLOC = '*  ';
         SavLDGLOC = '*  ';
         SelLDFIXD = '*';
         SavLDFIXD = '*';

         ExSr Load01;                                                         //?
         ExSr ClrError;                                                       //?
         ExSr Scrn01;                                                         //?

         //?  Dummy reads for variable definitions
         *In99 = *Off;
         If *In99;
         Setll *LoVal FDLOTRDCLT;
         Read FDLOTRDCLT;
         EndIf;

       EndSr;

      /END-FREE
