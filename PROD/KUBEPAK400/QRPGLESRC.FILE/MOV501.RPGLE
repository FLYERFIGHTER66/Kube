     H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')

      //  :````````````````````````````````````````````````````````````:?
      //  :     Moving Scan Program                                    :?
      //  :............................................................:?
      //  :````````````````````````````````````````````````````````````:
      //  : Created:  Feb. 2005            ? Kube-Pak Corporation      :
      //  :      by:  William J. Behr                                  :
      //  :............................................................:
      //  :````````````````````````````````````````````````````````````:
      //  :   Program Description                                      :
      //  :                                                            :
      //  :  This program is a re-write of a program of the same name  :
      //  : The growers use this program to select material to be      :
      //  : moved by entering where the material is and how much.      :
      //  :............................................................:
      //  :````````````````````````````````````````````````````````````:
      //  :   Subroutine Usage                                         :
      //  :                                                            :
      //  : Subroutine  -Subroutine Description                      :
      //  :  *INZSR      - Initialization Subroutine                   :
      //  :............................................................:
      //  :````````````````````````````````````````````````````````````:
      //  :   Function Usage                                           :
      //  :                                                            :
      //  : Function    -Function Description                        :
      //  :  $Date         Get Date Value                              :
      //  :  $DateMDY      Get Date Number in MM/DD/YY                 :
      //  :  $Monday       Get Monday Date Value                       :
      //  :  $AddDate      Add/Subtract Days from Date                 :
      //  :............................................................:
      //  :````````````````````````````````````````````````````````````:
      //  :   Indicator Usage                                          :
      //  :                                                            :
      //  : *IND   -Indicator Usage                                  :
      //  :  LR       Does this really need a description ?            :
      //  :  40       "Don't Move" Function                            :
      //  :  50       Error Indicator                                  :
      //  :  51-59    Error Conditioning Indicators                    :
      //  :  61-78    Screen Conditioning Indicators                   :
      //  :............................................................:

     FMOV501FM  CF   E             WORKSTN
     FFMOVCTL   UF A E           K DISK
     FFMSECT    IF   E           K DISK
     FFTRAY     IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMINSER   IF   E           K DISK
     FFSOWSCHJ  IF   E           K DISK
     FFMOVDESTNMIF   E           K DISK
     FFMOVLOC   UF A E           K DISK
     FFMOVJOB   UF A E           K DISK
     FFMOVTO    O  A E           K DISK

      //  Function Prototypes
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$Date
     D/COPY QFunctDefn,$Date7
     D/COPY QFunctDefn,$isDate#
     D/COPY QFunctDefn,$DateMDY
     D/COPY QFunctDefn,$MDYDate
     D/COPY QFunctDefn,$Monday
     D/COPY QFunctDefn,$AddDate
     D/COPY QFunctDefn,$Command
      //  Copy Book Routines
     C/Copy QFunctDefn,$ErrMsg

      //  Data Structures
     D                SDS
     D $Program          *Proc

     D BTNMOVDS        DS
     D  BTNMOV01
     D  BTNMOV02
     D  BTNMOV03
     D  BTNMOV04
     D  BTNMOV05
     D  BTNMOV06
     D  BTNMOV07
     D  BTNMOV08
     D  BTNMOV09
     D  BTNMOV10
     D  BtnMovAra                     8A   dim(10) overlay(BtnMovDS) inz

     D BTNBAYDS        DS
     D  BTNBAY01
     D  BTNBAY02
     D  BTNBAY03
     D  BTNBAY04
     D  BTNBAY05
     D  BTNBAY06
     D  BTNBAY07
     D  BTNBAY08
     D  BTNBAY09
     D  BTNBAY10
     D  BTNBAY11
     D  BTNBAY12
     D  BTNBAY13
     D  BTNBAY14
     D  BTNBAY15
     D  BTNBAY16
     D  BTNBAY17
     D  BTNBAY18
     D  BTNBAYara                     2S 0 dim(18) overlay(BTNBAYDS) inz(*Zeros)

     D BtnPolDS        DS
     D  BtnPol01
     D  BtnPol02
     D  BtnPol03
     D  BtnPol04
     D  BtnPol05
     D  BtnPol06
     D  BtnPol07
     D  BtnPol08
     D  BtnPol09
     D  BtnPol10
     D  BtnPol11
     D  BtnPol12
     D  BtnPol13
     D  BtnPol14
     D  BtnPol15
     D  BtnPolAra                     2S 0 dim(15) overlay(BtnPolDS) inz(*Zeros)

     D Destination     DS
     D  DSEC
     D  blank_1                       1A   inz(' ')
     D  DAREA
     D  blank_2                       2A   inz('  ')

      //  Array Definitions
     D  BtnMovLit      S              8A   dim(10) CtData PerRcd(1)             |Move# Types

      //  Field Definitions
     D  UserID         S             10A
     D  Today          S              6S 0
     D  Screen         S              3S 0                                       Current Screen
     D  LastScreen     S              3S 0                                       Previous Screen
     D  X              S              5S 0                                       Generic Counter Fld
     D  Y              S              5S 0                                       Generic Counter Fld
     D  NorS           S              1A                                         North or South
     D  Off15          S             15A   Inz('000000000000000')                North or South
     D  MaxPoles       S              5S 0                                       Max Poles to Scan
     D  CurrentPOLE    S                   Like(POLE)                            Current Pole
     D  CurrentLORR    S                   Like(LORR)                            Current LORR
     D CurrentPoleKey  S                   Like(PoleKey)                         Current Pole Key
     D  PoleKey        S                   Like(POLE)                            Calc'd Pole Key
     D  MaxTrays       S                   Like(TRAYS)                           Max Trays to Scan
     D  BayPoles       S                   Like(POLE)                            Active Poles in Bay
     D  Used           S              3S 0                                       Tray Space Used
     D  TraysPerPole   S              3S 0                                       Trays Per Pole
     D  SaveBAY        S                   Like(BAY )                            Save Bay
     D  FromBAY        S                   Like(BAY )                            FROM BAY
     D  FromLORR       S                   Like(LORR)                            FROM LORR
     D  FromNORS       S                   Like(NORS)                            FROM NORS
     D  FromPOLE       S                   Like(POLE)                            FROM POLE
     D  FromSECT       S                   Like(SECT)                            FROM SECT
     D  FromPoleKey    S                   Like(POLE)                            FROM Pole Key
     D  FromTrays      S                   Like(TRAYS)                           FROM Trays
     D  ToBAY          S                   Like(BAY )                            TO BAY
     D  ToLORR         S                   Like(LORR)                            TO LORR
     D  ToNORS         S                   Like(NORS)                            TO NORS
     D  ToPOLE         S                   Like(POLE)                            TO POLE
     D  ToSECT         S                   Like(SECT)                            TO SECT
     D  ToPoleKey      S                   Like(POLE)                            TO Pole Key
     D  ToTrays        S                   Like(TRAYS)                           TO Trays
     D AvailableSpace  S                   Like(POLES)                           Available Space
     D  TraysLeft      S                   Like(TRAYS)                           Trays Left to Alloc
     D  House          S                   LIKE(MJHSE)                           Greenhouse
     D  ThisJob        S                   LIKE(MHNJOB)                          Job Number

      //  Indicators
     D  DoNotMove      S               N   Inz(*Off)                             Don't Move Function
     D  NoMorePoles    S               N   Inz(*Off)                             No Poles in Bay
     D  FirstPole      S               N   Inz(*Off)                             First Pole for Item
     D  UpdatePoles    S               N   Inz(*Off)                             Update Poles ?
     D  PoleFull       S               N   Inz(*Off)                             Req'd Pole Full
     D  SingleMoves    S               N   Inz(*Off)                             Single Move / Dest.

      /Eject
      //   ...........................................................
      //   :              C A L C U L A T I O N S                    :
      //   :.........................................................:

      /FREE
       DoW *InLR <> *On;
          Select;
         WHEN Screen = 00;
           ExSr Edit00;
         WHEN Screen = 01;
           ExSr Edit01;
         WHEN Screen = 02;
           ExSr Edit02;
         WHEN Screen = 03;
           ExSr Edit03;
         WHEN Screen = 04;
           ExSr Edit04;
         WHEN Screen = 05;
           ExSr Edit05;
         WHEN Screen = 06;
           ExSr Edit06;
         WHEN Screen = 07;
           ExSr Edit07;
         WHEN Screen = 08;
           ExSr Edit08;
         WHEN Screen = 09;
           ExSr Edit09;
         WHEN Screen = 10;
           ExSr Edit10;
         WHEN Screen = 11;
           ExSr Edit11;
         WHEN Screen = 12;
           //                  ExSr      Edit12
         Other;
           *InLR = *On;
         EndSL;
       EndDo;


      /Eject
       //   ...........................................................
       //   :      Load00   - Load Screen 00                          :
       //   :.........................................................:

       //    Enter Date
       BegSr Load00;
         ToDat = $MDYDate($Date(0));
       EndSr;

      /Eject
       //   ...........................................................
       //   :      Load01   - Load Screen 01                          :
       //   :.........................................................:

       //    Enter Move Number
       BegSr Load01;

         x = 1;
         DoU x > 10;
           BtnMovAra(x) = BtnMovLit(x);
           x = x + 1;
         EndDo;

       EndSr;

      /Eject
       //   ...........................................................
       //   :      Load02   - Load Screen 02                          :
       //   :.........................................................:

       //    Select Section
       BegSr Load02;
         //    Load Move Number
         If BtnMov > 0;
           MovLit = BtnMovLit(BtnMov);
         Else;
           MovLit = *Blanks;
         EndIf;
         //
       EndSr;

      /Eject
       //   ...........................................................
       //   :      Load03   - Load Screen 03                          :
       //   :.........................................................:

       //    Select Bay
       BegSr Load03;
         Clear BtnBayAra;
         SetLL Sect FMSECT;                                                   // Greenhouse Def.
         ReadE Sect FMSECT;                                                   // Greenhouse Def.
         X = 0;
      /END-FREE
     C                   MoveA     Off15         *In(61)
      /FREE
         DoW not %EOF(FMSECT);
           SaveBAY  = GHBAY;
           //    Check to see if there is any  room in this bay "N" or "S".
           BAY  = GHBAY;
           NORS = 'N';
           Chain SectBayNORS FMSECT;                                          // Greenhouse Def.
      /END-FREE
     C     SectBayNORS   KList
     C                   KFld                    Sect
     C                   KFld                    GHBAY
     C                   KFld                    NORS
      /FREE
           TraysPerPole = GHTRAY;
           If GHUSED = 'Y';
             LORR = 'L';
             POLE = 1;
             ExSr GetMaxTrays;
           Else;
             MaxTrays = *Zero;
           EndIf;
           If MaxTrays <= *Zero;
             NORS = 'S';
             Chain SectBayNORS FMSECT;                                        // Greenhouse Def.
             If GHUSED = 'Y';
               ExSr GetMaxTrays;
             Else;
               MaxTrays = *Zero;
             EndIf;
           EndIf;
           //    If there is space in the Bay add it to the list of buttons
           If MaxTrays > *Zero;
             X = X + 1;
             BtnBayAra(X) = GHBAY;
             *In(60+X) = *On;
           EndIf;
           SetGT SectBay FMSECT;                                              // Greenhouse Def.
      /END-FREE
     C     SectBay       KList
     C                   KFld                    Sect
     C                   KFld                    GHBAY
      /FREE
           ReadE Sect FMSECT;                                                 // Greenhouse Def.
         EndDo;
       EndSr;

      /Eject
       //   ...........................................................
       //   :      Load04   - Load Screen 04                          :
       //   :.........................................................:

       //    Select North or South
       BegSr Load04;
         //                  Nothing to Load
       EndSr;

      /Eject
       //   ...........................................................
       //   :      Load05   - Load Screen 05                          :
       //   :.........................................................:

       //    Select Left or Right
       BegSr Load05;
         //                  Nothing to Load
       EndSr;

      /Eject
       //   ...........................................................
       //   :      Load06   - Load Screen 06                          :
       //   :.........................................................:

       //    Select Pole
       BegSr Load06;
         //                  Clear                   BtnPolDS
         //                  Eval      X = 1
         //                  DoW       X <= GHPOLS
         //                  Eval      BtnPolAra(X) = X
         //                  Eval      X = X + 1
         //                  EndDo
         UpdatePoles = *On;
         ExSr GetMaxTrays;
         UpdatePoles = *Off;
       EndSr;

      /Eject
       //   ...........................................................
       //   :      Load07   - Load Screen 07                          :
       //   :.........................................................:

       //    Select Destination Screen
       BegSr Load07;

         DoNotMove = *Off;
         *In40 =     *Off;
         DSEC = *Zeros;
         DAREA = *Blanks;
         *In80 = SingleMoves;

       EndSr;

      /Eject
       //   ...........................................................
       //   :      Load08   - Load Screen 08                          :
       //   :.........................................................:

       //    ???
       BegSr Load08;

       EndSr;

      /Eject
       //   ...........................................................
       //   :      Load09   - Load Screen 09                          :
       //   :.........................................................:

       //    Scan Tray
       BegSr Load09;
         Tag# = *Zeros;
         If LORR = 'L';
           LorRLit = 'Left';
         Else;
           LorRLit = 'Right';
         EndIf;
       EndSr;

      /Eject
       //   ...........................................................
       //   :      Load10   - Load Screen 10                          :
       //   :.........................................................:

       //    Enter # of Trays or Poles
       BegSr Load10;

         Chain TAG# FTRAY;

      /END-FREE
     C     ItemKey       KList
     C                   KFld                    TRITEM
     C                   KFld                    TRSIZE
      /FREE
         Chain ItemKey FMINVT;
         Chain IMITEM FMINSER;
         DES1 = IMDES1;

      /END-FREE
     C     SowKey        KList
     C                   KFld                    TRSCYM
     C                   KFld                    TRJOB#
      /FREE
         Chain SowKey FSOWSCHJ;
         RDYDAT = $MDYDate($Date(SORDYD));
         SOWQ   = SOSOWQ;

         ExSr GetMaxTrays;
         If LORR = 'L';
           LorRLit = 'Left';
         Else;
           LorRLit = 'Right';
         EndIf;
         Trays = SOWQ;
         Poles = *Zero;

       EndSr;

      /Eject
       //   ...........................................................
       //   :      Load11   - Load Screen 11                          :
       //   :.........................................................:

       //    Confirmation Screen (Omit)
       BegSr Load11;
         //                  Nothing to Load
       EndSr;

      /Eject
       //   ...........................................................
       //   :      Scrn00   - Display Screen 00                       :
       //   :.........................................................:

       //    Enter Date
       BegSr Scrn00;

         LastScreen =  Screen;                                                // Previous Screen
         Screen = 00;                                                         // Screen  Number

         Write MSGCTL;                                                        // Error Messages
         ExFmt MOV50100;                                                      // Screen 00
         ExSr $ClrError;                                                      // Clear Error Message
      /END-FREE
     C                   MoveA     '0000000000'  *In(50)                         Clear Error Indicat
      /FREE
         Write Assume;                                                        // Clear Msg from Scrn

       EndSr;

      /Eject
       //   ...........................................................
       //   :      Scrn01   - Display Screen 01                       :
       //   :.........................................................:

       //    Enter Date
       BegSr Scrn01;

         LastScreen =  Screen;                                                // Previous Screen
         Screen = 01;                                                         // Screen  Number

         Write MSGCTL;                                                        // Error Messages
         ExFmt MOV50101;                                                      // Screen 01
         ExSr $ClrError;                                                      // Clear Error Message
      /END-FREE
     C                   MoveA     '0000000000'  *In(50)                         Clear Error Indicat
      /FREE
         Write Assume;                                                        // Clear Msg from Scrn

       EndSr;

      /Eject
       //   ...........................................................
       //   :      Scrn02   - Display Screen 02                       :
       //   :.........................................................:

       //    Select Section
       BegSr Scrn02;

         LastScreen =  Screen;                                                // Previous Screen
         Screen = 02;                                                         // Screen  Number

         Write MSGCTL;                                                        // Error Messages
         ExFmt MOV50102;                                                      // Screen 02
         ExSr $ClrError;                                                      // Clear Error Message
      /END-FREE
     C                   MoveA     '0000000000'  *In(50)                         Clear Error Indicat
      /FREE
         Write Assume;                                                        // Clear Msg from Scrn

       EndSr;

      /Eject
       //   ...........................................................
       //   :      Scrn03   - Display Screen 03                       :
       //   :.........................................................:

       //    Select Bay
       BegSr Scrn03;

         LastScreen =  Screen;                                                // Previous Screen
         Screen = 03;                                                         // Screen  Number

         X = 0;
         Y = 1;
         DoU X >= %Elem(BTNBAYara);
           X = X + 1;
           If BTNBAYara(X) <> 0;
             *In(60 + Y) = *On;
             Y = Y + 1;
           EndIf;
         EndDo;

         Write MSGCTL;                                                        // Error Messages
         ExFmt MOV50103;                                                      // Screen 03
         ExSr $ClrError;                                                      // Clear Error Message
      /END-FREE
     C                   MoveA     '0000000000'  *In(50)                         Clear Error Indicat
      /FREE
         Write Assume;                                                        // Clear Msg from Scrn

       EndSr;

      /Eject
       //   ...........................................................
       //   :      Scrn04   - Display Screen 04                       :
       //   :.........................................................:

       //    Select North or South
       BegSr Scrn04;

         LastScreen =  Screen;                                                // Previous Screen
         Screen = 04;                                                         // Screen  Number

         Write MSGCTL;                                                        // Error Messages
         ExFmt MOV50104;                                                      // Screen 04
         ExSr $ClrError;                                                      // Clear Error Message
      /END-FREE
     C                   MoveA     '0000000000'  *In(50)                         Clear Error Indicat
      /FREE
         Write Assume;                                                        // Clear Msg from Scrn

       EndSr;

      /Eject
       //   ...........................................................
       //   :      Scrn05   - Display Screen 05                       :
       //   :.........................................................:

       //    Select Left or Right
       BegSr Scrn05;

         LastScreen =  Screen;                                                // Previous Screen
         Screen = 05;                                                         // Screen  Number

         Write MSGCTL;                                                        // Error Messages
         ExFmt MOV50105;                                                      // Screen 05
         ExSr $ClrError;                                                      // Clear Error Message
      /END-FREE
     C                   MoveA     '0000000000'  *In(50)                         Clear Error Indicat
      /FREE
         Write Assume;                                                        // Clear Msg from Scrn

       EndSr;

      /Eject
       //   ...........................................................
       //   :      Scrn06   - Display Screen 06                       :
       //   :.........................................................:

       //    Select Pole
       BegSr Scrn06;

         LastScreen =  Screen;                                                // Previous Screen
         Screen = 06;                                                         // Screen  Number

         X = 0;
         Y = 1;
         DoU X >= %Elem(BtnPolAra);
           X = X + 1;
           If BtnPolAra(X) <> 0;
             *In(60 + Y) = *On;
             Y = Y + 1;
           EndIf;
         EndDo;

         Write MSGCTL;                                                        // Error Messages
         ExFmt MOV50106;                                                      // Screen 06
         ExSr $ClrError;                                                      // Clear Error Message
      /END-FREE
     C                   MoveA     '0000000000'  *In(50)                         Clear Error Indicat
      /FREE
         Write Assume;                                                        // Clear Msg from Scrn

       EndSr;

      /Eject
       //   ...........................................................
       //   :      Scrn07   - Display Screen 07                       :
       //   :.........................................................:

       //    Scan Tray
       BegSr Scrn07;

         LastScreen =  Screen;                                                // Previous Screen
         Screen = 07;                                                         // Screen  Number

         Write MSGCTL;                                                        // Error Messages
         ExFmt MOV50107;                                                      // Screen 07
         ExSr $ClrError;                                                      // Clear Error Message
      /END-FREE
     C                   MoveA     '0000000000'  *In(50)                         Clear Error Indicat
      /FREE
         Write Assume;                                                        // Clear Msg from Scrn

       EndSr;

      /Eject
       //   ...........................................................
       //   :      Scrn08   - Display Screen 08                       :
       //   :.........................................................:

       //    Enter # of Trays or Poles
       BegSr Scrn08;

         LastScreen =  Screen;                                                // Previous Screen
         Screen = 08;                                                         // Screen  Number

         Write MSGCTL;                                                        // Error Messages
         ExFmt MOV50108;                                                      // Screen 08
         ExSr $ClrError;                                                      // Clear Error Message
      /END-FREE
     C                   MoveA     '0000000000'  *In(50)                         Clear Error Indicat
      /FREE
         Write Assume;                                                        // Clear Msg from Scrn

       EndSr;

      /Eject
       //   ...........................................................
       //   :      Scrn09   - Display Screen 09                       :
       //   :.........................................................:

       //    Destination Section
       BegSr Scrn09;

         LastScreen =  Screen;                                                // Previous Screen
         Screen = 09;                                                         // Screen  Number

         Write MSGCTL;                                                        // Error Messages
         ExFmt MOV50109;                                                      // Screen 09
         ExSr $ClrError;                                                      // Clear Error Message
      /END-FREE
     C                   MoveA     '0000000000'  *In(50)                         Clear Error Indicat
      /FREE
         Write Assume;                                                        // Clear Msg from Scrn

       EndSr;


      /Eject
       //   ...........................................................
       //   :      Scrn10   - Display Screen 10                       :
       //   :.........................................................:

       //    Destination Area
       BegSr Scrn10;

         LastScreen =  Screen;                                                // Previous Screen
         Screen = 10;                                                         // Screen  Number

         Write MSGCTL;                                                        // Error Messages
         ExFmt MOV50110;                                                      // Screen 10
         ExSr $ClrError;                                                      // Clear Error Message
      /END-FREE
     C                   MoveA     '0000000000'  *In(50)                         Clear Error Indicat
      /FREE
         Write Assume;                                                        // Clear Msg from Scrn

       EndSr;


      /Eject
       //   ...........................................................
       //   :      Scrn11   - Display Screen 11                       :
       //   :.........................................................:

       //    Confirmation Screen (Omit)
       BegSr Scrn11;

         LastScreen =  Screen;                                                // Previous Screen
         Screen = 11;                                                         // Screen  Number

         Write MSGCTL;                                                        // Error Messages
         ExFmt MOV50111;                                                      // Screen 11
         ExSr $ClrError;                                                      // Clear Error Message
      /END-FREE
     C                   MoveA     '0000000000'  *In(50)                         Clear Error Indicat
      /FREE
         Write Assume;                                                        // Clear Msg from Scrn

       EndSr;


      /Eject
       //   ...........................................................
       //   :      Edit00   - Edit Screen 00                          :
       //   :.........................................................:

       //    Enter Date
       BegSr Edit00;

         Select;
           //   Exit
         When *In03 or Function = 1;
           *InLR = *On;
           //   Refresh
         When *In05;
           ExSr Load00;
           ExSr Scrn00;
           //   Sub Day
         When *In07;
           ToDat= $MDYDate($AddDate($DateMDY(TODAT):-1));
           ExSr Scrn00;
           //   Add Day
         When *In08;
           ToDat= $MDYDate($AddDate($DateMDY(TODAT):1));
           ExSr Scrn00;
         Other;
           //   Edit User Entry
           Select;
           When not $isDate#(TODAT:'*MDY');
             $ERR_MsgData = %CHAR(TODAT);
             $ERR_MsgId = 'DATE901';
             ExSr $SndError;
             *In51 = *On;
             ExSr Scrn00;
             //   Proceed to next screen
           Other;
             ExSr Load01;
             ExSr Scrn01;
           EndSl;
         EndSl;

       EndSr;


      /Eject
       //   ...........................................................
       //   :      Edit01   - Edit Screen 01                          :
       //   :.........................................................:

       //    Enter Move #
       BegSr Edit01;

         Select;
           //   Exit
         When *In03 or Function = 1;
           *InLR = *On;
           //   Previous
         When *In02;
           ExSr Load00;
           ExSr Scrn00;
           //   Refresh
         When *In05;
           ExSr Load01;
           ExSr Scrn01;
           //   Proceed to next screen
         Other;
           If BtnMov = *Zeros;
             ExSr Load01;
             ExSr Scrn01;
           Else;
             ExSr Load02;
             ExSr Scrn02;
           EndIf;
         EndSl;

       EndSr;


      /Eject
       //   ...........................................................
       //   :      Edit02   - Edit Screen 02                          :
       //   :.........................................................:

       //    Select Section
       BegSr Edit02;

         Select;
           //   Exit
         When *In03;
           *InLR = *On;
         When *In02;
           ExSr Scrn01;
         When *In05;
           ExSr Load02;
           ExSr Scrn02;
         Other;
           Sect = BtnSect;
           House = %Int(Sect/5) + 1;
           ExSr Load03;
           ExSr Scrn03;
         EndSl;

       EndSr;


      /Eject
       //   ...........................................................
       //   :      Edit03   - Edit Screen 03                          :
       //   :.........................................................:

       //    Select Bay
       BegSr Edit03;

         Select;
           //   Exit
         When *In03;
           *InLR = *On;
           //   Previous
         When *In02;
           ExSr Scrn02;
           //   Refresh
         When *In05;
           ExSr Load03;
           ExSr Scrn03;
         Other;
           //   Edit Screen Fields
           Bay = BtnBayAra(BtnBay);
           ExSr Load04;
           ExSr Scrn04;
         EndSl;

       EndSr;


      /Eject
       //   ...........................................................
       //   :      Edit04   - Edit Screen 04                          :
       //   :.........................................................:

       //    Select North or South
       BegSr Edit04;

         Select;
           //   Exit
         When *In03;
           *InLR = *On;
           //   Previous
         When *In02;
           ExSr Load03;
           ExSr Scrn03;
           //   Refresh
         When *In05;
           ExSr Load04;
           ExSr Scrn04;
         Other;
           //   Process Selection
           If BtnNorS = 1;
             NorS = 'N';
             NorSLit = 'North';
           EndIf;
           If BtnNorS = 2;
             NorS = 'S';
             NorSLit = 'South';
           EndIf;
           //   Get Bay Information
      /END-FREE
     C     BayKey        KLIST
     C                   KFLD                    SECT
     C                   KFLD                    BAY
     C                   KFLD                    NORS
      /FREE
           Chain BayKey FMSECT;                                               // Greenhouse Def.
           If GHUSED = 'Y';
             BayPoles = GHPOLS;
             TraysPerPole = GHTRAY;
             ExSr Load05;
             ExSr Scrn05;
           Else;
             $ERR_MsgData = GHNOTE;
             $ERR_MsgId = 'BAY0101';
             ExSr $SndError;
             ExSr Scrn04;
           EndIf;
         EndSl;

       EndSr;


      /Eject
       //   ...........................................................
       //   :      Edit05   - Edit Screen 05                          :
       //   :.........................................................:

       //    Select Left or Right
       BegSr Edit05;

         Select;
           //   Exit
         When *In03;
           *InLR = *On;
         When *In02;
           ExSr Scrn04;
         When *In05;
           ExSr Load05;
           ExSr Scrn05;
         Other;
           If BtnLorR = 1;
             LorR = 'L';
             LorRLit = 'Left ';
           EndIf;
           If BtnLorR = 2;
             LorR = 'R';
             LorRLit = 'Right';
           EndIf;
           ExSr Load06;
           ExSr Scrn06;
         EndSl;

       EndSr;


      /Eject
       //   ...........................................................
       //   :      Edit06   - Edit Screen 06                          :
       //   :.........................................................:

       //    Select Pole
       BegSr Edit06;

         Select;
           //   Exit
         When *In03;
           *InLR = *On;
           //   Previous
         When *In02;
           ExSr Scrn05;
           //   Refresh
         When *In05;
           ExSr Load06;
           ExSr Scrn06;
           //   Bad Button
         When BtnPol = 0;
           ExSr Scrn06;
         Other;
           //   Edit Screen
           Pole = BtnPolAra(BtnPol);
           ExSr GetPoleKey;
           ExSr Load07;
           ExSr Scrn07;
         EndSl;

       EndSr;


      /Eject
       //   ...........................................................
       //   :      Edit07   - Edit Screen 07                          :
       //   :.........................................................:

       //    Select Destination Section
       BegSr Edit07;

         Select;
           //   Exit
         When *In03;
           *InLR = *On;
           //   Previous
         When *In02;
           ExSr Scrn06;
           //   Refresh
         When *In04;
           ExSr Load02;
           ExSr Scrn02;
           //   Refresh
         When *In05;
           ExSr Load07;
           ExSr Scrn07;
           //   Use Single Moves Logic
         When *In10;
           SingleMoves = *On;
           ExSr Load07;
           ExSr Scrn07;
           //   Use Multiple Moves Logic
         When *In11;
           SingleMoves = *Off;
           ExSr Load07;
           ExSr Scrn07;
           //   Use No Location
         When *In12;
           DareaLit = 'No Dest.';
           ExSr Load09;
           ExSr Scrn09;
           //   Don't Move Screen
         When *In07;
           DoNotMove = *On;
           *In40 =     *On;
           DareaLit = 'No Move ';
           ExSr Load09;
           ExSr Scrn09;
           //   Change Move Number
         When *In06;
           ExSr Scrn01;
           If BtnMov > 0;
             MovLit = BtnMovLit(BtnMov);
           Else;
             MovLit = *Blanks;
           EndIf;
           ExSr Scrn07;
           //   Next Pole
         When *In08;
           //        Get next pole until you find one or run out of them
           DoU not PoleFull or NoMorePoles;
             ExSr NextPole;
           EndDo;
           //        If there are no more poles prompt for pole
           If NoMorePoles;
             ExSr Load05;
             ExSr Scrn05;
           Else;
             //        otherwise put screen back with new pole
             ExSr Load07;
             ExSr Scrn07;
           EndIf;
           //   New Pole
         When *In09;
           ExSr Load06;
           ExSr Scrn06;
           //   Destination Section Selected
         Other;
           DSec = BtnDSec;
           If DSec = *Zeros;
             ExSr Load07;
             ExSr Scrn07;
           Else;
             ExSr Load08;
             ExSr Scrn08;
           EndIf;
         EndSl;

       EndSr;


      /Eject
       //   ...........................................................
       //   :      Edit08   - Edit Screen 08                          :
       //   :.........................................................:

       //    Select Destination Area
       BegSr Edit08;

         Select;
           //   Exit
         When *In03;
           *InLR = *On;
           //   Previous
         When *In02;
           ExSr Scrn07;
           //   Refresh
         When *In05;
           ExSr Load08;
           ExSr Scrn08;
         Other;
           //                  Eval      DArea = BtnDArea
           Select;
           When BtnDArea = 1;
             Darea = 'NE';
             DareaLit = 'North-East';
           When BtnDArea = 2;
             Darea = 'SE';
             DareaLit = 'South-East';
           When BtnDArea = 3;
             Darea = 'NT';
             DareaLit = 'North-Tunnel';
           When BtnDArea = 4;
             Darea = 'ST';
             DareaLit = 'South-Tunnel';
           When BtnDArea = 5;
             Darea = 'NW';
             DareaLit = 'North-West';
           When BtnDArea = 6;
             Darea = 'SW';
             DareaLit = 'South-West';
           EndSl;
           ExSr Load09;
           ExSr Scrn09;
         EndSl;

       EndSr;


      /Eject
       //   ...........................................................
       //   :      Edit09   - Edit Screen 09                          :
       //   :.........................................................:

       //    Scan Tray
       BegSr Edit09;

         Select;
           //   Exit
         When *In03;
           *InLR = *On;
           //   Previous Screen
         When *In02;
           ExSr Load07;
           ExSr Scrn07;
           //   Refresh Screen
         When *In05;
           ExSr Load09;
           ExSr Scrn09;
           //   Go to a new Bay
         When *In06;
           ExSr Load03;
           ExSr Scrn03;
           //   Don't Move Screen
         When *In07;
           DoNotMove = *On;
           *In40 =     *On;
           ExSr Scrn09;
           //   New Pole ( go to Left/Right screen )
         When *In09;
           ExSr Load05;
           ExSr Scrn05;
           //   Next Pole Requested
         When *In08;
           //        Get next pole until you find one or run out of them
           DoU not PoleFull or NoMorePoles;
             ExSr NextPole;
           EndDo;
           //        If there are no more poles prompt for pole
           If NoMorePoles;
             ExSr Load05;
             ExSr Scrn05;
           Else;
             //        otherwise put screen back with new pole
             ExSr Load09;
             ExSr Scrn09;
           EndIf;
           //   Edit Screen Field(s)
         Other;
           SetLL TAG# FTRAY;
           Select;
             //   Edit Tag #
           When TAG# = *Zero;
             $ERR_MsgData = *Blanks;
             $ERR_MsgId = 'TAG0100';
             ExSr $SndError;
             *In51 = *On;
             ExSr Scrn09;
           When not %Equal(FTRAY);
             $ERR_MsgData = %CHAR(TAG#);
             $ERR_MsgId = 'TAG0102';
             ExSr $SndError;
             *In51 = *On;
             ExSr Scrn09;
           Other;
             ExSr Load10;
             ExSr Scrn10;
           EndSl;
         EndSl;

       EndSr;


      /Eject
       //   ...........................................................
       //   :      Edit10   - Edit Screen 10                          :
       //   :.........................................................:

       //    Enter # of Trays or Poles
       BegSr Edit10;

         Select;
           //   Exit
         When *In03;
           *InLR = *On;
           //   Previous Screen
         When *In02;
           ExSr Load09;
           ExSr Scrn09;
           //   Refresh Current Screen
         When *In05;
           ExSr Load10;
           ExSr Scrn10;
           //   Verify User Entry
         Other;
           If Function = 1;
             TRAYS = MaxTrays;
             POLES = *Zero;
           EndIf;
           Select;
             //   Verify either Trays or Poles entered
           When POLES = 0 and TRAYS = 0;
             $ERR_MsgId = 'MOV0101';
             ExSr $SndError;
             *In51 = *On;
             *In52 = *On;
             ExSr Scrn10;
             //   Verify not Trays and Poles entered
           When POLES <> 0 and TRAYS <> 0;
             $ERR_MsgId = 'MOV0102';
             ExSr $SndError;
             *In51 = *On;
             *In52 = *On;
             ExSr Scrn10;
             //   Verify enough room in bay
           When TRAYS > MaxTrays;
             %SUBST($ERR_MsgData:1:4) = %Char(TRAYS);
             %SUBST($ERR_MsgData:5:4) = %Char(MaxTrays);
             $ERR_MsgId = 'MOV0103';
             ExSr $SndError;
             *In51 = *On;
             ExSr Scrn10;
           When POLES > MaxTrays / TraysPerPole;
             $ERR_MsgId = 'MOV0104';
             ExSr $SndError;
             *In52 = *On;
             ExSr Scrn10;
           Other;
             If POLES > 0;
               TRAYS = POLES * TraysPerPole;
               POLES = *Zero;
             EndIf;
             ExSr Updates;
             //                  ExSr      WhereAmI
             ExSr GetMaxTrays;
             If MaxTrays = *Zero;
               ExSr Load03;
               ExSr Scrn03;
             Else;
               If SingleMoves;
                 ExSr Load07;
                 ExSr Scrn07;
               Else;
                 ExSr Load09;
                 ExSr Scrn09;
               EndIf;
             EndIf;
           EndSl;
         EndSl;

       EndSr;


      /Eject
       //   ...........................................................
       //   :      Edit11   - Edit Screen 11                          :
       //   :.........................................................:

       //    Confirmation Screen (Omit)
       BegSr Edit11;

         Select;
           //   Exit
         When *In03;
           *InLR = *On;
         When *In02;
           ExSr Scrn10;
         When *In05;
           ExSr Load11;
           ExSr Scrn11;
         Other;
           ExSr Scrn03;
         EndSl;

       EndSr;


      /Eject
       //   ...........................................................
       //   :      Updates  - Write the Move Job Record               :
       //   :.........................................................:

       BegSr Updates;

         //   Save Info about where we started
         FromSECT = SECT;
         FromBAY  = BAY;
         FromNORS = NORS;
         FromLORR = LORR;
         FromPOLE = POLE;
         FromPoleKey = PoleKey;
         MaxTrays = *Zero;
         TraysLeft = Trays;
         FirstPole = *On;
         //   Loop through the rest of the poles in the bay until all trays are allocated.
         DoU TraysLeft <= *Zero;
           Chain PolesKey FMOVLOC;
           //   Determine how much space is available for this pole.
           If %Found(FMOVLOC);
             AvailableSpace = TraysPerPole - MLTRAY;
           Else;
             AvailableSpace = TraysPerPole;
           EndIf;
           //   Fill the pole with Trays Left
           If AvailableSpace > 0;
             ToTrays = TraysLeft;
             //   If it's the first pole, keep track of trays this pole
             If FirstPole;
               FirstPole = *Off;
               If AvailableSpace >= TraysLeft;
                 FromTrays = TraysLeft;
               Else;
                 FromTrays = AvailableSpace;
               EndIf;
             EndIf;
             //   Determine how many trays go in this pole.
             If AvailableSpace >= TraysLeft;
               AvailableSpace = AvailableSpace - TraysLeft;
               TraysLeft = *Zero;
             Else;
               TraysLeft = TraysLeft - AvailableSpace;
               AvailableSpace = *Zero;
             EndIf;
             //   Write out pole allocation information
             ExSr SR_FMOVLOC;
           EndIf;
           //   Save Info about where we are now.
           ToSECT = SECT;
           ToBAY  = BAY;
           ToNORS = NORS;
           ToLORR = LORR;
           ToPOLE = POLE;
           ToPoleKey = PoleKey;
           //   If we are out of space, get the next pole.
           If AvailableSpace = *Zero;
             ExSr NextPole;
             ExSr GetPoleKey;
           EndIf;
         EndDo;
         //   Write out location info for the tag number scanned
         ExSr SR_FMOVJOB;

         //   Write out "No Move" Destination for NO MOVE item.
         ExSr SR_FMOVTO;

         //   Increment Next Job Number

       EndSr;

      /Eject
       //   ...........................................................
       //   :      SR_FMOVTO  - Output routine for FMOVTO             :
       //   :.........................................................:

       BegSr SR_FMOVTO;

         DESTID = 98;                                                         //|No Destination
         M2DATE = MJTDAT;
         M2MOVE = MJMOVE;
         M2ITEM = IMITEM;
         M2SIZE = IMSIZE;
         M2JOB# = MJJOB#;
         Chain Destination FMOVDESTNM;
         M2DSID = DESTID;
         If DoNotMove;
           M2DSID = 99;                                                       //|Do Not Move
         EndIf;
         Write RMOVTO;

       EndSr;

      /Eject
       //   ...........................................................
       //   :      SR_FMOVLOC - Output routine for FMOVLOC            :
       //   :.........................................................:

       BegSr SR_FMOVLOC;

         MLTDAT = TODAT;
         MLMOVE = BtnMov;
         MLSECT = SECT;
         MLBAY  = BAY;
         MLNOS  = NORS;
         MLPOLE = POLE;
         MLPLKY = PoleKey;
         MLLOR  = LORR;
         MLTRAY = TraysPerPole - AvailableSpace;
         MLDTLA = Today;
      /END-FREE
     C                   TIME                    MLTIME
      /FREE
         MLUSER = UserID;

         If %Found(FMOVLOC);
           Update RMOVLOC;
         Else;
           Write RMOVLOC;
         EndIf;

       EndSr;

      /Eject
       //   ...........................................................
       //   :      SR_FMOVJOB - Output routine for FMOVJOB            :
       //   :.........................................................:

       BegSr SR_FMOVJOB;

         Chain kFMOVCTL FMOVCTL;
         ThisJob = MHNJOB;
         If not %found(FMOVCTL);
           MHCRDT = TODAT;
           MHMOVE = BtnMov;
           MHWK#  = *Zero;
           MHSTAT = *Blank;
           MHNJOB = 2;
           MHNRUN = *Zero;
           MHITEM = *Blanks;
           MHSIZE = *Blanks;
           MHDTLA = Today;
      /END-FREE
     C                   Time                    MHTIME
      /FREE
           MHUSER = UserID;
           ThisJob = 1;
           Write RMOVCTL;
         Else;
           ThisJob = MHNJOB;
           MHNJOB = MHNJOB + 1;
           Update RMOVCTL;
         EndIf;

         MJTDAT = TODAT;                                                      // TODATE
         MJMOVE = BtnMov;                                                     // TODATE
         MJSTAT = *Blanks;                                                    // STATUS
         MJJOB# = ThisJob;                                                    // JOB #
         MJITEM = IMITEM;                                                     // ITEM #
         MJSIZE = IMSIZE;                                                     // SIZE CODE
         MJSPIT = '7208';                                                     // Chemical Item
         MJSPSZ = '700';                                                      // Chem Size Code
         MJPPM  = 1;                                                          // PPM
         MJLOOK = IMLOOK;                                                     // ALPHA SEARCH
         MJLOPT = *Blanks;                                                    // ALPHA USED AS LIMIT
         MJSERI = ISCODE;                                                     // SERIES CODE
         MJRDYD = $MDYDate($Date(TRCRDT));                                    // READY DATE
         MJTRAY = TRAYS;                                                      // # TRAYS
         If TRAYS / TraysPerPole < 9.99;
           MJPOLE = TRAYS / TraysPerPole;                                     // # POLES
         Else;
           MJPOLE = 0;                                                        // # POLES
         EndIf;
         MJHSE  = House;                                                      // HOUSE #
         MJSECT = SECT;                                                       // SECTION #
         MJBAY  = BAY;                                                        // BAY #
         MJNOS  = NORS;                                                       // NORTH/SOUTH
         MJSPOL = FromPOLE;                                                   // START POLE #
         MJSLOR = FromLORR;                                                   // START L/R
         MJTRBP = FromTrays;                                                  // # TRAYS BEG. POLE
         MJSPKY = FromPoleKey;                                                // START POLE KEY #
         MJEPOL = ToPOLE;                                                     // END POLE #
         MJELOR = ToLORR;                                                     // END L/R
         MJTREP = ToTrays;                                                    // # TRAYS END POLE
         MJEPKY = ToPoleKey;                                                  // END POLE KEY #
         MJRUN# = *Zero;                                                      // MOVE RUN #
         MJDTLA = Today;                                                      // LAST ACTIVITY DATE
      /END-FREE
     C                   Time                    MJTIME                          TIME
      /FREE
         MJUSER = UserID;                                                     // USER

         If %Found(FMOVJOB);
           Update RMOVJOB;
         Else;
           Write RMOVJOB;
         EndIf;

       EndSr;

      /Eject
       //   ...........................................................
       //   :      NextPole - Calculate what is the next Pole to use  :
       //   :.........................................................:

       BegSr NextPole;

         NoMorePoles = *Off;
         Select;
         When LorR = 'L' and Pole < BayPoles;
           Pole = Pole + 1;
         When LorR = 'L' and Pole = BayPoles;
           LorR = 'R';
         When LorR = 'R' and Pole > 1;
           Pole = Pole - 1;
         Other;
           NoMorePoles = *On;
         EndSl;
         If not NoMorePoles;
           Chain PolesKey FMOVLOC;
           If %Found(FMOVLOC) and MLTRAY >= TraysPerPole;
             PoleFull = *On;
           Else;
             PoleFull = *Off;
           EndIf;
         EndIf;

         ExSr GetPoleKey;

       EndSr;

      /Eject
       //   ...........................................................
       //   :      GetPoleKey - Determine Key for Current Pole        :
       //   :.........................................................:

       BegSr GetPoleKey;

         If LorR = 'L';
           PoleKey = Pole;
         Else;
           PoleKey = 26 + (25 - Pole);
         EndIf;

       EndSr;

      /Eject
       //   ...........................................................
       //   :      WhereAmI - Determine where user is based on scan   :
       //   :.........................................................:

       BegSr WhereAmI;

         If Trays = *Zero;
TEST       Pole = %Int(Pole + (Trays/55));
         EndIf;

       EndSr;

      /Eject
       //   ...........................................................
       //   :      GetMaxTrays - Determine # Trays remaining this bay :
       //   :.........................................................:

       BegSr GetMaxTrays;

         //    The calculation for MaxTrays is based on how much space remains in the bay
         //    beginning from the users current location.  i.e.- If the bay is 100% unallocated
         //    and the user is at Pole R1, the MaxTrays will equal the Trays per Pole figure.
         //    This subroutine also updates the Pole Buttons if UpdatePoles is *On.

         CurrentPole = POLE;
         CurrentLorR = LORR;
         CurrentPoleKey = PoleKey;
         If UpdatePoles;
           POLE = 1;
           LORR = 'L';
           X = 0;
           Clear BtnPolDS;
      /END-FREE
     C                   MoveA     Off15         *In(61)
      /FREE
         EndIf;
         MaxTrays = *Zero;
         //   Find unallocated Trays in Bay
         DoU NoMorePoles;
           Chain(N) PolesKey FMOVLOC;
           If %Found(FMOVLOC);
             Used = MLTRAY;
           Else;
             Used = *Zero;
           EndIf;
           MaxTrays = MaxTrays + (TraysPerPole - Used);
           If UpdatePoles and
                 Used < TraysPerPole and
                 LORR = CurrentLORR;
             X = X + 1;
             BtnPolAra(X) = POLE;
             *In(60 + X) = *On;
           EndIf;
           ExSr NextPole;
         EndDo;
         //   Get Max Trays   (Max Trays = Current Pole UnAllocated through Next Allocated Pole)

         Pole = CurrentPole;
         LORR = CurrentLorR;
         PoleKey = CurrentPoleKey;
       EndSr;


      /Eject
       //   ...........................................................
       //   :      *INZSR - Initialization Subroutine                 :
       //   :.........................................................:

       BEGSR *INZSR;

      /END-FREE
     C     kFMOVCTL      KList
     C                   KFld                    TODAT
     C                   KFld                    BtnMov

     C     PolesKey      KList
     C                   KFld                    TODAT
     C                   KFld                    BtnMov
     C                   KFld                    SECT
     C                   KFld                    BAY
     C                   KFld                    NORS
     C                   KFld                    LORR
     C                   KFld                    POLE

      //    SectKey       KLIST
      //                  KFLD                    S1GHSECT
      //                  KFLD                    S1GHBAY
      //                  KFLD                    S1GHNORS

      /FREE
         Today = $MDYDate($Date(0));
         UserID= $User();
         $ERR_Prog = $Program;
         $ERR_Libr = '*LIBL';
         $ERR_MsgF = 'KPMSGF';
         SingleMoves = *On;
         //    *HiVal        SetGT     FMOVJOB
         ExSr Load00;
         ExSr Scrn00;

       EndSR;
      /Eject
      /END-FREE
      /COPY QFunctDefn,$CommandSR
      /Copy QFunctDefn,$ErrMsgSR
**  8a  |
Stage 1 |      1
Stage 2 |      2
Stage 3 |      3
Fixing  |      4
Resow   |      5
Hld/Ship|      6
Early SH|      7
Space   |      8
Special |      9
Early GR|     10
