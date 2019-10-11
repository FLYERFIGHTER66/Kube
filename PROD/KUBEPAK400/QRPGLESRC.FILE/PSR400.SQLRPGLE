     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??:         Inventory Needed by Plug Shipping                  :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2014                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? : Scan a flat with this program and it will tell you how    ?:
      *? : many of the given item are called for (remaining balance) ?:
      *? : on the specified P.S. Master.                             ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  26      ?Sets Position to Indicator                      ?:
      *? :  03      ?Exit                                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FPSR400FM  CF   E             WORKSTN

     FFTRAY     IF   E           K DISK                                         ?Tray File

      //  Main procedure prototype & interface
     D PSR400          PR                  ExtPgm('PSR400')
     D PSR400          PI

      *? Function Prototypes
    ?D/COPY QFunctDefn,$_Dates
    ?D/COPY QFunctDefn,$ErrMsg

      *? Arrays
     D   Cmd           S            100A   Dim(0002) CtData                     ?System Commands
     D   Categ         S              4A   Dim(0006) CtData PerRcd(01)          ?Categories

      *? Data Structures
     D                SDS
     D  $PGM             *PROC

      *? Field Definitions
     D   Screen        S              3S 0 Inz(0)                               ?Screen Number
     D   SelDate7      S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   Pink          S              1A   Inz('?')                             ?Color Code -?PINK
     D   White         S              1A   Inz('?')                              Color Code - White
     D   ExcludeRB     S               N   Inz(*Off)                             Exclude RB ?

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         DoW *InLR <> *On;
           Select;
             When Screen = 01;
               Edit01();
             Other;
               *In26 = *On;
               $ERR_PROG = $PGM;
               Exec SQL  SELECT max(PSLOCD) into :SELDATE7 FROM FPLGSCTL;
               SELDATE = $MDYDate($Date(SELDATE7));
               SELMAST = *Zero;
               Scrn01();
               *In26 = *Off;
           ENDSL;
         ENDDO;

         *InLR = *On;

      /End-Free


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 1 SubProcedures                                           :
      // :..................................................................:
     P Load01          B
     D Load01          PI
      /Free

         IMDES1 = 'Item not on Item Master';
         FULLS  = *Zero;
         PARTS  = *Zero;

         Exec SQL
           Select  IMDES1
           into    :IMDES1
           From    FMINVT
           where   IMITEM = :TRITEM
             and   IMSIZE = :TRSIZE;

         If TRSTAT = 'P';
           ITEMSIZE =
             %Trim(TRITEM) +
             Pink + %Trim(TRSTAT) +
             White + '(' + %Trim(TRSIZE) + ')';
          Else;
           ITEMSIZE = %Trim(TRITEM) + ' (' + %Trim(TRSIZE) + ')';
         EndIf;

         Exec SQL
           SELECT sum(PDQORD-PDQSCH)
           into   :FULLS
           FROM   FPUTORD
           WHERE  PDSHPD=:SelDATE7
             and  PDMAST=:SelMAST
             and  PDITEM=:TRITEM
             and  PDSIZE=:TRSIZE
             and ( PDCUST <> 999996 or :ExcludeRB = '0');

         TRITEM = %Subst(TRITEM:1:11) + 'P';

         Exec SQL
           SELECT sum(PDQORD-PDQSCH)
           into   :PARTS
           FROM   FPUTORD
           WHERE  PDSHPD=:SelDATE7
             and  PDMAST=:SelMAST
             and  PDITEM=:TRITEM
             and  PDSIZE=:TRSIZE
             and ( PDCUST <> 999996 or :ExcludeRB= '0' );

         CRDT4 = %Int(%Subst(%Char(TRCRDT):4:4));
         SOWD4 = %Int(%Subst(%Char(TRSCYM):4:4));

      /End-Free
     P Load01          E
      //_____________________________________________________________________
      //
     P Scrn01          B
     D Scrn01          PI
      /Free
         Screen = 01;
         write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt PSR40001;
         $ClrError();
      /End-Free
     P Scrn01          E
      //_____________________________________________________________________
      //
     P Edit01          B
     D Edit01          PI
      /Free

         Chain (SelTag#) FTRAY;

         Select;
           When *In03;
             *InLR = *On;
           When *In06;
             *In36 = not *In36;
             ExcludeRB = *In36;
             Load01();
             Scrn01();
           When not $isDate#(SELDATE:'*MDY');
             $SndError('DATE901':%EditC(SELDATE:'4'));
             Scrn01();
           When SELMAST > MaxMast(SELDATE);
             $SndError('DATE901':%EditC(SELDATE:'4'));
             Scrn01();
           When SELTAG# = *Zero;
             $SndError('TAG0100':' ');
             Scrn01();
           When not %Found(FTRAY);
             IMDES1 = 'Tag not found on Tray File';
             $SndError('TAG0102':%Trim(%char(SelTag#)));
             Scrn01();
           Other;
             SELDATE7 = $Date7($DateMDY(SELDATE));
             Load01();
             Scrn01();
         EndSl;
      /End-Free
     P Edit01          E
      //_____________________________________________________________________
      //
     P MaxMast         B
     D MaxMast         PI             2S 0
     D #SelDate                       6P 0
     D #SelDate7       S              7S 0
     D #MaxMast        S              2S 0
      /Free
         #SelDate7 = $Date7($DateMDY(#SelDate));
         Exec SQL
           SELECT max(PDMAST)
           into :#MaxMast
           FROM fputord
           WHERE PDSHPD = :#SELDATE7;
         Return #MaxMast;
      /End-Free
     P MaxMast         E
      //_____________________________________________________________________
      //
    ?D/COPY QFunctDefn,$ErrMsgSP
