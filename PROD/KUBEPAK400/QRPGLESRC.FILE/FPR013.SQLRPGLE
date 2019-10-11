     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: FPR013.01                                                  :?
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
      *? :  FPR013.01?Original Version                               ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  26      ?Sets Position to Indicator                      ?:
      *? :  03      ?Exit                                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFPR013FM  CF   E             WORKSTN
     F                                     SFILE(FPR01301S:RRN01)


      //  Main procedure prototype & interface
     D FPR013          PR                  ExtPgm('FPR013')
     D  #Order#                       6P 0 CONST
     D FPR013          PI
     D  #Order#                       6P 0 CONST

      *? Function Prototypes
     D Load01          PR
     D Scrn01          PR
     D Edit01          PR
     D OrderInq        PR                  ExtPgm('BIR255CLO')
     D  #Order#                       6P 0 CONST
     D CustInq         PR                  ExtPgm('BIR245CLC')
     D  #Cust#                        6P 0 CONST

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

     D  RIORDR_DS    E DS                  ExtName(FIORDR) Inz
     D  RHORDR_DS    E DS                  ExtName(FHORDR) Inz

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
     D   LastSeq#      S              3S 0                                      ?Order# to Print
     D   OrdTimeStamp  S               Z                                        ?Order# to Print
     D   CstmProj      S             30A                                        ?Order# to Print
     D   User          S             10A                                        ?Order# to Print
     D   SelORD#       S              6S 0                                      ?Order Number
     D   SelDES1_      S             +2    Like(SelDES1)                        ?Desc. Search
     D   SavITEM       S                   Like(SelITEM)                        ?Save DTRQ
     D   SavSIZE       S                   Like(SelSIZE)                        ?Save DTRQ
     D   SavDES1       S                   Like(SelDES1)                        ?Save DTRQ
     D   SavORDT       S                   Like(SelORDT)                        ?Save DTRQ
     D   X             S              5S 0 Inz(0)                               ?Counter

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         SelORD# = #Order#;

         Exec SQL
           Select * into :RHORDR_DS from FHORDR where OHORD# = :SelORD#;

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
         Write FPR01301;
         *In26 = *Off;  // Empty Subfile
         *In80 = *Off;
         *In28 = *Off;  // SFLNXTCHG
         RRN01 = 0;
         LastSeq# = *Zero;
         SelCODE = ' ';

         SQLState = '00000';
         SelDES1_ = '%' + %Trim(SelDES1) + '%';
         DoW SQLState = '00000';
           Exec SQL
             Select  *
             Into   :RIORDR_DS
             from    FIORDR
             Where   OIORD#   =  :SelORD#
               AND   OISTAT  <>   'D'
               and   OISEQ#   >  :LastSeq#
               and ( OIITEM   =  :SelITEM  or :SelITEM  = ' ' )
               and ( OISIZE   =  :SelSIZE  or :SelSIZE  = ' ' )
               and ( OIORDT   =  :SelORDT  or :SelORDT  = 0   )
               and ( upper(OIDES1) like upper(trim(:SELDES1_))
                     or :SelDES1  = ' ' )
             Order by OISEQ#
             Fetch First Row Only;
           If SQLState = '00000';
             RRN01 += 1;
             Notes = *Blanks;
             Exec SQL   // See if item is on Order List
               Select  'Item is on Order List'
               into    :Notes
               from     FMORLS
               Where    OLITEM = :OIITEM
                 and    OLSIZE = :OISIZE
               Fetch First Row Only;
             Exec SQL   // See if item is Marked as Custom
               Select   OICSTM
               into    :SelCODE
               from     FIORDRCUST
               Where    OIORD# = :OIORD#
                 and    OISEQ# = :OISEQ#
                 and    OIITEM = :OIITEM
                 and    OISIZE = :OISIZE
               Fetch First Row Only;
             SQLState = '00000';
             *In41 = isEven(RRN01);
              In41 = *In41;
             *In42 = *Off;
             If OIITYP <> ' ';
               *In42 = *On;
             EndIf;
              In42 = *In42;
             Write FPR01301S;
             *In26 = *On;
             LastSeq# = OISEQ#;
           EndIf;
         EndDo;

         Records = RRN01;

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
         write FPR01301F;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt FPR01301;
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
             Clear SELCODE;
             Clear SELITEM;
             Clear SELSIZE;
             Clear SELDES1;
             Clear SELORDT;
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
    ?      When *In23 = *ON and SFLCSRRRN <> 0;     //Mouse Click (Add Filter)
    ?        Chain SFLCSRRRN FPR01301S;
             Select;
               When    CSRFLD = 'OIITEM';
                      SelITEM  = OIITEM;
               When    CSRFLD = 'OISIZE';
                      SelSIZE  = OISIZE;
               When    CSRFLD = 'OIDES1';
                      SelDES1  = OIDES1;
               When    CSRFLD = 'OIORDT';
                      SelORDT  = OIORDT;
               Other;
                 // Do Nothing
               EndSl;
             *In28 = *On;
             *In41 = In41;
             *In42 = In42;
    ?        Update FPR01301S;
             *In28 = *Off;
             Load01();
             Scrn01();
    ?      When *In23 = *ON and SFLCSRRRN =  0;     //Mouse Click (Remove Filter)
             Select;
               When    CSRFLD = 'SELITEM';
                      SelITEM  = *Blank;
               When    CSRFLD = 'SELSIZE';
                      SelSIZE  = *Blank;
               When    CSRFLD = 'SELDES1';
                      SelDES1  = *Blank;
               When    CSRFLD = 'SELORDT';
                      SelORDT  = *Zeros;
               Other;
                 // Do Nothing
               EndSl;
             Load01();
             Scrn01();
    ?      When SelITEM   <> SavITEM
    ?        or SelSIZE   <> SavSIZE
    ?        or SelDES1   <> SavDES1
    ?        or SelORDT   <> SavORDT;
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
          Chain X FPR01301S;
          If %Found(FPR013FM);
            Select;
              When *In07;
                SELCODE = 'Y';
              When *In08;
                SELCODE = ' ';
              When *In09;
                If SELCODE = ' ';
                  SELCODE = 'Y';
                 Else;
                  SELCODE = ' ';
                EndIf;
            EndSl;
            *In28 = *On;
            *In41 = IN41;
            *In42 = IN42;
            Update FPR01301S;
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
           ReadC FPR01301S;
           Dow not %EOF(FPR013FM);
             // Edit Subfile Changes
             Select;
               When SelCode = 'Y' and IN42 <> '1';
                 Exec SQL
                   INSERT INTO FIORDRCUST
                   VALUES(:OIORD#, :OISEQ#, :OIITEM, :OISIZE, 'Y');
                 Exec SQL
                   Update   FIORDRCUST
                   Set      OICSTM = 'Y'
                   Where    OIORD# = :OIORD#
                     and    OISEQ# = :OISEQ#
                     and    OIITEM = :OIITEM
                     and    OISIZE = :OISIZE;
               When SelCode <> 'Y' and IN42 <> '1';
                 Exec SQL
                   INSERT INTO FIORDRCUST
                   VALUES(:OIORD#, :OISEQ#, :OIITEM, :OISIZE, ' ');
                 Exec SQL
                   Update   FIORDRCUST
                   Set      OICSTM = ' '
                   Where    OIORD# = :OIORD#
                     and    OISEQ# = :OISEQ#
                     and    OIITEM = :OIITEM
                     and    OISIZE = :OISIZE;
             EndSl;
             *In27 = *On;
             *In28 = *On;
             Update FPR01301S;
             *In28 = *Off;
             *In27 = *Off;
             ReadC FPR01301S;
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

    ?D/COPY QFunctDefn,$ErrMsgSP
