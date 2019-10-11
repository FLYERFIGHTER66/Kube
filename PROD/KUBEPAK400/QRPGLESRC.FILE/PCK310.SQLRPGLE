     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format

     FPCK310FM  CF   E             WORKSTN

      //  Main procedure prototype & interface
     D PCK310          PR                  ExtPgm('PCK310')
     D PCK310          PI

      //  Function Prototypes
     D/COPY QFunctDefn,$_Dates
     D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$User
     D Initialize      PR
     D Scrn01          PR
     D Edit01          PR
     D SetInd          PR
     D  #ind                         10A   const
     D PCK020CL9       PR                  ExtPgm('PCK020CL9')
     D  #SelDate                           Like(SelDate)
     D  #SelTruk                           Like(SelTruk)
     D  #SelGrup                           Like(SelGrup)
     D  #SelList                           Like(SelList)
     D  #Printer                           Like(Printer)
     D  #SelCopy                           Like(SelCopy)
     D PCK920CL9       PR                  ExtPgm('PCK920CL9')
     D  #SelDate                           Like(SelDate)
     D  #SelTruk                           Like(SelTruk)
     D  #Printer                           Like(Printer)
     D  #SelCopy                           Like(SelCopy)
     D PCK930CL9       PR                  ExtPgm('PCK930CL9')
     D  #SelFord                           Like(SelFord)
     D  #SelTord                           Like(SelTord)
     D  #Printer                           Like(Printer)
     D  #SelCopy                           Like(SelCopy)
     D PCK040CL9       PR                  ExtPgm('PCK040CL9')
     D  #SelFord                           Like(SelFord)
     D  #SelTord                           Like(SelTord)
     D  #SelList                           Like(SelList)
     D  #Printer                           Like(Printer)
     D  #SelCopy                           Like(SelCopy)
     D PCK050CL9       PR                  ExtPgm('PCK050CL9')
     D  #SelDate                           Like(SelDate)
     D  #SelMast                           Like(SelMast)
     D  #SelGrup                           Like(SelGrup)
     D  #SelTruk                           Like(SelTruk)
     D  #SelList                           Like(SelList)
     D  #Printer                           Like(Printer)
     D  #SelCopy                           Like(SelCopy)

      //  Arrays
     D RepAra          S             55    DIM(7) CTDATA PERRCD(1)
     D IndAra          S             10    DIM(7) ALT(REPARA)

     D Screen          S              2S 0 Inz(*Zero)
     D SelDate7        S              7S 0 Inz(*Zero)
     D SelReport       S              2S 0 Inz(*Zero)

     D Seasons         DS                  DtaAra(WEB020CL)
     D  Seas01                        2S 0
     D  Seas02                        2S 0
     D  Seas03                        2S 0

     D RepNamDS        DS
     D  Rep01
     D  Rep02
     D  Rep03
     D  Rep04
     D  Rep05
     D  Rep06
     D  Rep07
     D  Rep                                Like(Rep01) Dim(7) Overlay(RepNamDS)

      /Free

      // DoW not *In03 and not *In05;
      //   ExFmt PCK310NR;
      //   If *In03;
      //     *InLR = *On;
      //     Return;
      //   EndIf;
      //   If *In05;
      //     Leave;
      //   EndIf;
      // EndDo;

         Initialize();
         In Seasons;

         Scrn01();

         Dow not *InLR;
           Select;
             When Screen = 01;
               Edit01();
           EndSl;
         EndDo;

         Return;

      /End-Free



      //========================================================================
     P Scrn01          B
     D Scrn01          PI
      /Free

         Screen = 01;

           ExFmt PCK31001;

         *In30 = *Off;     // Position Cursor last known location when *on

         Monitor;
           SelDate7 = $Date7($DateMDY(SelDate));
         On-Error;
         EndMon;

      /End-Free
     P Scrn01          E
      //========================================================================
     P Edit01          B
     D Edit01          PI
      /Free

         Select;
           When *In03 or Function = 3;
             *InLR = *On;
           When *In05 or Function = 5;
             Initialize();
             Scrn01();
           When *In05;
             Initialize();
             Scrn01();
           When *In11;
             Printer = $ChgPrt($User():'PCK310':'*USER');
             *In30 = *On;
             Scrn01();
           When SELREPT > 00;     // Report Type Selected.  Format Selection Criteria.
             SelReport = SELREPT;
             SelName = RepAra(SELREPT);
             SetInd(IndAra(SELREPT));
             Scrn01();
           When ADJDATE = 01;     //  Subtract a day
             SelDate = $MDYDate($AddDate($DateMDY(SelDate):-1));
             *In30 = *On;
             Scrn01();
           When ADJDATE = 02;     //  Add a day
             SelDate = $MDYDate($AddDate($DateMDY(SelDate):+1));
             *In30 = *On;
             Scrn01();
           When ADJTRUK = 01;     //  Previous Truck
             Exec SQL
               SELECT  max( THTRK# )
               INTO   :SelTruk
               FROM    FTRHDRH
               WHERE   THSHDT = :SelDate7
                 and   THTRK# < :SelTruk;
             *In30 = *On;
             Scrn01();
           When ADJTRUK = 02;     //  Next Truck
             Exec SQL
               SELECT  min( THTRK# )
               INTO   :SelTruk
               FROM    FTRHDRH
               WHERE   THSHDT = :SelDate7
                 and   THTRK# > :SelTruk;
             *In30 = *On;
             Scrn01();
           When ADJMAST = 01;     //  Previous Master
             Exec SQL
               SELECT  max( MNSEQ# )
               INTO   :SelMast
               FROM    FMANUAL
               WHERE   MNDATE = :SelDate7
                 and   MNSEQ# < :SelMast;
             *In30 = *On;
             Scrn01();
           When ADJMAST = 02;     //  Next Master
             Exec SQL
               SELECT  min( MNSEQ# )
               INTO   :SelMast
               FROM    FMANUAL
               WHERE   MNDATE = :SelDate7
                 and   MNSEQ# > :SelMast;
             *In30 = *On;
             Scrn01();
           When ADJGRUP = 01;     //  Previous Group
             Exec SQL
               SELECT  max( HCGRUP )
               INTO   :SelGrup
               FROM    FMORLHCFG, FMORLSEASL
               WHERE   HCLIST = HSLIST
                 and   HCACTV = 'Y'
                 and   HSSNCD in (:Seas01 , :Seas02, :Seas03)
                 and   HCGRUP < :SelGrup;
             *In30 = *On;
             Scrn01();
           When ADJGRUP = 02;     //  Next Master
             Exec SQL
               SELECT  min( HCGRUP )
               INTO   :SelGrup
               FROM    FMORLHCFG, FMORLSEASL
               WHERE   HCLIST = HSLIST
                 and   HCACTV = 'Y'
                 and   HSSNCD in (:Seas01 , :Seas02, :Seas03)
                 and   HCGRUP > :SelGrup;
             *In30 = *On;
             Scrn01();
           When ADJLIST = 01;     //  Previous List
             Exec SQL
               SELECT  max( HSLIST )
               INTO   :SelList
               FROM    FMORLSEASL
               WHERE   HSSNCD in (:Seas01 , :Seas02, :Seas03)
                 and   HSLIST < :SelList;
             *In30 = *On;
             Scrn01();
           When ADJLIST = 02;     //  Next List
             Exec SQL
               SELECT  min( HSLIST )
               INTO   :SelLIST
               FROM    FMORLSEASL
               WHERE   HSSNCD in (:Seas01 , :Seas02, :Seas03)
                 and   HSLIST > :SelList;
             *In30 = *On;
             Scrn01();
           When ADJCOPY = 01 and SelCopy > 01;     //  Subtract a copy
             SelCopy -= 01;
             *In30 = *On;
             Scrn01();
           When ADJCOPY = 02 and SelCopy < 99;     //  Add a copy
             SelCopy += 01;
             *In30 = *On;
             Scrn01();
           When (PRINTBTN = 1 or *In09) and SelReport > 0;    //  Print Something!
             PrintReport(SelReport);
             Scrn01();
           Other;                 //  Undefined
             *In30 = *On;
             Scrn01();
         ENDSL;


      /End-Free
     P Edit01          E

      //========================================================================
     P PrintReport     B
     D PrintReport     PI
     D  #Report                       2P 0 Const
      /Free

         Select;
           When #Report = 01; // Not Ready - Dock picks.
             PCK050CL9(SELDATE:SELMAST:SELGRUP:SELTRUK:SELLIST:PRINTER:SELCOPY);
           When #Report = 02; // Not Ready - Dock picks for a given range of orders
             PCK040CL9(SELFORD:SELTORD:SELLIST:PRINTER:SELCOPY);
           When #Report = 03; // Dock picks for a specific truck
             PCK020CL9(SELDATE:SELTRUK:SelGrup:SelList:PRINTER:SELCOPY);
           When #Report = 04; // Truck picks for a given range of orders.
             PCK930CL9(SelFord:SelTord:PRINTER:SELCOPY);
           When #Report = 05; // Truck picks for a specific truck
             PCK920CL9(SELDATE:SELTRUK:PRINTER:SELCOPY);
           When #Report = 06; // Not Ready
             Exfmt PCK310BR;
           When #Report = 07; // Not Ready
             Exfmt PCK310BR;
           When #Report = 08; // Not Ready
             Exfmt PCK310BR;
           When #Report = 09; // Not Ready
             Exfmt PCK310BR;
         EndSl;

      /End-Free
     P PrintReport     E
      //========================================================================
     P SetInd          B
     D SetInd          PI
     D  #ind                         10A   const
     C                   MOVEA     #ind          *In(60)
     C                   MOVEA     '0000000'     *In(41)
     C                   Eval      *In(40+SelRept) = *On
     P SetInd          E
      //========================================================================
     P Initialize      B
     D Initialize      PI

     D  x              S              2S 0 Inz(1)
      /Free

         SetInd('0000000');
         SelName   = *Blank;
         SelReport = *Zeros;

         Printer = $DftPrt($User():'PCK310':'*USER');

         Reset x;
         DoW x <= %elem(RepAra);
           Rep(x) = RepAra(x);
           If RepAra(x) = *Blanks;
             *In(70 + x) = '0';
           Else;
             *In(70 + x) = '1';
           EndIf;
           x += 1;
         EndDo;

         SelDate = $MDYDate($AddDate($Date(0):+1));
         SelTruk = '*ALL';
         SelMast = *Zero;
         SelGrup = '*ALL';
         SelList = '*ALL';
         SelFord = *Zero;
         SelTord = *Zero;

         SelCopy = 1;

      /End-Free
     P Initialize      E
** .+... 1 ...+... 2 ...+... 3 ...+... 4 ...+... 5 ...+... 6 ...+... 7 ...+... 8 ...+... 9 ...+... 0
Dock picks for given date. By Group, Truck & Stop.    -1111100       Criteria...  Ship Date: 1000000
Dock picks for a given range of orders. By Order.     -0000111                        Truck: 0100000
Dock picks for a specific truck.  By Truck / Stop.    -1101100                Master Number: 0010000
Truck picks for a given range of orders. By Order.    -0000011               Group Location: 0001000
Truck picks for a specific truck. By Stop.            -1100000                   Order List: 0000100
                                                       0000000                   From Order: 0000010
                                                       0000000                     To Order: 0000001
