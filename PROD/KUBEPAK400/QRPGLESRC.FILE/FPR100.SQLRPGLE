     H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')

      //?                                                              ?
      //??|                                                            |?
      //??|       Finished Crop Inventory                              |?
      //?|                                                            |?

      //?PROGRAM NAME-------- FPR100
      //?PROGRAMMER---------- WJB
      //?APPLICATION--------- SCAN GREENHOUSE FINISHED CROP FOR INVENTORY

      //?           CHANGE--DATE-------DESCRIPTION
      //?  1/25/16  WJB  Initial Programming

     FFPR100FM  CF   E             WORKSTN
     FFMINVT    IF   E           K DISK
     FFMUPCUPC  IF   E           K DISK
     FFMUPCITEM IF   E           K DISK    Rename(RMUPC:RMUPCITEM)
     FFCSECTL1  IF   E           K DISK
     FFFINPPDTAGUF   E           K DISK    Rename(FFINPPDTAG:RFINPPDTAG)
     FFFINLOC   UF A E           K DISK

      //? CONTROL FILE ARRAYS
     D  NSEW           S              2A   DIM(14) CTDATA PERRCD(1) ASCEND
     D  NSEWtxt        S              9A   DIM(14) ALT(NSEW)

     D  OvrTags        S               N

     d pIndicators     s               *   Inz(%Addr(*In))
     d indicatorNames  ds                  Based(pIndicators)
     d  Using_PPD                      N   Overlay(indicatorNames: 10)

      //? location array
     D LocCode         DS                  INZ
     D  locSect                       2S 0
     D  locZero                       1S 0
     D  locBay                        2S 0
     D  locNorS                       1
     D  locEorW                       1
      //? Section Array
     D SSECTDS         DS                  INZ
     D  SSECT01
     D  SSECT02
     D  SSECT03
     D  SSECT04
     D  SSECT05
     D  SSECT06
     D  SSECT07
     D  SSECT00                       2  0 DIM(7) OVERLAY(SSECTDS)
      //? Bay Array
     D SBAYDS          DS                  INZ
     D  SBAY01
     D  SBAY02
     D  SBAY03
     D  SBAY04
     D  SBAY05
     D  SBAY06
     D  SBAY07
     D  SBAY08
     D  SBAY09
     D  SBAY10
     D  SBAY11
     D  SBAY12
     D  SBAY13
     D  SBAY14
     D  SBAY15
     D  SBAY16
     D  SBAY17
     D  SBAY18
     D  SBAY19
     D  SBAY20
     D  SBAY21
     D  SBAY22
     D  SBAY23
     D  SBAY24
     D  SBAY25
     D  SBAY26
     D  SBAY27
     D  SBAY28
     D  SBAY29
     D  SBAY30
     D  SBAY31
     D  SBAY32
     D  SBAY33
     D  SBAY34
     D  SBAY35
     D  SBAY36
     D  SBAY37
     D  SBAY38
     D  SBAY39
     D  SBAY40
     D  SBAY41
     D  SBAY42
     D  SBAY43
     D  SBAY44
     D  SBAY45
     D  SBAY46
     D  SBAY47
     D  SBAY48
     D  SBAY49
     D  SBAY50
     D  SBAY51
     D  SBAY52
     D  SBAY53
     D  SBAY54
     D  SBAY55
     D  SBAY56
     D  SBAY57
     D  SBAY58
     D  SBAY59
     D  SBAY60
     D  SBAY61
     D  SBAY62
     D  SBAY63
     D  SBAY64
     D  SBAY65
     D  SBAY66
     D  SBAY67
     D  SBAY68
     D  SBAY69
     D  SBAY70
     D  SBAY71
     D  SBAY72
     D  SBAY00                        2A   DIM(72) OVERLAY(SBAYDS)
      //? Bay Array
     D SNOSDS          DS                  INZ
     D  SNOS01
     D  SNOS02
     D  SNOS03
     D  SNOS04
     D  SNOS05
     D  SNOS06
     D  SNOS07
     D  SNOS08
     D  SNOS09
     D  SNOS10
     D  SNOS11
     D  SNOS12
     D  SNOS13
     D  SNOS14
     D  SNOS15
     D  SNOS00                        2A   DIM(15) OVERLAY(SNOSDS)
     D                 DS
     D  CSRFLD                 1     10
     D  CSRFL#                 4      5  0

     D                 DS
     D  NOS                    1      2
     D  NORS                   1      1
     D  EORW                   2      2

     D                SDS
     D  PROGID                 1     10                                         PROGRAM NAME
     D  RLIBR                 81     90                                         RUN LIBRARY
     D  @JOB                 244    253
     D  USERID               254    263                                         USER I.D.
     D  SLIBR                314    323                                         SOURCE LIBRARY

      //? Field Definitions
     D  Screen         S              2S 0
     D  ThisSect       S              2S 0
     D  MinSect        S              2S 0
     D  MaxSect        S              2S 0
     D  BayX           S              2S 0
     D  NoSX           S              2S 0
     D  User           S             10A
     D  Today          S              6S 0
     D  Now            S              6S 0
     D  CurrentPole    S                   Like( FLSRTP )
     D  CLWKTR         S              3S 0
     D  STRDAT         S              7S 0
     D  x              S              3S 0
     D  RepeatScrn01   S               N

      //? Copy Books
     D/COPY QFunctDefn,$ErrMsg

      //? Function Prototypes
     D/COPY QFunctDefn,$_Dates
     D/COPY QFunctDefn,$Monday
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$Now
     D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$isCust
     D PLANTING        PR                  ExtPgm('FCR500CL')
     D  #SelTag#                      8P 0 const
     D  #SelSect                      2P 0 const
     D  #SelBay                       2P 0 const
     D  #SelNorS                      1A   const
     D  #SelEorW                      1A   const
     D  #Printer                     10A   const
     D BAYSHEET        PR                  ExtPgm('FPR102CL')
     D  #SelSect                      2P 0 const
     D  #SelBay                       2P 0 const
     D  #SelNorS                      1A   const
     D  #SelEorW                      1A   const
     D  #Printer                     10A   const
     D TableLookup     PR                  ExtPgm('XATABLE')
     D  #TABID                        2A   const
     D  ##KEYP#                       2A   const
     D  ##EELM#                       6A   const
     D GetCusName      PR            70A
     D  #SelCust                      6P 0 const

     d Format          s              8A   Inz('DEVD0600')
     d ipaddress       s             15a
     d Rcvar           S           5000A   Inz
     d Varlen          S             10i 0 Inz(5000)
     d Cust@           S              6A
     d FRMDAT_DT       S               D
     d SHIPDT_DT       S               D

     d $getipaddress   pr                  extpgm('QDCRDEVD')
     d   rcvar                     5000
     d   varlen                      10i 0
     d   format                       8
     d   @job                        10
     d   apierror                   256

     d APIError        ds                  Qualified
     d  BytesP                 1      4I 0 inz(%size(apiError))
     d  BytesA                 5      8I 0 inz(0)
     d  Messageid              9     15
     d  Reserved              16     16
     d  messagedta            17    256


      /FREE
       DoW *InLR <> *On;
         Select;
         When Screen = 01;
           ExSr Edit01;
         When Screen = 02;
           ExSr Edit02;
         When Screen = 03;
           ExSr Edit03;
         When Screen = 04;
           ExSr Edit04;
         When Screen = 05;
           ExSr Edit05;
         When Screen = 06;
           ExSr Edit06;
         When Screen = 07;
           ExSr Edit07;
         When Screen = 08;
           ExSr Edit08;
         When Screen = 09;
           ExSr Edit09;
         When Screen = 10;
           ExSr Edit10;
         When Screen = 11;
           ExSr Edit11;
         When Screen = 12;
           ExSr Edit12;
         When Screen = 13;
           ExSr Edit13;
         When Screen = 14;
           ExSr Edit14;
         When Screen = 15;
           ExSr Edit15;
         Other;
           *InLR = *On;
         EndSL;
       EndDo;

       Return;


       //?  ...........................................................
       //?  :      Load01 - Load Screen 01                            :
       //?  :.........................................................:
       BegSr Load01;

         RepeatScrn01 = *Off;
         Using_PPD = *On;   //Use PPD# by default
         *IN50 = *OFF;

           $getipaddress( rcvar   :
                          varlen  :
                          format  :
                          @job    :
                          Apierror
                                   );
           ipaddress = %subst( rcvar:878:15);
         //dsply ipaddress ' ';

       EndSr;

       //?  ...........................................................
       //?  :      Load02 - Load Screen 02                            :
       //?  :.........................................................:
       BegSr Load02;
         STRDAT = $Date7($DateMDY(FRMDAT));
         RANGE = 0;
         Reset LocCode;
       EndSr;

       //?  ...........................................................
       //?  :      Load03 - Load Screen 03                            :
       //?  :.........................................................:
       BegSr Load03;

         ThisSect = 0;
         MinSect = 99;
         MaxSect = 00;
         For X = 1 to 7;
           *In(20+x)  = *Off;
           Exec SQL
             SELECT min(GHSECT)
             INTO  :ThisSect
             FROM   FCSECT
             WHERE  GHOUSE =  :Range
               and  GHUSED <> 'N'
               and  GHSECT  > :ThisSect;
           If SQLSTATE = '00000';
             SSect00(x) = ThisSect;
             *In(20+x)  = *On;
             If ThisSect > 0 and ThisSect < MinSect;
               MinSect = ThisSect;
             EndIf;
             If ThisSect > MaxSect;
               MaxSect = ThisSect;
             EndIf;
           EndIf;
         Endfor;

         Sect  = 0;

       EndSr;

       //?  ...........................................................
       //?  :      Load04 - Load Screen 04                            :
       //?  :.........................................................:
       BegSr Load04;

         BayX = *Zero;
         Clear SBAY00;
         SetLL Sect FCSECTL1;
         ReadE Sect FCSECTL1;
         DoW not %EOF(FCSECTL1);
           Bay  = GHBAY;
           BayX = BayX + 1;
           SBay00(BayX) = %Char(GHBAY);
           SetGT SectBay FCSECTL1;
           ReadE Sect FCSECTL1;
         EndDo;

         Bay  = *Zero;

       EndSr;

       //?  ...........................................................
       //?  :      Load05 - Load Screen 05                            :
       //?  :.........................................................:
       BegSr Load05;

         For x =  1 to 15;
           *In(30+x) = *Off;     // Inz Ind 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45
         EndFor;

         NoSX = *Zero;
         Clear SNoS00;
         SetLL SectBay FCSECTL1;
         ReadE SectBay FCSECTL1;
         DoW not %EOF(FCSECTL1);
           NoSX = NoSX + 1;
           *In(30+NoSX) = *On;
           NORS = GHNORS;
           EORW = GHEORW;
           SNoS00(NoSX) = GHNORS + %Trim(GHEORW);
           SetGT SectBaySide FCSECTL1;
           ReadE SectBay FCSECTL1;
         EndDo;

         NOS = *Blanks;

       EndSr;

       //?  ...........................................................
       //?  :      Load06 - Load Screen 06                            :
       //?  :.........................................................:
       BegSr Load06;

      /END-FREE
     C                   Z-ADD     1             X
     C     NOS           LOOKUP    NSEW(X)                            90  90
     C   90              Eval      NSEWtext = NSEWtxt(X)
     C  N90              Eval      NSEWtext = 'Not Valid'

      /FREE
       EndSr;

       //?  ...........................................................
       //?  :      Load07 - Load Screen 07                            :
       //?  :.........................................................:
       BegSr Load07;

         Eval UPC# = *Zero;
         Eval PPD# = *Zero;

       EndSr;

       //?  ...........................................................
       //?  :      Load08 - Load Screen 08                            :
       //?  :.........................................................:
       BegSr Load08;

         DES1 = IMDES1;
         If FPQTYACTL <> *Zero;
           FUQTY  = FPQTYACTL;
          Else;
           FUQTY  = FPQTYPROJ;
         EndIf;
         TRAYIN = FUQTY;

         Exec SQL
           SELECT ( SZCUBF * :TrayIn ) / 200
           INTO   :FUTOTP
           FROM    FMSIZE
           WHERE   SZCODE = :IMSIZE;

         POLEIN = *Zero;

       EndSr;

       //?  ...........................................................
       //?  :      Load09 - Load Screen 09                            :
       //?  :.........................................................:
       BegSr Load09;
         ENDPOLE = %Int(POLE + %Int(POLEIN));
       EndSr;

       //?  ...........................................................
       //?  :      Load10 - Load Screen 10                            :
       //?  :.........................................................:
       BegSr Load10;
       EndSr;

       //?  ...........................................................
       //?  :      Load11 - Load Screen 11                            :
       //?  :.........................................................:
       BegSr Load11;
       EndSr;

       //?  ...........................................................
       //?  :      Load12 - Load Screen 12                            :
       //?  :.........................................................:
       BegSr Load12;
       EndSr;

       //?  ...........................................................
       //?  :      Load13 - Load Screen 13                            :
       //?  :.........................................................:
       BegSr Load13;
         ItemSize = %Trim(IMITEM) + '-' + %Trim(IMSIZE);
         PrintTag = TagDft;
         If CUST <> 0;
           CUSNAME = GetCusName(CUST);
         EndIf;
       EndSr;

       //?  ...........................................................
       //?  :      Load14 - Load Screen 14                            :
       //?  :.........................................................:
       BegSr Load14;
         If PrinterTag = *Blanks;
           PrinterTag = $DftPrt('*NONE':'FPR100_1':'*PGM');
         EndIf;
       EndSr;

       //?  ...........................................................
       //?  :      Load15 - Load Screen 15                            :
       //?  :.........................................................:
       BegSr Load15;
         If PrinterBay = *Blanks;
           PrinterBay = $DftPrt('*NONE':'FPR100_2':'*PGM');
         EndIf;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn01 - Display Screen 01                         :
       //?  :.........................................................:
       BegSr Scrn01;
         Screen = 01;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FPR10001;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn02 - Display Screen 02                         :
       //?  :.........................................................:
       BegSr Scrn02;
         Screen = 02;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FPR10002;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn03 - Display Screen 03                         :
       //?  :.........................................................:
       BegSr Scrn03;
         Screen = 03;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FPR10003;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn04 - Display Screen 04                         :
       //?  :.........................................................:
       BegSr Scrn04;
         Screen = 04;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FPR10004;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn05 - Display Screen 05                         :
       //?  :.........................................................:
       BegSr Scrn05;
         Screen = 05;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FPR10005;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn06 - Display Screen 06                         :
       //?  :.........................................................:
       BegSr Scrn06;
         Screen = 06;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FPR10006;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn07 - Display Screen 07                         :
       //?  :.........................................................:
       BegSr Scrn07;
         Screen = 07;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FPR10007;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn08 - Display Screen 08                         :
       //?  :.........................................................:
       BegSr Scrn08;
         Screen = 08;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FPR10008;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn09 - Display Screen 09                         :
       //?  :.........................................................:
       BegSr Scrn09;
         Screen = 09;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FPR10009;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn10 - Display Screen 10                         :
       //?  :.........................................................:
       BegSr Scrn10;
         Screen = 10;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FPR10010;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn11 - Display Screen 11                         :
       //?  :.........................................................:
       BegSr Scrn11;
         Screen = 11;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FPR10011;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn12 - Display Screen 12                         :
       //?  :.........................................................:
       BegSr Scrn12;
         Screen = 12;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FPR10012;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn13 - Display Screen 13                         :
       //?  :.........................................................:
       BegSr Scrn13;
         Screen = 13;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FPR10013;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn14 - Display Screen 14                         :
       //?  :.........................................................:
       BegSr Scrn14;
         Screen = 14;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FPR10014;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn15 - Display Screen 15                         :
       //?  :.........................................................:
       BegSr Scrn15;
         Screen = 15;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FPR10015;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Edit01 - Edit Screen 01                            :
       //?  :.........................................................:
       BegSr Edit01;                                                          //?Enter Date

         //? CHK F KEYS
         Select;
         When *InKB or *InKF;
           ExSr Load01;
           ExSr Scrn01;
         When *InKC;
           *InLR = *On;
           Return;
           //? CHECK INPUT
         When FrmDat  = *Zeros;                                               //?No Date Entered
           $ERR_MsgID = 'DATE902';
           $ERR_MsgData = 'Plant';
           FRMDAT = $MDYDate($Date(0));
           ExSr $SndError;
           ExSr Scrn01;
         When not $isDate#(FRMDAT:'*MDY');
           $ERR_MsgID = 'DATE901';
           $ERR_MsgData = %Char(FRMDAT);
           ExSr $SndError;
           ExSr Scrn01;
         Other;
           ExSr Load02;
           If not RepeatScrn01;
             ExSr Scrn02;
           EndIf;
         EndSl;

       EndSr;

       //?  ...........................................................
       //?  :      Edit02 - Edit Screen 02                            :
       //?  :.........................................................:
       BegSr Edit02;                                                          //?Select G/H Range

         Select;

         When *InKB;
           ExSr Scrn01;

         When *InKC;
           *InLR = *On;

         When Range <> 0 and SRANGE <> 0;
           $ERR_MsgID = 'FPR1000';
           ExSr $SndError;
           ExSr Scrn02;

         When LocCode <> *Blanks
               and LocCode <> '00000  ';
           Chain SectBaySide3 FCSECTL1;

           If %Found(FCSECTL1);
             Range  = GHOUSE;
             Sect   = locSect;
             ExSr Load03;
             Sect   = locSect;
             GHSECT = locSect;

             Bay    = locBay;
             ExSr Load04;
             Bay    = locBay;
             GHBAY  = locBay;

             NOS    = locNorS + locEorW;
             NorS   = locNorS;
             EorW   = locEorW;
             ExSr Load05;
             NOS    = locNorS + locEorW;
             NorS   = locNorS;
             EorW   = locEorW;
             GHNORS = locNorS;
             GHEORW = locEorW;

             Clear LocCode;

             ExSr Load06;
             ExSr Scrn06;
            Else;
             Clear LocCode;
             ExSr Scrn02;
           EndIf;

         When Range = *Zero and SRANGE = *Zero;
           $ERR_MsgID = 'FCR1001';
           ExSr $SndError;
           ExSr Scrn02;

         When ( Range < 1 or Range > 3 ) and SRANGE = *Zero;
           $ERR_MsgID = 'FCR1002';
           ExSr $SndError;
           ExSr Scrn02;

         Other;

           If Range = 0 and SRANGE <> 0;
             RANGE = SRANGE;
           EndIf;

           GHOUSE = RANGE;

           ExSr Load03;
           ExSr Scrn03;

         EndSl;

       EndSr;


       //?  ...........................................................
       //?  :      Edit03 - Edit Screen 03                            :
       //?  :.........................................................:
       BegSr Edit03;                                                          //?Edit G/H Section

         Select;

         When *InKB;
           ExSr Scrn02;

         When *InKC;
           *InLR = *On;

         When Sect  = *Zero and SSect  = *Zero;
           $ERR_MsgID = 'FCR1003';
           ExSr $SndError;
           ExSr Scrn03;

         When Sect <> *Zero and SSect <> *Zero;
           $ERR_MsgID = 'FPR1000';
           ExSr $SndError;
           ExSr Scrn03;

         When (Sect < MinSect or Sect > MaxSect)
               and SSect  = *Zero;
           $ERR_MsgID = 'FCR1004';
           ExSr $SndError;
           ExSr Scrn03;

         Other;

           If Sect  = *Zero and SSect  <> *Zero;
             Sect  = SSect00(SSect);
           EndIf;

           GHSECT  = Sect;
           locSect = Sect;
           ExSr Load04;
           ExSr Scrn04;

         EndSl;

       EndSr;


       //?  ...........................................................
       //?  :      Edit04 - Edit Screen 04                            :
       //?  :.........................................................:
       BegSr Edit04;                                                          //?Select Bay

         Select;

         When *InKB;
           ExSr Scrn03;

         When *InKC;
           *InLR = *On;

         When Bay   = *Zero and SBay   = *Zero;
           $ERR_MsgID = 'FCR1005';
           ExSr $SndError;
           ExSr Scrn04;

         When Bay  <> *Zero and SBay  <> *Zero;
           $ERR_MsgID = 'FPR1000';
           ExSr $SndError;
           ExSr Scrn04;

         When Bay <> *Zero and
               ( %Char(Bay) < Sbay00(1) or
               %Char(Bay) > SBay00(BayX) );
           $ERR_MsgID = 'FCR1006';
           ExSr $SndError;
           ExSr Scrn04;

         When SBay <> *Zero and
               %Len(%Trim(SBay00(SBay))) <= *Zero;
           $ERR_MsgID = 'FCR1005';
           ExSr $SndError;
           ExSr Scrn04;

         Other;

           If Bay   = *Zero and SBay   <> *Zero;
             Bay   = %Int(SBay00(SBay));
           EndIf;

           locBay = Bay;
           GHBAY  = Bay;
           ExSr Load05;
           ExSr Scrn05;

         EndSl;
       EndSr;

       //?  ...........................................................
       //?  :      Edit05 - Edit Screen 05                            :
       //?  :.........................................................:
       BegSr Edit05;                                                          //?N, S, E, W.

         Chain SectBaySide2 FCSECTL1;

         Select;

         When *InKB;
           ExSr Scrn04;

         When *InKC;
           *InLR = *On;

         When SNOS <> *Zero and NOS <> *Blanks;
           $ERR_MsgID = 'FCR1007';
           ExSr $SndError;
           ExSr Scrn05;

         When SNOS  = *Zero and NOS  = *Blanks;
           $ERR_MsgID = 'FPR1000';
           ExSr $SndError;
           ExSr Scrn05;

         When NOS <> *Blanks and not %Found(FCSECTL1);
           $ERR_MsgID = 'FCR1007';
           ExSr $SndError;
           ExSr Scrn05;

         Other;

           If SNOS <> *Zero and NOS = *Blanks;
             NOS   = SNOS00(SNOS);
      /END-FREE
     C                   Z-ADD     1             X
     C     NOS           LOOKUP    NSEW(X)                            90  90
     C   90              Eval      NSEWtext = NSEWtxt(X)
     C  N90              Eval      NSEWtext = 'Not Valid'
      /FREE
           EndIf;

           GHNORS = %Subst(NOS:1:1);
           GHEORW = %Subst(NOS:2:1);
           locNorS= %Subst(NOS:1:1);
           locEorW= %Subst(NOS:2:1);
           ExSr Load06;
           ExSr Scrn06;

         EndSl;
       EndSr;

       //?  ...........................................................
       //?  :      Edit06 - Edit Screen 06                            :
       //?  :.........................................................:
       BegSr Edit06;                                                          //?Pole
         Select;

         When *InKB;
           ExSr Scrn05;

         When *InKC;
           *InLR = *On;

         When *InKF;
           ExSr Load15;
           ExSr Scrn15;
           ExSr Edit15;
           ExSr Load02;
           ExSr Scrn02;

         When *InKG;
           ExSr Load15;
           ExSr Scrn15;
           ExSr Edit15;
           ExSr Load03;
           ExSr Scrn03;

         When *InKH;
           ExSr Load15;
           ExSr Scrn15;
           ExSr Edit15;
           ExSr Load04;
           ExSr Scrn04;

         When *InKI;
           ExSr Load15;
           ExSr Scrn15;
           ExSr Edit15;
           ExSr Load05;
           ExSr Scrn05;

         When POLE <= *Zero;
           $ERR_MsgID = 'FCR1011';
           ExSr $SndError;
           ExSr Scrn06;

         Other;

           ExSr Load07;
           ExSr Scrn07;

         EndSl;
       EndSr;

       //?  ...........................................................
       //?  :      Edit07 - Edit Screen 07                            :
       //?  :.........................................................:
       BegSr Edit07;                                                          //?Tag #

         If not Using_PPD;   // Use UPC#
           Chain UPC# FMUPCUPC ;
          Else;      // Use PPD#
           Chain PPD# FFINPPDTAG;
           Chain (FPITEM:FPSIZE) FMUPCITEM ;
         EndIf;

         Chain (UPCITEM:UPCSIZE) FMINVT;

         Select;

         When *InKB;
           ExSr Scrn06;

         When *InKC;
           *InLR = *On;

         When *InKH and not Using_PPD;
           Using_PPD = *On;   // Switch to PPD#
           ExSr Scrn07;

         When *InKH and Using_PPD;
           Using_PPD = *Off;    // Switch to UPC#
           ExSr Scrn07;

         When not Using_PPD and UPC# = *Zero;
           $ERR_MsgID = 'UPC0000';
           ExSr $SndError;
           ExSr Scrn07;

         When not Using_PPD and ( not %Found(FMUPCUPC ) or not %Found(FMINVT) );
           $ERR_MsgID   = 'UPC0001';
           $ERR_MsgData = %Char(UPC#);
           ExSr $SndError;
           ExSr Scrn07;

         When Using_PPD and PPD# = *Zero;
           $ERR_MsgID = 'FPR0002';
           ExSr $SndError;
           ExSr Scrn07;

         When Using_PPD and not %Found(FFINPPDTAG);
           $ERR_MsgID   = 'FPR0003';
           $ERR_MsgData = %Char(PPD#);
           ExSr $SndError;
           ExSr Scrn07;

         Other;

           If Using_PPD;   // PPD# Processing
             PLTG   = FPPLTG;
             SHIPDT = $MDYDate(FPSHIP);
             CUST   = FPCUST;
           EndIf;

           ExSr Load08;
           ExSr Scrn08;

         EndSl;
       EndSr;

       //?  ...........................................................
       //?  :      Edit08 - Edit Screen 08                            :
       //?  :.........................................................:
       BegSr Edit08;                                                          //?Trays and Poles
         Select;

         When *InKB;
           ExSr Scrn07;

         When *InKC;
           *InLR = *On;

         When TRAYIN = *Zero;
           $ERR_MsgID   = 'QTY0001';
           $ERR_MsgData = 'Counted';
           ExSr $SndError;
           ExSr Scrn08;

         When TRAYIN <> *Zero and POLEIN = *Zero;
           Exec SQL
             SELECT ( SZCUBF * :TrayIn ) / 200
             INTO   :POLEIN
             FROM    FMSIZE
             WHERE   SZCODE = :IMSIZE;
           ExSr Scrn08;

         Other;

           ExSr Load09;
           ExSr Scrn09;

         EndSl;
       EndSr;

       //?  ...........................................................
       //?  :      Edit09 - Edit Screen 09                            :
       //?  :.........................................................:
       BegSr Edit09;                                                          //?Ending Pole Number
         Select;

         When *InKB;
           POLEIN = *Zero;
           ExSr Scrn08;

         When *InKC;
           *InLR = *On;

         Other;

           If not Using_PPD;  //  UPC# Processing
             ExSr Load10;
             ExSr Scrn10;
            Else;     //  PPD# Processing
             ExSr Load13;
             ExSr Scrn13;
           EndIf;

         EndSl;
       EndSr;

       //?  ...........................................................
       //?  :      Edit10 - Edit Screen 10                            :
       //?  :.........................................................:
       BegSr Edit10;                                                          //?Planting
         Select;

         When *InKB;
           ExSr Scrn09;

         When *InKC;
           *InLR = *On;

         Other;

           ExSr Load11;
           ExSr Scrn11;

         EndSl;

       EndSr;

       //?  ...........................................................
       //?  :      Edit11 - Edit Screen 11                            :
       //?  :.........................................................:
       BegSr Edit11;                                                          //?Ship Date
         Select;

         When *InKB;
           ExSr Scrn10;

         When *InKC;
           *InLR = *On;

         When not $isDate#(SHIPDT:'*MDY') and SHIPDT <> 0;
           $ERR_MsgID   = 'DATE901';
           $ERR_MsgData = %Char(SHIPDT);
           ExSr $SndError;
           ExSr Scrn11;

         When $DateMDY(SHIPDT) < $Date(0) and SHIPDT <> 0 and SHIPDT <> 10100;
           $ERR_MsgID   = 'DATE908';
           ExSr $SndError;
           ExSr Scrn11;

         Other;

           If SHIPDT = 0;
             SHIPDT = 10100;   // Defaiult Value
           EndIf;
           ExSr Load12;
           ExSr Scrn12;

         EndSl;
       EndSr;

       //?  ...........................................................
       //?  :      Edit12 - Edit Screen 12                            :
       //?  :.........................................................:
       BegSr Edit12;                                                          //?Customer
         Select;

         When *InKB;
           ExSr Scrn11;

         When *InKC;
           *InLR = *On;

         When *InKC;
           *InLR = *On;

         When *InKD;
           CallP TableLookup('AB':'  ':CUST@);
           Monitor;
             Cust = %Dec(CUST@:6:0);
             On-Error;
               $ERR_MsgID   = 'CUS0004';
               ExSr $SndError;
           EndMon;
           ExSr Scrn12;

         When not $isCust(CUST) and CUST <> 0;
           $ERR_MsgID   = 'CUS0002';
           ExSr $SndError;
           ExSr Scrn12;

         Other;

           ExSr Load13;
           ExSr Scrn13;

         EndSl;
       EndSr;

       //?  ...........................................................
       //?  :      Edit13 - Edit Screen 13                            :
       //?  :.........................................................:
       BegSr Edit13;                                                          //?Confirmation
         Select;

         When *InKB;
           If Using_PPD;
             ExSr Scrn07;
            Else;
             ExSr Scrn12;
           EndIf;

         When *InKC;
           *InLR = *On;

         When *InKI;
           // Write the records for this item and prepare for the next item tag.
           ExSr WriteRecs;
           If SQLState <> '00000';
             $ERR_MsgID   = 'FPR0004';
             ExSr $SndError;
             ExSr Scrn13;
            Else;
             If PRINTTAG = 'Y';
               ExSr Load14;
               ExSr Scrn14;
              Else;
               POLE = ENDPOLE;
               ExSr Load06;
               ExSr Scrn06;
             EndIf;
           EndIf;

         Other;

           ExSr Scrn13;

         EndSl;
       EndSr;

       //?  ...........................................................
       //?  :      Edit14 - Edit Screen 14                            :
       //?  :.........................................................:
       BegSr Edit14;                                                          //?Print Tag
         Select;

         When *InKB;
           POLE = ENDPOLE;
           ExSr Load06;
           ExSr Scrn06;

         When *InKC;
           *InLR = *On;

         When *InKE;
           PrinterTag = $ChgPrt($User():'FPR100_1':PrinterTag);
           ExSr Scrn14;

         When *InKA;
           PLANTING(FLTAG#:0:0:*Blank:*Blank:PrinterTag);
           POLE = ENDPOLE;
           ExSr Load06;
           ExSr Scrn06;

         Other;
           ExSr Scrn14;

         EndSl;
       EndSr;

       //?  ...........................................................
       //?  :      Edit15 - Edit Screen 15                            :
       //?  :.........................................................:
       BegSr Edit15;                                                          //?Print Bay
         DoW not *InKB;
           Select;

           When *InKE;
             PrinterBay = $ChgPrt($User():'FPR100_2':PrinterBay);
             ExSr Scrn15;

           When *InKA;
             BAYSHEET(SECT:BAY:GHNORS:GHEORW:PrinterBay);
             LeaveSr;

           Other;

           EndSl;
         EndDo;
       EndSr;

       //?  ...........................................................
       //?  :      WriteRecs - Write / Update output files            :
       //?  :.........................................................:
       BegSr WriteRecs;

         Now   = $Now();
         SHIPDT_dt = $DateMDY(SHIPDT);
         FRMDAT_dt = $DateMDY(FRMDAT);
         Exec SQL
           Select Max(FLTAG#) + 1 Into :FLTAG# from FFINLOC;
         If Using_PPD;
           FPPRTD = 'Y';
           FPQTYCNTD += TRAYIN;
           FPFINTAG# = FLTAG#;
           FPUSER = $User();
           FPTIM00001 = $TIMESTAMP();
           Update RFINPPDTAG;
         EndIf;
         //  Write FFINLOC
         Exec SQL
           Insert Into FFINLOC  Values(
               :FLTAG#
             , :IMITEM
             , :IMSIZE
             , :RANGE
             , :SECT
             , :GHBAY
             , :GHNORS
             , :GHEORW
             , :POLE
             , :ENDPOLE
             , :POLEIN
             , :TRAYIN
             , :PLTG
             , :FRMDAT_dt
             , :SHIPDT_dt
             , :CUST
             , :PPD#
             ,  user
             ,  'FPR100'
             ,  current timestamp
             ,  user
             ,  'FPR100'
             ,  current timestamp );
         LastTag# = PPD#;
         LastUPC# = UPC#;

       EndSr;

       //?  ...........................................................
       //?  :      ERRMSG - Error Message Handling Subroutines        :
       //?  :.........................................................:
      /COPY QFunctDefn,$ErrMsgSr

       //?  ...........................................................
       //?  :      ExitSR - Exit Subroutine                           :
       //?  :.........................................................:

       BegSr ExitSR;

         *InLr = *On;
         Return;

       EndSr;

       //?  ...........................................................
       //?  :      *INZSR - Initialization Subroutine                 :
       //?  :.........................................................:

       BegSr *InzSR;

         Today = $MDYDate($Date(0));
         User  = $User();

         $ERR_PROG  = 'FPR100    ';                                           //?Pgm Msg Queue
         $ERR_MSGF  = 'KPMSGF';                                               //?Message File
         $ERR_LIBR  = '*LIBL';                                                //?Library

         FrmDat  = $MDYDate($Monday($Date(0):'SAT'));

         ExSr $ClrError;
         ExSr Load01;
         ExSr Scrn01;

      /END-FREE
     C     SectBay       KList                                                  ?
     C                   KFld                    SECT                         ?
     C                   KFld                    BAY                          ?

     C     SectBaySide   KList
     C                   KFld                    SECT
     C                   KFld                    BAY
     C                   KFld                    NORS
     C                   KFld                    EORW

     C     SectBaySide2  KList                                                  ?
     C                   KFld                    SECT                         ?
     C                   KFld                    BAY                          ?
     C                   KFld                    NORS                           ?
     C                   KFld                    EORW                         ?

     C     SectBaySide3  KList                                                  ?
     C                   KFld                    locSect                        ?
     C                   KFld                    locBay                         ?
     C                   KFld                    locNorS                        ?
     C                   KFld                    locEorW                      ?

     C     DFTKEY        KLIST
     C                   KFLD                    FLITEM
     C                   KFLD                    FLSIZE

     C     DefaultKey    KLIST                                                  ?
     C                   KFLD                    FLITEM                         ?
     C                   KFLD                    FLSIZE                         ?

      /FREE
       EndSr;
      /END-FREE
     P GetCusName      B
     D GetCusName      PI            70A
     D  #SelCust                      6P 0 const
     D  #CusName       S             70A
         Exec SQL
           SELECT   Trim(Char(int(:#SelCust))) || ' (' ||
                    Trim( TBSHRT)||') '||Trim(TBLONG)
           INTO    :#CusName
           FROM     XATABL
           WHERE    TBTBCD = 'AB'||right('00000'||int( :#SelCust ),5);
         If SQLState = '00000';
           Return #CusName;
          Else;
           Return '***No Customer***';
         EndIf;
     P GetCusName      E
**
N North
NENortheast
NWNorthwest
N1North-HB1
N2North-HB2
N3North-HB3
N4North-HB4
S South
SESoutheast
SWSouthwest
S1South-HB1
S2South-HB2
S3South-HB3
S4South-HB4
