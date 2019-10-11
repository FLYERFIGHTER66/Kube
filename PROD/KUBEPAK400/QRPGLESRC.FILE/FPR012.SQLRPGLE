     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: FPR012.01                                                  :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2016                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :                                                           ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? :  FPR012.01?Original Version                               ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  26      ?Sets Position to Indicator                      ?:
      *? :  03      ?Exit                                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFPR012FM  CF   E             WORKSTN
     F                                     SFILE(FPR01201S:RRN01)


      //  Main procedure prototype & interface
     D FPR012          PR                  ExtPgm('FPR012')
     D FPR012          PI

      *? Function Prototypes
     D Load01          PR
     D Scrn01          PR
     D Edit01          PR
     D OrderInq        PR                  ExtPgm('FPR013')
     D  #Order#                       6P 0 CONST
     D CustInq         PR                  ExtPgm('BIR245CLC')
     D  #Cust#                        6P 0 CONST
     D setDefault      PR
     D  #Order#                       6P 0 CONST

    ?D/COPY QFunctDefn,$_Dates
    ?D/COPY QFunctDefn,$ErrMsg
    ?D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$isPrinter
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$RtvMsgD
     D/COPY QFunctDefn,$isCust
     D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,QCMDEXC

      *? Data Structures
     D                SDS
     D  $PGM             *PROC

     D  RHORDR_DS    E DS                  ExtName(FHORDR)

      *? Field Definitions
     D   Screen        S              3S 0 Inz(0)                               ?Screen Number
     D   RRN01         S              4S 0 Inz(*Zero)                           ?RRN SFL Scrn 03
     D   SelDate7      S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   Now           S              6S 0 Inz(0)                               ?Time Now
     D   Today         S              6S 0 Inz(0)                               ?Today
     D   Today7        S              7S 0 Inz(0)                               ?Today YMD7
     D   Pink          S              1A   Inz('?')                             ?Color Code -?PINK
     D   White         S              1A   Inz('?')                              Color Code - White
     D   ADRX          S              1S 0 Inz(0)                               ?Address Index
     D   OVRPRTF       S            256A   Inz(' ')                             ?Override PRTF
     D   Order#        S              6S 0                                      ?Order# to Print
     D   LastOrder     S              6S 0                                      ?Order# to Print
     D   OrdTimeStamp  S               Z                                        ?Order# to Print
     D   CstmProj      S             30A                                        ?Order# to Print
     D   User          S             10A                                        ?Order# to Print
     D   SelPONO_      S             +2    Like(SelPONO)                        ?PO Search
     D   SelNAME_      S             +2    Like(SelNAME)                        ?Name Search
     D   SelSHCT_      S             +2    Like(SelSHCT)                        ?City Search
     D   SavORD#       S                   Like(SelORD#)                        ?Save ORD#
     D   SavCUST       S                   Like(SelCUST)                        ?Save CUST
     D   SavPONO       S                   Like(SelPONO)                        ?Save PONO
     D   SavNAME       S                   Like(SelNAME)                        ?Save NAME
     D   SavDTRQ       S                   Like(SelDTRQ)                        ?Save DTRQ
     D   SavSHCT       S                   Like(SelSHCT)                        ?Save SHCT
     D   SavActiveRcd  S                   Like(ActiveRcd)                      ?Save ActiveRcd
     D   X             S              5S 0 Inz(0)                               ?Counter

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         DoW *InLR <> *On;
           Select;
             When Screen = 01;
               Edit01();
             Other;
               *In50 = *On;
               $ERR_PROG = $PGM;
               Today=$MDYDATE($Date(0));
               Today7=$DATE7($Date(0));
               User = $User();
               ActiveRcd = 'A';
               Load01();
               Scrn01();
               *In50 = *Off;
           ENDSL;
         ENDDO;

         *InLR = *On;

      /End-Free


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 01 SubProcedures                                          :
      // :..................................................................:

     P Load01          B
     D Load01          PI
     D  #Truck         S              8A
     D  #TimeStamp     S               Z
     D  #User          S             10A
      /Free

           SFLPOSTO1 = 1;
         RRN01 = 0;
         *In80 = *On;   // Clear Subfile
         Write FPR01201;
         *In26 = *Off;  // Empty Subfile
         *In80 = *Off;
         *In28 = *Off;  // SFLNXTCHG
         RRN01 = 0;
         LastOrder = *Zero;
         SelPOST = ' ';

         SQLState = '00000';
         SelPONO_ = '%' + %Trim(SelPONO) + '%';
         SelNAME_ = '%' + %Trim(SelNAME) + '%';
         SelSHCT_ = '%' + %Trim(SelSHCT) + '%';
         DoW SQLState = '00000';
           Exec SQL
             Select  *
             Into   :RHORDR_DS
             from    FHORDR
             Where   OHORD# in (Select  COORD#
                                from    FHORDRCSTM
                                Where ( COPROJ = 'N' and :ActiveRcd = 'A')
                                   or ( COPROJ = 'Y' and :ActiveRcd = 'Y')
                                   or ( COPROJ = 'I' and :ActiveRcd = 'I')
                                   or ( COPROJ not in ('-', 'Y')
                                                     and :ActiveRcd = 'B'))
               and   OHstat  <>  'D'
               and   OHORD#   >  :LastOrder
               and ( OHORD#   =  :SelORD#  or :SelORD#  = 0   )
               and ( OHCUST   =  :SelCUST  or :SelCUST  = 0   )
               and ( OHDTRQ   =  :SelDTRQ  or :SelDTRQ  = 0   )
               and ( upper(OHPONO) like upper(trim(:SelPONO_))
                     or :SelPONO  = ' ' )
               and ( upper(OHNAME) like upper(trim(:SelNAME_))
                     or :SelNAME  = ' ' )
               and ( upper(OHSHCT) like upper(trim(:SelSHCT_))
                     or :SelSHCT  = ' ' )
             Order by OHORD#
             Fetch First Row Only;
           If SQLState = '00000';
             SetDefault(OHORD#);
             RRN01 += 1;
             *In41 = isEven(RRN01);
              In41 = *In41;
             Write FPR01201S;
             *In26 = *On;
             LastOrder = OHORD#;
           EndIf;
         EndDo;

         Records = RRN01;
         SavActiveRcd = ActiveRcd;
         SavORD#      = SelORD#     ;
         SavCUST      = SelCUST     ;
         SavNAME      = SelNAME     ;
         SavPONO      = SelPONO     ;
         SavDTRQ      = SelDTRQ     ;
         SavSHCT      = SelSHCT     ;

      /End-Free
     P Load01          E

      //_____________________________________________________________________
      //

     P Scrn01          B
     D Scrn01          PI
      /Free
         Screen = 01;
         If SFLPOSTO1 <= *Zero;
           SFLPOSTO1 = 1;
         EndIf;
         write ASSUME;
         write FPR01201F;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt FPR01201;
         If SFLCSRRRN > 0;
           SFLPOSTO1 = SFLCSRRRN;
         EndIf;
         $ClrError();
      /End-Free
     P Scrn01          E

      //_____________________________________________________________________
      //

     P Edit01          B
     D Edit01          PI
      /Free
         Select;
           When *In03;
             *InLR = *On;
           When *In05;                 // Refresh
             Clear SELPOST;
             Clear SELORD#;
             Clear SELCUST;
             Clear SELNAME;
             Clear SELPONO;
             Clear SELDTRQ;
             Clear SELSHCT;
             Load01();
             Scrn01();
           When *In07;                 // Select All
             UpdS01();
             Scrn01();
           When *In08;                 // De-Select All
             UpdS01();
             Scrn01();
           When *In09;                 // Reverse Selection
             UpdS01();
             Scrn01();
    ?      When ( *In22 and CSRFLD = 'OHORD#' )  //Left Mouse Click on Order
             or *In04;                           //Order Details
    ?        Chain SFLCSRRRN FPR01201S;
             OrderInq(OHORD#);
             *In28 = *On;
             *In41 = In41;
    ?        Update FPR01201S;
             *In28 = *Off;
             Scrn01();
    ?      When *In22 = *ON  and                    //Left Mouse Click on Customer# or Name
              ( CSRFLD = 'OHCUST' or
                CSRFLD = 'OHNAME' );
    ?        Chain SFLCSRRRN FPR01201S;
             CustInq(OHCUST);
             *In28 = *On;
             *In41 = In41;
    ?        Update FPR01201S;
             *In28 = *Off;
             Scrn01();
    ?      When *In23 = *ON and SFLCSRRRN <> 0;     //Right Mouse Click (Add Filter)
    ?        Chain SFLCSRRRN FPR01201S;
             Select;
               When    CSRFLD = 'OHORD#';
                      SelOrd#  = OHORD#;
               When    CSRFLD = 'OHCUST';
                      SelCust  = OHCUST;
               When    CSRFLD = 'OHPONO';
                      SelPONO  = OHPONO;
               When    CSRFLD = 'OHNAME';
                      SelName  = OHNAME;
               When    CSRFLD = 'OHDTRQ';
                      SelDTRQ  = OHDTRQ;
               When    CSRFLD = 'OHSHCT';
                      SelSHCT  = OHSHCT;
               Other;
                 // Do Nothing
               EndSl;
             *In28 = *On;
             *In41 = In41;
    ?        Update FPR01201S;
             *In28 = *Off;
             Load01();
             Scrn01();
    ?      When *In23 = *ON and SFLCSRRRN =  0;     //Right Mouse Click (Remove Filter)
             Select;
               When    CSRFLD = 'SELORD#';
                      SelOrd#  = *Zeros;
               When    CSRFLD = 'SELCUST';
                      SelCust  = *Zeros;
               When    CSRFLD = 'SELPONO';
                      SelPONO  = *Blank;
               When    CSRFLD = 'SELNAME';
                      SelName  = *Blank;
               When    CSRFLD = 'SELDTRQ';
                      SelDTRQ  = *Zeros;
               When    CSRFLD = 'SELSHCT';
                      SelSHCT  = *Blank;
               Other;
                 // Do Nothing
               EndSl;
             Load01();
             Scrn01();
    ?      When ActiveRcd <> SavActiveRcd
    ?        or SelORD#   <> SavORD#
    ?        or SelCUST   <> SavCUST
    ?        or SelNAME   <> SavNAME
    ?        or SelPONO   <> SavPONO
    ?        or SelDTRQ   <> SavDTRQ
    ?        or SelSHCT   <> SavSHCT;
             Load01();
             Scrn01();
           Other;         // Process Scan and Subfile
             SflS01();
             Load01();
             Scrn01();
         EndSl;
      /End-Free
     P Edit01          E

      //_____________________________________________________________________
      //

     P UpdS01          B
     D UpdS01          PI
      /Free
        For X = 1 to 9999;
          Chain X FPR01201S;
          If %Found(FPR012FM);
            Select;
              When *In07;
                SELPOST = 'Y';
              When *In08;
                SELPOST = ' ';
              When *In09;
                If SELPOST = ' ';
                  SELPOST = 'Y';
                 Else;
                  SELPOST = ' ';
                EndIf;
            EndSl;
            *In28 = *On;
            *In41 = IN41;
            Update FPR01201S;
            *In28 = *Off;
           Else;
            X = 9999;
          EndIf;
        EndFor;
      /End-Free
     P UpdS01          E

      //_____________________________________________________________________
      //

     P SflS01          B
     D SflS01          PI
      /Free
         If RRN01 > 0;
           Now = $Now();
           ReadC FPR01201S;
           Dow not %EOF(FPR012FM);
             // Edit Subfile Changes
             If SelPost = 'Y';
               CstmProj = 'Proj:'+ %subst(OHNAME:1:19)+ %Char(OHORD#);

               Exec SQL      // Insert into Inventory Transactions
                 INSERT INTO FTINVT
                   ( SELECT 'A'                 as ITSTAT
                     , a.OIITEM                 as ITITEM
                     , a.OISIZE                 as ITSIZE
                     , 1                        as ITTCOM
                     , ' '                      as ITTWSE
                     , ' '                      as ITTLOC
                     , 'P'                      as ITTYPE
                     , 0                        as ITFCOM
                     , ' '                      as ITFWSE
                     , ' '                      as ITFLOC
                     , :Today                   as ITTDAT
                     , :CstmProj                as ITDESC
                     , 'Custom Proj. Upload'    as ITTREF
                     , a.OIQORD - a.OIQSHP      as ITTQTY
                     , 'EA'                     as ITTUOM
                     , 'Y'                      as ITGLUD
                     , 0                        as ITVEND
                     , ' '                      as ITCMRC
                     , 0                        as ITCOST
                     , ' '                      as ITCDFL
                     , :Today                   as ITDTLA
                     , :Now                     as ITTIME
                     , :User                    as ITUSER
                     , ' '                      as ITREPO
                     , ' '                      as ITRBLD
                     , 0                        as ITCOAV
                     , ' '                      as ITVITM
                     , ' '                      as ITCFLG
                     , 0                        as ITGLAC
                     , 0                        as ITUPC
                     , 0                        as ITULC
                     , 0                        as ITUIC
                     , 0                        as ITTRAN
                     , a.OIORD#                 as ITORD#
                     , a.OISEQ#                 as ITSEQ#
                     , ' '                      as ITLOT
                     , ' '                      as ITRSCD
                     , 0                        as ITLBS#
                     , :Today7                  as ITYDAT
                     , 0                        as ITYWGT
                     , 'PRJ'                    as ITREAS
                     FROM FIORDR A, FIORDRCUST B
                     WHERE a.OIORD# = :OHORD#
                       and a.OIORD# = b.OIORD#
                       and a.OISEQ# = b.OISEQ#
                       and a.OIITEM = b.OIITEM
                       and a.OISIZE = b.OISIZE
                       and b.OICSTM = 'Y'
                       and a.OISTAT = 'A'
                       and a.OIITYP = ' ');
               If SQLState = '00000';
                 Exec SQL    // Add to Inventory On-Hand and Available
                   Update FMINVT c
                   Set    c.IMQTOH = c.IMQTOH +
                             (Select  sum(OIQORD-OIQSHP)
                              from    FIORDR a, FIORDRCUST b
                              WHERE   a.OIITEM||a.OISIZE = c.IMITEM||c.IMSIZE
                                and   a.OIORD# = :OHORD#
                                and   a.OIORD# = b.OIORD#
                                and   a.OISEQ# = b.OISEQ#
                                and   a.OIITEM = b.OIITEM
                                and   a.OISIZE = b.OISIZE)
                   ,      c.IMQTAV = c.IMQTAV +
                             (Select  sum(OIQORD-OIQSHP)
                              from    FIORDR a, FIORDRCUST b
                              WHERE   a.OIITEM||a.OISIZE = c.IMITEM||c.IMSIZE
                                and   a.OIORD# = :OHORD#
                                and   a.OIORD# = b.OIORD#
                                and   a.OISEQ# = b.OISEQ#
                                and   a.OIITEM = b.OIITEM
                                and   a.OISIZE = b.OISIZE)
                   ,    c.IMDTLA = :Today
                   ,    c.IMTIME = :Now
                   ,    c.IMUSER = 'FPR012'
                   Where  c.IMITEM||c.IMSIZE in
                          (Select distinct a.OIITEM||b.OISIZE
                             FROM   FIORDR A, FIORDRCUST B
                            WHERE  a.OISTAT = 'A'
                              and  a.OIORD# = b.OIORD#
                              and  a.OISEQ# = b.OISEQ#
                              and  a.OIITEM = b.OIITEM
                              and  a.OISIZE = b.OISIZE
                              and  b.OICSTM = 'Y'
                              and  a.OIITYP = ' '
                              and  a.OIORD# = :OHORD#);
                 If SQLState = '00000';
                   Exec SQL    // Update Record to Mark Order as Projected
          Update FHORDRCSTM Set COPROJ = 'Y' Where COORD# = :OHORD#;
                 EndIf;
               EndIf;
             EndIf;
             If SelPost = 'I';
               Exec SQL      // Mark FHORDRCSTM so record is Ignored.
                 Update FHORDRCSTM Set COPROJ = 'I' where COORD# = :OHORD#;
             EndIf;
             If SelPost = 'A';
               Exec SQL      // Mark FHORDRCSTM so record is Ignored.
                 Update FHORDRCSTM Set COPROJ = 'N' where COORD# = :OHORD#;
             EndIf;
             If SelPost = 'D';
               Exec SQL      // Mark FHORDRCSTM so record is Deleted.
                 Update FHORDRCSTM Set COPROJ = '-' where COORD# = :OHORD#;
             EndIf;
             *In27 = *On;
             *In28 = *On;
             SELPOST = '-';
             Update FPR01201S;
             *In28 = *Off;
             *In27 = *Off;
             ReadC FPR01201S;
           EndDo;
         EndIf;
      /End-Free
     P SflS01          E


      //_____________________________________________________________________
      //
     P isEven          B
     D isEven          PI              N
     D   #number                     10S 0 CONST
     D   #integer      S             10S 0
     D   #decimal      S             15S 5
      /Free

         #decimal = #number / 2;
         #integer = #number / 2;
         if #decimal = #integer;
           Return *On;
          else;
           Return *Off;
         endif;

      /End-Free
     P isEven          E


      //_____________________________________________________________________
      //
     P setDefault      B
     D setDefault      PI
     D   #order#                      6P 0 CONST
     D   order#        S              6S 0
      /Free

         order# = #Order#;

         Exec SQL
           DELETE FROM FIORDRCUST
           WHERE OIORD# = :ORDER#;

         Exec SQL
           INSERT INTO FIORDRCUST
           (SELECT OIORD#
           , OISEQ#
           , OIITEM
           , OISIZE
           , 'Y'
           FROM fiordr
           WHERE oiord# = :ORDER#
           and oiityp = ' '
           and oistat = 'A'
           and OIORD#*1000+OISEQ# not in
           (Select OIORD#*1000+OISEQ# from FIORDRCUST));

           SQLState = '00000';

      /End-Free
     P setDefault      E

      //_____________________________________________________________________
      //

    ?D/COPY QFunctDefn,$ErrMsgSP
