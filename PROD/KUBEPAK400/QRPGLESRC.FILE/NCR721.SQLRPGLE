     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: NCR721.01                                                  :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2014                 ? Kube-Pak Corporation ?    :
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
      *? :  NCR721.01?Original Version                               ?:
      *? :  NCR721.02?Changed Logic on Error Report to use Ord Forms ?:
      *? :  NCR721.03?Incorporated Verification on Trucks            ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  26      ?Sets Position to Indicator                      ?:
      *? :  03      ?Exit                                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FNCR721FM  CF   E             WORKSTN
     F                                     SFILE(NCR72103S:RRN03)

     FFHORDR    IF   E           K DISK                                         ?Order Header
     FFMUPCUPC  IF   E           K DISK                                         ?UPC Master
     FFMINVT    IF   E           K DISK                                         ?Item Master
     FFMORLSEAS IF   E           K DISK                                         ?Seasons
     FFMORLSQ   IF   E           K DISK                                         ?Order List Sequence

     FNPUTSCN   IF   E           K DISK                                         ?Fin Scan
     FNPUTSCNUPCUF A E           K DISK    Rename(RPUTSCN:RPUTSCNUPC)           ?Fin Scan
     FNPUTSCNITMUF   E           K DISK    Rename(RPUTSCN:RPUTSCNITM)           ?Fin Scan

     FNPUTERR   O    E           K DISK                                         ?Fin Errors

      //  Main procedure prototype & interface
     D NCR721          PR                  ExtPgm('NCR721')
     D NCR721          PI

      *? Function Prototypes
     D Load01          PR
     D Scrn01          PR
     D Edit01          PR
     D Load02          PR
     D Scrn02          PR
     D Edit02          PR
     D Load03          PR
     D Scrn03          PR
     D Edit03          PR
     D UpdS03          PR
     D SflS03          PR
     D Load04          PR
     D Scrn04          PR
     D Edit04          PR
     D CrtOrd          PR
     D WriteDetail     PR
     D ValidUPC        PR              N
     D   #UPC                        12P 0 CONST
     D UPCDesc         PR            51A
     D   #UPC                        12P 0 CONST
     D ItemUPC         PR            12P 0
     D   #Item                       12A   CONST
     D   #Size                        3A   CONST
     D CheckVerified   PR                  ExtPgm('NCR605')
     D   #SelDate7                    7S 0 CONST
     D   #SelMast                     2S 0 CONST
     D   #SelOrder                    6S 0 CONST
     D NCR725          PR                  ExtPgm('NCR725')
     D   #TimeStamp                    Z   Const
     D   #Order#                      6S 0 Const
     D SoldOut         PR              N
     D   #Item                       12A   CONST
     D   #Size                        3A   CONST
    ?D/COPY QFunctDefn,$_Dates
    ?D/COPY QFunctDefn,$ErrMsg
    ?D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$isPrinter
    ?D/COPY QFunctDefn,$PrintPick
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$RtvMsgD
     D/COPY QFunctDefn,$isCust
    ?D/COPY QFunctDefn,QCMDEXC

      *? Data Structures
     D                SDS
     D  $PGM             *PROC

      *? Field Definitions
     D   Screen        S              3S 0 Inz(0)                               ?Screen Number
     D   RRN03         S              4S 0 Inz(*Zero)                           ?RRN SFL Scrn 03
     D   Scrn04Over    S              4S 0 Inz(*Zero)                           ?Errors Scrn 04
     D   Scrn04Short   S              4S 0 Inz(*Zero)                           ?Errors Scrn 04
     D   SelDate7      S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   Pink          S              1A   Inz('?')                             ?Color Code -?PINK
     D   White         S              1A   Inz('?')                              Color Code - White
     D   ADRX          S              1S 0 Inz(0)                               ?Address Index
     D   OVRPRTF       S            256A   Inz(' ')                             ?Override PRTF
     D   FirstNewForm  S               N   Inz(*Off)                            ?1st print new form
     D   SQLQSCN       S                   Like(PSCSCN)                         ?SQL Qty Scanned
     D   PCTDONE       S              3S 0                                      ?Order % Complete
     D   Order#        S              6S 0                                      ?Order# to Print
     D   OrdTimeStamp  S               Z                                        ?Order# to Print

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         DoW *InLR <> *On;
           Select;
             When Screen = 01;
               Edit01();
             When Screen = 02;
               Edit02();
             When Screen = 03;
               Edit03();
             When Screen = 04;
               Edit04();
             Other;
               *In26 = *On;
               $ERR_PROG = $PGM;
               SELDATE = $MDYDate($Date(0));
               SELDATE7 = $Date7($DateMDY(SELDATE));
               SELMAST = 98;
               Load01();
               Load02();
               Scrn02();
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

         If PRINTER = ' ';
           Printer = $DftPrt('*NONE':'NCR721':'*PGM');
         EndIf;

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
         exfmt NCR72101;
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
           When *In10;
             PRINTER = $ChgPrt($User():'NCR721':PRINTER);
             Scrn01();
           When *In07 and $isDate#(SELDATE:'*MDY');
             SELDATE = $MDYDate($addDate($DateMDY(SELDATE):-1));
             Scrn01();
           When *In08 and $isDate#(SELDATE:'*MDY');
             SELDATE = $MDYDate($addDate($DateMDY(SELDATE):+1));
             Scrn01();

           When not $isDate#(SELDATE:'*MDY');
             $SndError('DATE901':%EditC(SELDATE:'4'));
             Scrn01();
           When not $isPrinter(PRINTER);
             $SndError('PRT0102':PRINTER);
             Scrn01();
           When PRINTER = *Blanks;
             $SndError('PRT0003':' ');
             Scrn01();
           Other;
             SELDATE7 = $Date7($DateMDY(SELDATE));
             Load02();
             Scrn02();
         EndSl;
      /End-Free
     P Edit01          E

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 2 SubProcedures                                           :
      // :..................................................................:

     P Load02          B
     D Load02          PI
      /Free
         SelCust  = 0;
         SelOrder = 0;
         Cart = 1;
      /End-Free
     P Load02          E

      //_____________________________________________________________________
      //

     P Scrn02          B
     D Scrn02          PI
      /Free
         Screen = 02;
         write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt NCR72102;
         $ClrError();
      /End-Free
     P Scrn02          E

      //_____________________________________________________________________
      //

     P Edit02          B
     D Edit02          PI
      /Free
         Select;
           When *In03;
             *InLR = *On;
           When *In12;
             Scrn01();
           When *In10;
             PRINTER = $ChgPrt($User():'NCR721':PRINTER);
             Scrn02();
           When SelCust > 99999;
             $SndError('CUS0003':' ');
             Scrn02();
           When not $isCust(SelCust);
             $SndError('CUS0002':%char(SelCust));
             Scrn02();
           Other;
             Cart = 0;
             SelOrder = SelCust + 900000;
             Load03();
             Scrn03();
         EndSl;
      /End-Free
     P Edit02          E

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 3 SubProcedures                                           :
      // :..................................................................:

     P Load03          B
     D Load03          PI
     D  #Truck         S              8A
     D  #TimeStamp     S               Z
     D  #User          S             10A
      /Free

         If Cart = 0;
           Cart = 1;
         EndIf;

         If not *In40;   // Lock Quantity
           QTY = 1;
         EndIf;

         QTYSCANNED = *Zero;
         Exec SQL  SELECT  sum(PSCSCN)
                   INTO    :QTYSCANNED
                   FROM    NPUTSCN
                   WHERE   PSORD#=:SelOrder
                     and   PSSHPD=:SelDate7
                     and   PSMSTR=:SelMast;

         PCTDONE = 100;
         Status = White + %Trim(%Char(QtyScanned)) +
                  Pink + 'items scanned on all carts';

         RRN03 = 0;
         *In80 = *On;   // Clear Subfile
         Write NCR72103;
         *In26 = *Off;  // Empty Subfile
         *In80 = *Off;
         RRN03 = 0;
         CARTCOUNT = 0;

         SetLL (SELDATE7:SELMAST:SELORDER:CART) NPUTSCN;
         ReadE (SELDATE7:SELMAST:SELORDER:CART) NPUTSCN;
         DoW not %EOF(NPUTSCN);

             // Calculate Total Scans for this item.
             Exec SQL  SELECT  sum(PSCSCN)
                       INTO    :SQLQSCN
                       FROM    NPUTSCN
                       WHERE   PSORD#=:SelOrder
                         and   PSSHPD=:SelDate7
                         and   PSMSTR=:SelMast
                         and   PSITEM=:PSITEM
                         and   PSSIZE=:PSSIZE;
             SFLITEM5 = %Subst(PSITEM:1:5);
             SFLITEM  = PSITEM;
             SFLSIZE  = PSSIZE;
             SFLUPC   = PSUPC ;
             *In50 = *Off;
             *In51 = *Off;
             If SoldOut(PSITEM:PSSIZE);
               PSDESC  = %Subst('SOLD OUT: ' + PSDESC:1:%Len(PSDESC));
               *In50 = *On;
               *In51 = *On;
             EndIf;
             SFLDESC  = PSDESC;
             SFLQTYDESC = %Trim(%Char(SQLQSCN)) + '-total';
             SFLCARTQTY = PSCSCN;
             CARTCOUNT += PSCSCN;
             If PSUPC <> 0 and PSCSCN <> 0;
               RRN03 += 1;
               *In41 = not isEven(RRN03);
               Write NCR72103S;
               *In26 = *On;  //Non-Empty Subfile
             EndIf;

           ReadE (SELDATE7:SELMAST:SELORDER:CART) NPUTSCN;
         EndDo;


      /End-Free
     P Load03          E

      //_____________________________________________________________________
      //

     P Scrn03          B
     D Scrn03          PI
      /Free
         Screen = 03;
         write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt NCR72103;
         $ClrError();
      /End-Free
     P Scrn03          E

      //_____________________________________________________________________
      //

     P Edit03          B
     D Edit03          PI
      /Free
         Select;
           When *In01;  //Complete Order
             Load04();
             Scrn04();
           When *In02;  //New Order
             Load02();
             Scrn02();
           When *In03;
             *InLR = *On;
           When *In04 and *In40;
             *In40 = *Off;
             Qty = 1;
             Scrn03();
           When *In04 and not *In40;
             *In40 = *On;
             Scrn03();
         //When *In05;
         //  Load05();
         //  Scrn05();
         //When *In06;
         //  Load06();
         //  Scrn06();
           When *In07;
             If Cart > 1;
               Cart -= 1;
              Else;
               Cart  = 99;
             EndIf;
             Load03();
             Scrn03();
           When *In08;
             If Cart < 99;
               Cart += 1;
              Else;
               Cart  = 1;
             EndIf;
             Load03();
             Scrn03();
           When *In09;
             Load01();
             Scrn01();
           When *In10;
             PRINTER = $ChgPrt($User():'NCR721':PRINTER);
             Scrn03();
           When *In23;
             Exec SQL DELETE
                      FROM  NPUTSCN
                      WHERE PSSHPD=:SELDATE7
                        and PSMSTR=:SELMAST
                        and PSORD#=:SELORDER
                        and PSCART=:CART;
             Load03();
             Scrn03();
           When *In24;
             Exec SQL DELETE
                      FROM  NPUTSCN
                      WHERE PSSHPD=:SELDATE7
                        and PSMSTR=:SELMAST
                        and PSORD#=:SELORDER;
             Load03();
             Scrn03();
           When UPC <> 0 and not ValidUPC(UPC);
             $SndError('UPC0001':%EditW(UPC:' -     -     - '));
             Load03();
             Scrn03();
           When UPC = 0;  // Only Process Subfile
             SflS03();
             Load03();
             Scrn03();
           Other;         // Process Scan and Subfile
             UpdS03();
             SflS03();
             Load03();
             Scrn03();
         EndSl;
      /End-Free
     P Edit03          E

      //_____________________________________________________________________
      //

     P UpdS03          B
     D UpdS03          PI
      /Free
        // Write the Scanned info to the file here...
         Chain (UPC) FMUPCUPC;
         Chain (SELDATE7:SELMAST:SELORDER:CART:UPC) NPUTSCNUPC;
         If %Found(NPUTSCNUPC);
           PSCSCN += QTY;
           PSTIME  = $TimeStamp();
           Update RPUTSCNUPC;
          Else;
           PSSHPD  =  SELDATE7;
           PSMSTR  =  SELMAST;
           PSORD#  =  SELORDER;
           PSCART  =  CART;
           PSITEM  =  UPCITEM;
           PSSIZE  =  UPCSIZE;
           PSUPC   =  UPCCODE;
           PSDESC  =  %Trim(%Trim(UPCDES1) + ' ' + %Trim(UPCDES2));
           PSQORD  =  0;
           PSCSCN  =  QTY;
           PSTIME  = $TimeStamp();
           PSUSER  = $USER()  ;
           Write  RPUTSCNUPC;
         EndIf;

      /End-Free
     P UpdS03          E

      //_____________________________________________________________________
      //

     P SflS03          B
     D SflS03          PI
      /Free
         If RRN03 > 0;
           ReadC NCR72103S;
           Dow not %EOF(NCR721FM);
             // Edit Subfile Changes
             Chain (SELDATE7:SELMAST:SELORDER:CART:SFLUPC) NPUTSCNUPC;
             If SFLCARTQTY <> PSCSCN;
               PSCSCN = SFLCARTQTY;
               Update RPUTSCNUPC;
             EndIf;
             ReadC NCR72103S;
           EndDo;
         EndIf;
      /End-Free
     P SflS03          E


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 4 SubProcedures                                           :
      // :..................................................................:

     P Load04          B
     D Load04          PI
      /Free


      /End-Free
     P Load04          E

      //_____________________________________________________________________
      //

     P Scrn04          B
     D Scrn04          PI
      /Free
         Screen = 04;
         write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt NCR72104;
         $ClrError();
      /End-Free
     P Scrn04          E

      //_____________________________________________________________________
      //

     P Edit04          B
     D Edit04          PI
      /Free
         Select;
           When *In03;
             *InLR = *On;
           When *In10;
             PRINTER = $ChgPrt($User():'NCR721':PRINTER);
             Scrn04();
           When *In12;
             Scrn03();
           When *In01;  // Create Error
             CrtOrd();
             *InLR = *On;
           Other;
             Scrn04();
         EndSl;
      /End-Free
     P Edit04          E

      //_____________________________________________________________________
      //

     P CrtOrd          B
     D CrtOrd          PI
      /Free

         OrdTimeStamp = $TimeStamp();
         Exec SQL
           INSERT into ffincrt (
           SELECT  'A'
                ,  :OrdTimeStamp
                ,  PSORD# - 900000
                ,  USER
                ,  PSITEM
                ,  PSSIZE
                ,  PSUPC
                ,  IMLOOK
                ,  PSCSCN
                ,  PSTIME
           FROM    nputscn, fminvt
           where   psitem = imitem
             and   pssize = imsize
             and   psord# = :SelOrder
             and   PSCSCN <> 0          );

         Exec SQL
           Delete From nputscn where psord# = :SelOrder;

         If Printer = *Blanks;
           Printer = 'P6';
         EndIf;
         CallP NCR725(OrdTimeStamp:Order#);
         If Order# <> *Zero;
           $PrintPick(Order#:Printer:'001':'*NO');
         ENDIF;
         $SndError('RBR0007':%Char(Order#));

      /End-Free
     P CrtOrd          E

      //_____________________________________________________________________
      //
     P ValidUPC        B
     D ValidUPC        PI              N
     D   #UPC                        12P 0 CONST
     D #ValidUPC       S               N
      /Free

         Exec SQL
           SELECT '1'
           into :#ValidUPC
           FROM FMUPC
           WHERE UPCCODE = :#UPC
             and UPCSTAT = 'A'
           Fetch First Row Only;

         Return #ValidUPC;

      /End-Free
     P ValidUPC        E
      //_____________________________________________________________________
      //
     P UPCDesc         B
     D UPCDesc         PI            51A
     D   #UPC                        12P 0 CONST
     D #UPCDesc        S             51A
      /Free

         Exec SQL
           SELECT Trim(Trim(UPCDES1)||' '||Trim(UPCDES2))
           into :#UPCDesc
           FROM FMUPC
           WHERE UPCCODE = :#UPC
           Fetch First Row Only;

         Return #UPCDesc;

      /End-Free
     P UPCDesc         E
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
     P ItemUPC         B
     D ItemUPC         PI            12P 0
     D   #Item                       12A   CONST
     D   #Size                        3A   CONST
     D #ItemUPC        S             12P 0
      /Free

         Exec SQL
           SELECT UPCCODE
           into :#ItemUPC
           FROM FMUPC
           WHERE UPCITEM = :#Item
             and UPCSIZE = :#Size
           Fetch First Row Only;

         Return #ItemUPC;

      /End-Free
     P ItemUPC         E
      //_____________________________________________________________________
      //
     P SoldOut         B
     D SoldOut         PI              N
     D   #Item                       12A   CONST
     D   #Size                        3A   CONST
     D #Available      S                   Like(IMQTAV)
      /Free

         Exec SQL
           SELECT IMQTAV
           into :#Available
           FROM FMINVT
           WHERE IMITEM = :#Item
             and IMSIZE = :#Size
           Fetch First Row Only;

         If #Available > 0;
           Return *Off;
          Else;
           Return *On;
         EndIf;

      /End-Free
     P SoldOut         E
      //_____________________________________________________________________
      //

    ?D/COPY QFunctDefn,$ErrMsgSP
