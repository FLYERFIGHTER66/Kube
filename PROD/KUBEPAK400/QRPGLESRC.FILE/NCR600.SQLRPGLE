     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: NCR600.03                                                  :?
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
      *? :  NCR600.01?Original Version                               ?:
      *? :  NCR600.02?Changed Logic on Error Report to use Ord Forms ?:
      *? :  NCR600.03?Incorporated Verification on Trucks            ?:
      *? :  NCR600.04?Logic for New Orders                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  26      ?Sets Position to Indicator                      ?:
      *? :  03      ?Exit                                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FNCR600FM  CF   E             WORKSTN
     F                                     SFILE(NCR60003S:RRN03)
     F                                     SFILE(NCR60005S:RRN05)
     F                                     SFILE(NCR60006S:RRN06)

     FNCR600P   O    E             PRINTER USROPN OFLIND(*In27)
     FNCR600PQA O    E             PRINTER USROPN OFLIND(*In28)

     FFHORDR    IF   E           K DISK                                         ?Order Header
     FFMUPCUPC  IF   E           K DISK                                         ?UPC Master
     FFMINVT    IF   E           K DISK                                         ?Item Master
     FFMORLSEAS IF   E           K DISK                                         ?Seasons
     FFMORLSQ   IF   E           K DISK                                         ?Order List Sequence

     FNPUTORDO  IF   E           K DISK                                         ?Fin Orders
     FNPUTORDO@ IF   E           K DISK    Rename(RPUTORD:RPUTORDO@)            ?Fin Orders

     FNPUTSCN   IF   E           K DISK                                         ?Fin Scan
     FNPUTSCNUPCUF A E           K DISK    Rename(RPUTSCN:RPUTSCNUPC)           ?Fin Scan
     FNPUTSCNITMUF   E           K DISK    Rename(RPUTSCN:RPUTSCNITM)           ?Fin Scan

     FNPUTERR   O    E           K DISK                                         ?Fin Errors

      //  Main procedure prototype & interface
     D NCR600          PR                  ExtPgm('NCR600')
     D  #CATEGORY                     4A   CONST
     D NCR600          PI
     D  #CATEGORY                     4A   CONST

      *? Function Prototypes
     D Load01          PR
     D Scrn01          PR
     D Edit01          PR
     D Load02          PR
     D Scrn02          PR
     D Edit02          PR
     D Load02cr        PR
     D Scrn02cr        PR
     D Edit02cr        PR
     D Load03          PR
     D Scrn03          PR
     D Edit03          PR
     D UpdS03          PR
     D SflS03          PR
     D Load04          PR
     D Scrn04          PR
     D Edit04          PR
     D ErrS04          PR
     D WriteDetail     PR
     D CheckUnSch      PR
     D QACS04          PR
     D Load05          PR
     D Scrn05          PR
     D Edit05          PR
     D Load06          PR
     D Scrn06          PR
     D Edit06          PR
     D ExtrasRemoved   PR
     D MaxMast         PR             2S 0
     D #SelDate                       6P 0 CONST
     D ValidUPC        PR              N
     D   #UPC                        12P 0 CONST
     D isFSOrder       PR              N
     D   #Order                       6P 0 CONST
     D   #ShipDate                    7P 0 CONST
     D   #Master                      2P 0 CONST
     D UPCDesc         PR            51A
     D   #UPC                        12P 0 CONST
     D ItemUPC         PR            12P 0
     D   #Item                       12A   CONST
     D   #Size                        3A   CONST
     D SCategory       PR             4A
     D   #Size                        3A   CONST
     D CheckVerified   PR                  ExtPgm('NCR605')
     D   #SelDate7                    7S 0 CONST
     D   #SelMast                     2S 0 CONST
     D   #SelOrder                    6S 0 CONST
    ?D/COPY QFunctDefn,$_Dates
    ?D/COPY QFunctDefn,$ErrMsg
    ?D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$isPrinter
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$RtvMsgD
     D/COPY QFunctDefn,$isOrder
    ?D/COPY QFunctDefn,QCMDEXC

      *? Data Structures
     D                SDS
     D  $PGM             *PROC

     D Addresses       DS
     D  ADR1
     D  ADR2
     D  ADR3
     D  ADR4
     D   ADR                         35A   Dim(0004) OverLay(Addresses)         ?Address

      *? Field Definitions
     D   Screen        S              3S 0 Inz(0)                               ?Screen Number
     D   RRN03         S              4S 0 Inz(*Zero)                           ?RRN SFL Scrn 03
     D   RRN05         S              4S 0 Inz(*Zero)                           ?RRN SFL Scrn 05
     D   RRN06         S              4S 0 Inz(*Zero)                           ?RRN SFL Scrn 06
     D   Scrn04Over    S              4S 0 Inz(*Zero)                           ?Errors Scrn 04
     D   Scrn04Short   S              4S 0 Inz(*Zero)                           ?Errors Scrn 04
     D   SelDate7      S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   Pink          S              1A   Inz('?')                             ?Color Code -?PINK
     D   White         S              1A   Inz('?')                              Color Code - White
     D   ADRX          S              1S 0 Inz(0)                               ?Address Index
     D   OVRPRTF       S            256A   Inz(' ')                             ?Override PRTF
     D   FirstNewForm  S               N   Inz(*Off)                            ?1st print new form
     D   SQLQSCN       S                   Like(PDQSCN)                         ?SQL Qty Scanned
     D   SQLQORD       S                   Like(PDQORD)                         ?SQL Qty Ordered
     D   PCTDONE       S              3S 0                                      ?Order % Complete

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
             When Screen = 22;
               Edit02cr();
             When Screen = 03;
               Edit03();
             When Screen = 04;
               Edit04();
             When Screen = 05;
               Edit05();
             When Screen = 06;
               Edit06();
             Other;
               *In26 = *On;
               $ERR_PROG = $PGM;
               User = $User();
               Exec SQL  SELECT   max(PDSHPD)
                         Into    :SELDATE7 FROM NPUTORD
                         Where    PDMSTR < 99;
               Exec SQL  SELECT max(PDMSTR) into :SELMAST FROM NPUTORD
                           Where PDSHPD = :SELDATE7 and PDMSTR < 99;
               SELDATE = $MDYDate($Date(SELDATE7));
               Load01();
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

         If PRINTER = ' ';
           Printer = $DftPrt('*NONE':'NCR600':'*PGM');
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
         exfmt NCR60001;
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
             PRINTER = $ChgPrt($User():'NCR600':PRINTER);
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
           When SELMAST > MaxMast(SELDATE);
             $SndError('MST0001':%Char(SELMAST));
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
         exfmt NCR60002;
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
           When *In24;
             Scrn02cr();
           When *In10;
             PRINTER = $ChgPrt($User():'NCR600':PRINTER);
             Scrn02();
           When SelOrder = 0;
             $SndError('ORD0001':' ');
             Scrn02();
           When not isFSOrder(SelOrder:SelDate7:SelMast);
             $SndError('ORD0002':%char(SelOrder));
             Scrn02();
           Other;
             Cart = 0;
             Load03();
             Scrn03();
         EndSl;
      /End-Free
     P Edit02          E

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 2cr SubProcedures                                         :
      // :..................................................................:

     P Load02cr        B
     D Load02cr        PI
      /Free
         CLRORD = 0;
      /End-Free
     P Load02cr        E

      //_____________________________________________________________________
      //

     P Scrn02cr        B
     D Scrn02cr        PI
      /Free
         Screen = 22;
         write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt NCR60002cr;
         $ClrError();
      /End-Free
     P Scrn02cr        E

      //_____________________________________________________________________
      //

     P Edit02cr        B
     D Edit02cr        PI
      /Free
         Select;
           When *In24;
             Exec SQL Delete
                      from NPUTSCN
                      Where PSSHPD = :SelDate7
                        and PSMSTR = :SelMast
                        and PSORD# = :CLRORD;
             SelOrder = CLRORD;
             Scrn02();
           When *In12;
             SelOrder = CLRORD;
             Scrn02();
           Other;
             Scrn02cr();
         EndSl;
      /End-Free
     P Edit02cr        E

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 3 SubProcedures                                           :
      // :..................................................................:

     P Load03          B
     D Load03          PI
     D  #Truck         S                   Like(PDLOC)
     D  #TimeStamp     S               Z
     D  #User          S             10A
      /Free

         If Cart = 0;
           Cart = 1;
           Exec SQL
             SELECT min(PDLOC)
             INTO   :#Truck
             FROM   NPUTORD
             WHERE  PDORD# = :SelOrder
               and  PDSHPD = :SelDate7
               and  PDMSTR = :SelMast;
           #Truck = %Trim(#Truck);
           If %Scan('-':#Truck:1) >= 1;
             #Truck = %Subst(#Truck:1:%Scan('-':#Truck:1)-1);
             #TimeStamp = $TimeStamp();
             #User = $User();
             Exec SQL
               UPDATE FTRSCHD
               SET    TRCODC = '-'
                 ,    TRCODT = :#TimeStamp
                 ,    TRCODU = :#User
               WHERE  TRTRK# = :#TRUCK
                 and  TRSHDT = :SelDate7
                 and  TRORD# = :SelOrder
                 and  TRCODC = ' ' ;
           EndIf;
         EndIf;

         If not *In40;   // Lock Quantity
           QTY = 1;
         EndIf;

         OrdQty = *Zero;
         Exec SQL  SELECT  sum(PDQORD)
                   INTO    :OrdQty
                   FROM    NPUTORD, FMSIZC
                   WHERE   PDSIZE=SCSIZE
                     and  (SCCATG=:#Category
                        or :#Category = 'BOTH')
                     and   PDORD#=:SelOrder
                     and   PDSHPD=:SelDate7
                     and   PDMSTR=:SelMast;
         QTYSCANNED = *Zero;
         Exec SQL  SELECT  sum(PSCSCN)
                   INTO    :QTYSCANNED
                   FROM    NPUTSCN, FMSIZC
                   WHERE   PSSIZE=SCSIZE
                     and  (SCCATG=:#Category
                        or :#Category = 'BOTH')
                     and   PSORD#=:SelOrder
                     and   PSSHPD=:SelDate7
                     and   PSMSTR=:SelMast;

         If OrdQty = 0;
           PCTDONE = 100;
          Else;
           PCTDONE = ( QtyScanned / OrdQty ) * 100;
         EndIf;

         Status = White + %Trim(%Char(QtyScanned)) + Pink + 'of' +
                  White + %Trim(%Char(OrdQty))     + Pink + '(' +
                  %Trim(%EditW(PctDone:'   %')) + ') ' +
                  #Category + ' Order Verified!';

         RRN03 = 0;
         *In80 = *On;   // Clear Subfile
         Write NCR60003;
         *In26 = *Off;  // Empty Subfile
         *In80 = *Off;
         RRN03 = 0;
         CARTCOUNT = 0;

         SetLL (SELDATE7:SELMAST:SELORDER:CART) NPUTSCN;
         ReadE (SELDATE7:SELMAST:SELORDER:CART) NPUTSCN;
         DoW not %EOF(NPUTSCN);
           If SCategory(PSSIZE) = #Category or #Category = 'BOTH';
             // Calculate Total Scans for this item.
             Exec SQL  SELECT  sum(PSCSCN)
                       INTO    :PDQSCN
                       FROM    NPUTSCN
                       WHERE   PSORD#=:SelOrder
                         and   PSSHPD=:SelDate7
                         and   PSMSTR=:SelMast
                         and   PSITEM=:PSITEM
                         and   PSSIZE=:PSSIZE;
             // Re-Calculate Total Orders for this item.
             Exec SQL  SELECT  sum(PDQORD)
                       INTO    :PSQORD
                       FROM    NPUTORD, FMSIZC
                       WHERE   PDSIZE=SCSIZE
                         and  (SCCATG=:#Category
                            or :#Category = 'BOTH')
                         and   PDORD#=:SelOrder
                         and   PDSHPD=:SelDate7
                         and   PDMSTR=:SelMast
                         and   PDITEM=:PSITEM
                         and   PDSIZE=:PSSIZE;
             SFLITEM5 = %Subst(PSITEM:1:5);
             SFLITEM  = PSITEM;
             SFLSIZE  = PSSIZE;
             SFLUPC   = PSUPC ;
             SFLDESC  = PSDESC;
             SFLQTYDESC = %Trim(%Char(PDQSCN)) + ' of ' + %Trim(%Char(PSQORD));
             SFLCARTQTY = PSCSCN;
             CARTCOUNT += PSCSCN;
             Select;
               When PDQSCN = PSQORD;
                 *In41 = *On ;
                 *In42 = *Off;
                 *In43 = *Off;
               When PDQSCN < PSQORD;
                 *In41 = *Off;
                 *In42 = *On ;
                 *In43 = *Off;
               When PDQSCN > PSQORD;
                 *In41 = *Off;
                 *In42 = *Off;
                 *In43 = *On ;
             EndSl;
             If PSUPC <> 0 and PSCSCN <> 0;
               RRN03 += 1;
               Write NCR60003S;
               *In26 = *On;  //Non-Empty Subfile
             EndIf;
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
         exfmt NCR60003;
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
           When *In05;
             Load05();
             Scrn05();
           When *In06;
             Load06();
             Scrn06();
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
             PRINTER = $ChgPrt($User():'NCR600':PRINTER);
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
         PDQORD = 0;
         Chain (UPC) FMUPCUPC;
         Chain (SELDATE7:SELMAST:SELORDER:CART:UPC) NPUTSCNUPC;
         Chain (SELDATE7:SELMAST:SELORDER:UPCITEM:UPCSIZE) NPUTORDO;
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
           PSQORD  =  PDQORD;
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
           ReadC NCR60003S;
           Dow not %EOF(NCR600FM);
             // Edit Subfile Changes
             Chain (SELDATE7:SELMAST:SELORDER:CART:SFLUPC) NPUTSCNUPC;
             If SFLCARTQTY <> PSCSCN;
               PSCSCN = SFLCARTQTY;
               Update RPUTSCNUPC;
             EndIf;
             ReadC NCR60003S;
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

         Scrn04Short  = 0;
         Scrn04Over   = 0;

         SetLL (SELDATE7:SELMAST:SELORDER) NPUTORDO@;
         ReadE (SELDATE7:SELMAST:SELORDER) NPUTORDO@;
         DoW not %EOF(NPUTORDO@);
           Exec SQL  SELECT  sum(PSCSCN)   //Get Scans from all Carts
                     INTO    :PDQSCN
                     FROM    NPUTSCN
                     WHERE   PSORD#=:SelOrder
                       and   PSSHPD=:SelDate7
                       and   PSMSTR=:SelMast
                       and   PSITEM=:PDITEM
                       and   PSSIZE=:PDSIZE;
           Exec SQL  SELECT  sum(PDQORD)   // Get Item Total from all lines on Order
                     INTO    :PDQORD
                     FROM    NPUTORD
                     WHERE   PDORD#=:SelOrder
                       and   PDSHPD=:SelDate7
                       and   PDMSTR=:SelMast
                       and   PDITEM=:PDITEM
                       and   PDSIZE=:PDSIZE;
           If SCategory(PDSIZE) = #Category or #Category = 'BOTH';
             If PDQSCN < PDQORD;
               Scrn04Short += 1;
             EndIf;
             If PDQSCN > PDQORD;
               Scrn04Over  += 1;
             EndIf;
           EndIf;
           SetGT (SELDATE7:SELMAST:SELORDER:PDLOOK:PDITEM:PDSIZE) NPUTORDO@;
           ReadE (SELDATE7:SELMAST:SELORDER) NPUTORDO@;
         EndDo;
         SetLL (SELDATE7:SELMAST:SELORDER) NPUTSCN;
         ReadE (SELDATE7:SELMAST:SELORDER) NPUTSCN;
         DoW not %EOF(NPUTSCN);
           If SCategory(PSSIZE) = #Category or #Category = 'BOTH';
             Chain (SELDATE7:SELMAST:SELORDER:PSITEM:PSSIZE) NPUTORDO;
             If PSCSCN>0 and not %Found(NPUTORDO);
               Scrn04Over  += 1;
             EndIf;
           EndIf;
           ReadE (SELDATE7:SELMAST:SELORDER) NPUTSCN;
         EndDo;

        If Scrn04Short = 0 and Scrn04Over = 0;
          *In44 = *On;
         Else;
          *In44 = *Off;
        Endif;

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
         exfmt NCR60004;
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
             PRINTER = $ChgPrt($User():'NCR600':PRINTER);
             Scrn04();
           When *In12 and not *In44;
             Scrn03();
           When *In01 and not *In44 and not isCustom(SELORDER);  // Order Error
             ErrS04(); // Print Error Report
             Load02();
             Scrn02();
           When *In01 and not *In44 and isCustom(SELORDER);  // Order Error
             ErrS04_cust(); // Print Error Report for Custom Orders
             Load02();
             Scrn02();
           When *In01 and *In44;  // Order Verified
             // Update FTRSCHD
             QACS04(); // Print QA Report
             Load02();
             Scrn02();
           Other;
             Load01();
             Scrn01();
         EndSl;
      /End-Free
     P Edit04          E

      //_____________________________________________________________________
      //

     P ErrS04          B
     D ErrS04          PI
      /Free
         // Open Printer File
         If not %Open(NCR600P);
           If PRINTER <> *Blanks;
             OVRPRTF = 'OVRPRTF FILE(NCR600P)' +
                              ' FORMTYPE(*NAR)' +
                              ' OUTQ(' + %Trim(Printer) + ') ' +
                              ' OPNSCOPE(*JOB)';
             QCmdExc(OVRPRTF : %len(%trim(OVRPRTF)));
           EndIf;
           Open NCR600P;
           *In27 = *Off; // Overflow
         EndIf;

         //  Get Order Header Information
         ORDER = %Char(SELORDER);
         Chain (SELORDER) FHORDR;
         ADRX = 0;
         If OHSHP2 <> *Blanks;
           ADRX += 1;
           ADR(ADRX) = OHSHP2;
         EndIf;
         If OHSHP3 <> *Blanks;
           ADRX += 1;
           ADR(ADRX) = OHSHP3;
         EndIf;
         If OHSHP4 <> *Blanks;
           ADRX += 1;
           ADR(ADRX) = OHSHP4;
         EndIf;
         ADRX += 1;
         ADR(ADRX) = %Trim(OHSHCT) + ', ' + OHSHST + ' ' + OHSHZP;
         Write HEADER;

         //  Clear Previous Errors for this Order and populate fields for new errors
         EXEC SQL  DELETE
                   FROM  NPUTERR
                   WHERE PESHPD = :SELDATE7
                     and PEMSTR = :SELMAST
                     and PEORD# = :SELORDER;
         PESHPD = SELDATE7;
         PEMSTR = SELMAST;
         PEORD# = SELORDER;
         PETIME = $TimeStamp();
         PEUSER = $User();

         //  Process Item Details - First Get Items on Order Forms
         SetLL *LoVal FMORLSEAS;
         Read FMORLSEAS;
         DoW not %EOF(FMORLSEAS);
           FirstNewForm = *On;
           Exec SQL
             SELECT HLDESC Into :FormDesc FROM FMORLH WHERE HLLIST = :HSLIST;
           SetLL (HSLIST) FMORLSQ;
           ReadE (HSLIST) FMORLSQ;
           DoW not %EOF(FMORLSQ);
             If not isHidden(OLLIST:OLITEM:OLSIZE) and
               (SCategory(OLSIZE)=#Category or #Category = 'BOTH');
               SQLQSCN = 0;
               SQLQORD = 0;
               Exec SQL  SELECT  sum(PSCSCN)   //Get Scans from all Carts
                         INTO    :SQLQSCN
                         FROM    NPUTSCN
                         WHERE   PSORD#=:SelOrder
                           and   PSSHPD=:SelDate7
                           and   PSMSTR=:SelMast
                           and   PSITEM=:OLITEM
                           and   PSSIZE=:OLSIZE;
               Exec SQL  SELECT  sum(PDQORD)   // Get Item Total from all lines on Order
                         INTO    :SQLQORD
                         FROM    NPUTORD
                         WHERE   PDORD#=:SelOrder
                           and   PDSHPD=:SelDate7
                           and   PDMSTR=:SelMast
                           and   PDITEM=:OLITEM
                           and   PDSIZE=:OLSIZE;
               If SQLQSCN <> SQLQORD;
                 RPTITEM5 = %Subst(OLITEM:1:5);
                 RPTSIZE  = OLSIZE;
                 RPTQTYDESC = %Trim(%Char(%Int(SQLQSCN))) + '/' +
                              %Trim(%Char(%Int(SQLQORD)));
                 RPTDESC  = UPCDesc(ItemUPC(OLITEM:OLSIZE));
                 If SQLQSCN > SQLQORD;
                   OVERSHORT  =
                     'Over  ' + %Trim(%EditC(%Int(SQLQSCN-SQLQORD):'4'));
                   PEOVER     = SQLQSCN-SQLQORD;
                   PESHRT     = 0;
                  Else;
                   OVERSHORT  =
                     'Short ' + %Trim(%EditC(%Int(SQLQSCN-SQLQORD):'4'));
                   PEOVER     = 0;
                   PESHRT     = SQLQORD-SQLQSCN;
                 EndIf;
                 WriteDetail();
               EndIf;
             EndIf;
             ReadE (HSLIST) FMORLSQ;
           EndDo;
           Read FMORLSEAS;
         EndDo;

         CheckUnSch(); // Check for Unscheduled Items
         Write BOXES;

         If %Open(NCR600P);
           Close NCR600P;
         EndIf;

      /End-Free
     P ErrS04          E

      //_____________________________________________________________________
      //

     P ErrS04_Cust     B
     D ErrS04_Cust     PI
      /Free
         dcl-s LastPDSEQ# like(PDSEQ#);
         dcl-ds err_ds;
           errPDSEQ# packed(3:0);
           errPDITEM char(12);
           errPDSIZE char(3);
           errPDQORD packed(11:1);
           errPSCSCN packed(11:1);
         END-DS;

         // Open Printer File
         If not %Open(NCR600P);
           If PRINTER <> *Blanks;
             OVRPRTF = 'OVRPRTF FILE(NCR600P)' +
                              ' FORMTYPE(*NAR)' +
                              ' OUTQ(' + %Trim(Printer) + ') ' +
                              ' OPNSCOPE(*JOB)';
             QCmdExc(OVRPRTF : %len(%trim(OVRPRTF)));
           EndIf;
           Open NCR600P;
           *In27 = *Off; // Overflow
         EndIf;

         //  Get Order Header Information
         ORDER = %Char(SELORDER);
         Chain (SELORDER) FHORDR;
         ADRX = 0;
         If OHSHP2 <> *Blanks;
           ADRX += 1;
           ADR(ADRX) = OHSHP2;
         EndIf;
         If OHSHP3 <> *Blanks;
           ADRX += 1;
           ADR(ADRX) = OHSHP3;
         EndIf;
         If OHSHP4 <> *Blanks;
           ADRX += 1;
           ADR(ADRX) = OHSHP4;
         EndIf;
         ADRX += 1;
         ADR(ADRX) = %Trim(OHSHCT) + ', ' + OHSHST + ' ' + OHSHZP;
         Write HEADER;

         //  Clear Previous Errors for this Order and populate fields for new errors
         EXEC SQL  DELETE
                   FROM  NPUTERR
                   WHERE PESHPD = :SELDATE7
                     and PEMSTR = :SELMAST
                     and PEORD# = :SELORDER;
         PESHPD = SELDATE7;
         PEMSTR = SELMAST;
         PEORD# = SELORDER;
         PETIME = $TimeStamp();
         PEUSER = $User();

         //  Process Item Details - First Get Items on Order Forms
         Eval SQLState = '00000';
         DoW SQLState = '00000';
           Exec SQL
             select  PDSEQ#,
                     PDITEM,
                     PDSIZE,
                     cast ( avg(coalesce(PDQORD,0)) as dec(11,1)),
                     cast ( sum(coalesce(PSCSCN,0)) as dec(11,1))
             into   :err_ds
             from            nputord
             left outer join nputscn
                     on PDORD# = PSORD#
                    and PDMSTR = PSMSTR
                    and PDSHPD = PSSHPD
                    and PDITEM = PSITEM
                    and PDSIZE = PSSIZE
             Where PDSHPD = :SELDATE7
               and PDMSTR = :SELMAST
               and PDORD# = :SELORDER
               and PDSEQ# > :LastPDSEQ#
             Group by PDSHPD, PDMSTR, PDORD#, PDSEQ#, PDITEM, PDSIZE
             Order by PDSHPD, PDMSTR, PDORD#, PDSEQ#, PDITEM, PDSIZE
             Fetch First Row Only;

             LastPDSEQ# = errPDSEQ#;

           If  errPDQORD <> errPSCSCN and SQLState = '00000';
             RPTITEM5 = %Subst(errPDITEM:1:5);
             RPTSIZE  = errPDSIZE;
             RPTQTYDESC = %Trim(%Char(%Int(errPSCSCN))) + '/' +
                          %Trim(%Char(%Int(errPDQORD)));
             RPTDESC  = UPCDesc(ItemUPC(errPDITEM:errPDSIZE));
             If errPSCSCN > errPDQORD;
               OVERSHORT  =
                 'Over  ' + %Trim(%EditC(%Int(errPSCSCN-errPDQORD):'4'));
               PEOVER     = errPSCSCN-errPDQORD;
               PESHRT     = 0;
              Else;
               OVERSHORT  =
                 'Short ' + %Trim(%EditC(%Int(errPSCSCN-errPDQORD):'4'));
               PEOVER     = 0;
               PESHRT     = errPDQORD-errPSCSCN;
             EndIf;
             WriteDetail();
             SQLState = '00000';
           ENDIF;

         ENDDO;

         Write BOXES;

         If %Open(NCR600P);
           Close NCR600P;
         EndIf;

      /End-Free
     P ErrS04_Cust     E

      //_____________________________________________________________________
      //

     P WriteDetail     B
     D WriteDetail     PI
      /Free

         If *In27; // OVERFLOW
           Write HEADER;
           Write NEWFORM;
           *In27 = *Off;
         EndIf;
         If FirstNewForm;
           Write NEWFORM;
           FirstNewForm = *Off;
         EndIf;
         Write DETAIL;
         PEITEM = RptItem5;
         PESIZE = RptSIZE;
         PEUPC  = ItemUPC(PEITEM:PESIZE);
         Chain (PEITEM:PESIZE) FMINVT;
         PELOOK = IMLOOK;
         PEDESC = RPTDESC;
         PELOC  = PDLOC ;
         EXEC SQL  DELETE
                   FROM  NPUTERR
                   WHERE PESHPD = :PESHPD
                     and PEMSTR = :PEMSTR
                     and PEUPC  = :PEUPC
                     and PEORD# = :PEORD#  ;
         Write RPUTERR;

      /End-Free
     P WriteDetail     E

      //_____________________________________________________________________
      //

     P CheckUnSch      B
     D CheckUnSch      PI
      /Free
         FormDesc = 'OTHER ITEMS';
         SetLL (SELDATE7:SELMAST:SELORDER) NPUTSCNITM;
         ReadE (SELDATE7:SELMAST:SELORDER) NPUTSCNITM;
         DoW not %EOF(NPUTSCNITM);
           If SCategory(PSSIZE) = #Category or #Category = 'BOTH';
             Chain (SELDATE7:SELMAST:SELORDER:PSITEM:PSSIZE) NPUTORDO;
             If not OrderListItem(PSITEM:PSSIZE);
               If PSCSCN>0 and not %Found(NPUTORDO);
                 Exec SQL  Select sum(PSCSCN)
                           Into   :PSCSCN
                           From   NPUTSCN
                           Where  PSSHPD = :PSSHPD
                             and  PSMSTR = :PSMSTR
                             and  PSORD# = :PSORD#
                             and  PSITEM = :PSITEM
                             and  PSSIZE = :PSSIZE;
                 RPTITEM5 = %Subst(PSITEM:1:5);
                 RPTSIZE  = PSSIZE;
                 OVERSHORT  = 'Over  ' + %Trim(%EditC(%Int(PSCSCN):'4'));
                 RPTQTYDESC = %Trim(%EditC(%Int(PSCSCN):'4')) + '/0';
                 PEOVER     = PSCSCN;
                 PESHRT     = 0;
                 RPTDESC  = %Trim(UPCDesc(ItemUPC(PSITEM:PSSIZE))+'+++');
                 WriteDetail();
               EndIf;
             EndIf;
           EndIf;
           SetGT (PSSHPD:PSMSTR:PSORD#:PSSIZE:PSITEM) NPUTSCNITM;
           ReadE (SELDATE7:SELMAST:SELORDER) NPUTSCNITM;
         EndDo;
      /End-Free
     P CheckUnSch      E

      //_____________________________________________________________________
      //

     P QACS04          B
     D QACS04          PI
     D Lines           S              2S 0                                      Constant Avail Lines
     D Season          S              2S 0                                      Spring = 1
     D NbrForms        S              3S 0                                      # Forms in Season
     D LinesPerForm    S              2S 0                                      Each form gets lines
     D SQLState        S              5A                                        SQL State Code
     D LastHLDESC      S             30A                                        Last HLDESC
      /Free
         EXEC SQL  DELETE
                   FROM  NPUTERR
                   WHERE PESHPD = :SELDATE7
                     and PEMSTR = :SELMAST
                     and PEORD# = :SELORDER;
         If not %Open(NCR600PQA);
           If PRINTER <> *Blanks;
             OVRPRTF = 'OVRPRTF FILE(NCR600PQA)' +
                              ' FORMTYPE(*NAR)' +
                              ' OUTQ(' + %Trim(Printer) + ') ' +
                              ' OPNSCOPE(*JOB)';
             QCmdExc(OVRPRTF : %len(%trim(OVRPRTF)));
           EndIf;
           Open NCR600PQA;
           *In28 = *Off; // Overflow
         EndIf;
         ORDER = %Char(SELORDER);
         Chain (SELORDER) FHORDR;
         PDLOC = %TRIM(PDLOC);
         ADRX = 0;
         If OHSHP2 <> *Blanks;
           ADRX += 1;
           ADR(ADRX) = OHSHP2;
         EndIf;
         If OHSHP3 <> *Blanks;
           ADRX += 1;
           ADR(ADRX) = OHSHP3;
         EndIf;
         If OHSHP4 <> *Blanks;
           ADRX += 1;
           ADR(ADRX) = OHSHP4;
         EndIf;
         ADRX += 1;
         ADR(ADRX) = %Trim(OHSHCT) + ', ' + OHSHST + ' ' + OHSHZP;
         Write QAHEADER;
         Lines = 45;
         Season = 1;
         Exec SQL  SELECT count(*)
                   Into   :NbrForms
                   FROM   FMORLSEASL, FMORLH
                   WHERE  HSSNCD = 1
                     and  HSLIST=HLLIST;
         LinesPerForm = %Int( Lines / NbrForms );
         Select;
           When LinesPerForm < 2;
            //Set Some Indicator
         EndSl;

         If *In28;
           Write HEADER;
           *In28 = *Off;
         EndIf;
         LastHLDESC = *Blanks;
         SQLState   = '00000';
         HLDESC     = 'First';
         If isCustom(SELORDER);
           HLDESC = 'C U S T O M   O R D E R';
           Write QADETAIL  ;
          ELSE;
         DoW SQLState = '00000' and HLDESC <> *Blanks;
           HLDESC = *Blanks;
           Exec SQL  SELECT   distinct FMORLH.HLDESC
                     Into     :HLDESC
                     FROM     FMORLH, FMORLSj1 as FMORLS, FIORDR, FMSIZC
                     WHERE    FMORLH.HLLIST = FMORLS.OLLIST
                       and    FMORLS.OLITEM = FIORDR.OIITEM
                       and    FMORLS.OLSIZE = FIORDR.OISIZE
                       and    FMORLS.OLSIZE = FMSIZC.SCSIZE
                       and   (FMSIZC.SCCATG = :#Category
                          or :#Category = 'BOTH')
                       and    FIORDR.OIORD# = :SelOrder
                       and    FMORLH.HLDESC > :LastHLDESC
                     ORDER BY FMORLH.HLDESC
                     Fetch First Row Only ;
           If SQLState = '00000' and HLDESC <> *Blanks;
             Write QADETAIL  ;
           EndIf;
           LastHLDESC = HLDESC;
         EndDo;
         ENDIF;
         Write QALINE;
         If %Open(NCR600PQA);
           Close NCR600PQA;
         EndIf;
         CheckVerified(SelDate7:SelMast:SelOrder);
      /End-Free
     P QACS04          E





      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 5 SubProcedures                                           :
      // :..................................................................:

     P Load05          B
     D Load05          PI
      /Free

         RRN05 = 0;
         *In80 = *On;   // Clear Subfile
         Write NCR60005;
         *In26 = *Off;  // Empty Subfile
         *In80 = *Off;
         RRN05 = 0;

         SetLL (SELDATE7:SELMAST:SELORDER) NPUTORDO@;
         ReadE (SELDATE7:SELMAST:SELORDER) NPUTORDO@;
         DoW not %EOF(NPUTORDO@);
           PDQSCN = 0;
           PDQORD = 0;
           Exec SQL  SELECT  sum(PSCSCN)   //Get Scans from all Carts
                     INTO    :PDQSCN
                     FROM    NPUTSCN
                     WHERE   PSORD#=:SelOrder
                       and   PSSHPD=:SelDate7
                       and   PSMSTR=:SelMast
                       and   PSITEM=:PDITEM
                       and   PSSIZE=:PDSIZE;
           Exec SQL  SELECT  sum(PDQORD)   // Get Item Total from all lines on Order
                     INTO    :PDQORD
                     FROM    NPUTORD
                     WHERE   PDORD#=:SelOrder
                       and   PDSHPD=:SelDate7
                       and   PDMSTR=:SelMast
                       and   PDITEM=:PDITEM
                       and   PDSIZE=:PDSIZE;
           If PDQSCN < PDQORD and
             (SCategory(PDSIZE)=#Category or #Category = 'BOTH');
             SFLITEM5 = %Subst(PDITEM:1:5);
             SFLITEM  = PDITEM;
             SFLSIZE  = PDSIZE;
             SFLDESC  = UPCDesc(ItemUPC(PDITEM:PDSIZE));
             SFLSHORTBY = 'Scan: ' + %Trim(%Char(%Int(PDQSCN))) + ' of ' +
                                        %Trim(%Char(%Int(PDQORD))) + White +
                          '=> ' + %Trim(%Char(%Int(PDQORD-PDQSCN))) +' Short.';
             RRN05 += 1;
             Write NCR60005S;
             *In26 = *On;  //Non-Empty Subfile
           EndIf;
           SetGT (SELDATE7:SELMAST:SELORDER:PDLOOK:PDITEM:PDSIZE) NPUTORDO@;
           ReadE (SELDATE7:SELMAST:SELORDER) NPUTORDO@;
         EndDo;


      /End-Free
     P Load05          E

      //_____________________________________________________________________
      //

     P Scrn05          B
     D Scrn05          PI
      /Free
         Screen = 05;
         write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt NCR60005;
         $ClrError();
      /End-Free
     P Scrn05          E

      //_____________________________________________________________________
      //

     P Edit05          B
     D Edit05          PI
      /Free
         Select;
           When *In01;  //Return to Order
             Load03();
             Scrn03();
           When *In04;  //Fix Shorts (Cart 99)
             Cart = 99;
             Load03();
             Scrn03();
           When *In06;  //View Extras
             Load06();
             Scrn06();
           When *In03;
             *InLR = *On;
           When *In10;
             PRINTER = $ChgPrt($User():'NCR600':PRINTER);
             Scrn03();
           Other;         // Process Scan and Subfile
             Load05();
             Scrn05();
         EndSl;
      /End-Free
     P Edit05          E


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 6 SubProcedures                                           :
      // :..................................................................:

     P Load06          B
     D Load06          PI
      /Free

         RRN06 = 0;
         *In80 = *On;   // Clear Subfile
         Write NCR60006;
         *In26 = *Off;  // Empty Subfile
         *In80 = *Off;
         RRN06 = 0;

         SetLL (SELDATE7:SELMAST:SELORDER) NPUTORDO@;
         ReadE (SELDATE7:SELMAST:SELORDER) NPUTORDO@;
         DoW not %EOF(NPUTORDO@);
           Exec SQL  SELECT  sum(PSCSCN)   //Get Scans from all Carts
                     INTO    :PDQSCN
                     FROM    NPUTSCN
                     WHERE   PSORD#=:SelOrder
                       and   PSSHPD=:SelDate7
                       and   PSMSTR=:SelMast
                       and   PSITEM=:PDITEM
                       and   PSSIZE=:PDSIZE;
           Exec SQL  SELECT  sum(PDQORD)   // Get Item Total from all lines on Order
                     INTO    :PDQORD
                     FROM    NPUTORD
                     WHERE   PDORD#=:SelOrder
                       and   PDSHPD=:SelDate7
                       and   PDMSTR=:SelMast
                       and   PDITEM=:PDITEM
                       and   PDSIZE=:PDSIZE;
           If PDQSCN > PDQORD and
             (SCategory(PDSIZE)=#Category or #Category = 'BOTH');
             SFLOVER  = PDQSCN - PDQORD;
             SFLITEM5 = %Subst(PDITEM:1:5);
             SFLITEM  = PDITEM;
             SFLSIZE  = PDSIZE;
             SFLDESC  = UPCDesc(ItemUPC(PDITEM:PDSIZE));
             SFLOVERBY = 'Scan: ' + %Trim(%Char(%Int(PDQSCN))) + ' of ' +
                                        %Trim(%Char(%Int(PDQORD))) + White +
                          '=> ' + %Trim(%Char(%Int(PDQORD-PDQSCN))) +' Over.';
             RRN06 += 1;
             Write NCR60006S;
             *In26 = *On;  //Non-Empty Subfile
           EndIf;
           SetGT (SELDATE7:SELMAST:SELORDER:PDLOOK:PDITEM:PDSIZE) NPUTORDO@;
           ReadE (SELDATE7:SELMAST:SELORDER) NPUTORDO@;
         EndDo;

      /End-Free
     P Load06          E

      //_____________________________________________________________________
      //

     P Scrn06          B
     D Scrn06          PI
      /Free
         Screen = 06;
         write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt NCR60006;
         $ClrError();
      /End-Free
     P Scrn06          E

      //_____________________________________________________________________
      //

     P Edit06          B
     D Edit06          PI
      /Free
         Select;
           When *In01;  //Return to Order
             Load03();
             Scrn03();
           When *In05;  //View Missing
             Load05();
             Scrn05();
           When *In03;
             *InLR = *On;
           When *In10;
             PRINTER = $ChgPrt($User():'NCR600':PRINTER);
             Scrn03();
           When *In18;
             ExtrasRemoved();
             Load06();
             Scrn06();
           Other;         // Process Scan and Subfile
             Load06();
             Scrn06();
         EndSl;
      /End-Free
     P Edit06          E

      //_____________________________________________________________________
      //
     P ExtrasRemoved   B
     D ExtrasRemoved   PI
     D Qty2Remove      S             11S 1
     D X               S              4S 0
     D LongDesc        S             58A
      /Free

         For X = 1 to RRN06;
           Chain(E) X NCR60006;
           PSSHPD  = SelDate7;
           PSMSTR  = SelMast;
           PSORD#  = 999999;
           PSCART  =  0;
           PSQORD  =  0;
           PSTIME  = $TimeStamp();
           PSUSER  = $User();
           PSITEM  = SFLITEM;
           PSSIZE  = SFLSIZE;
           PSUPC   = ItemUPC(SFLITEM:SFLSIZE);
           LongDesc =
            %Trim((%Trim(PDLOC) +':'+%Char(SelOrder) + ': ' + %Trim(SFLDESC)));
           PSDESC  = %Subst(LongDesc:1:51);
           PSCSCN  = SFLOver;
           Write RPUTSCNUPC;
           Qty2Remove = SFLOver;
           // Remove from Last Cart backwards
           SetGT  (SelDate7:SelMast:SelOrder:SFLSIZE:SFLITEM) NPUTSCNITM;
           ReadPe (SelDate7:SelMast:SelOrder:SFLSIZE:SFLITEM) NPUTSCNITM;
           DoW Qty2Remove > 0 and not %EOF(NPUTSCNITM);
             If PSCSCN >= Qty2Remove;
                PSCSCN -= Qty2Remove;
                Qty2Remove = 0;
              Else;
                PSCSCN      = 0;
                Qty2Remove -= PSCSCN;
             EndIf;
             Update RPUTSCNITM;
             ReadPe (SelDate7:SelMast:SelOrder:SFLSIZE:SFLITEM) NPUTSCNITM;
           EndDo;
         EndFor;
         Exec SQL  DELETE
                   FROM  NPUTERR
                   WHERE PESHPD = :SelDate7
                   and   PEMSTR = :SelMast
                   and   PEORD# = :SelOrder
                   and   PEOVER > 0;
      /End-Free
     P ExtrasRemoved   E

      //_____________________________________________________________________
      //
     P MaxMast         B
     D MaxMast         PI             2S 0
     D #SelDate                       6P 0 CONST
     D #SelDate7       S              7S 0
     D #MaxMast        S              2S 0
      /Free
         #SelDate7 = $Date7($DateMDY(#SelDate));
         Exec SQL
           SELECT max(PDMSTR)
           into :#MaxMast
           FROM nputord
           WHERE PDSHPD = :#SELDATE7;
         Return #MaxMast;
      /End-Free
     P MaxMast         E
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
      /Free
       dcl-proc isHidden;
         dcl-pi *n ind;
           OLLIST   char(6)  const;
           OLITEM   char(12) const;
           OLSIZE   char(3)  const;
         END-PI;

         dcl-s hidden ind;

         hidden = *off;

         Exec SQL
           Select  '1' into :hidden
           from    FMORLSFLAG
           where   FLLIST = :OLLIST
             and   FLITEM = :OLITEM
             and   FLSIZE = :OLSIZE
             and   FLHIDE in ('1', 'Y');

       return hidden;

       end-proc;
      /End-Free

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
     P isFSOrder       B
     D isFSOrder       PI              N
     D   #Order                       6P 0 CONST
     D   #ShipDate                    7P 0 CONST
     D   #Master                      2P 0 CONST
     D #ValidFSOrder   S               N
      /Free

         Exec SQL
           SELECT '1'
           into :#ValidFSOrder
           FROM  NPUTORD
           WHERE PDORD# = :#Order
             and PDSHPD = :#ShipDate
             and PDMSTR = :#Master
           Fetch First Row Only;

         Return #ValidFSOrder;

      /End-Free
     P isFSOrder       E
      //_____________________________________________________________________
      //
     P OrderListItem   B
     D OrderListItem   PI              N
     D   #Item                       12A   CONST
     D   #Size                        3A   CONST
     D #OrderListItem  S               N
      /Free

         Exec SQL
           SELECT '1'
           into  :#OrderListItem
           FROM   FMORLSj1 as FMORLS, FMORLSEAS
           WHERE  FMORLS.OLLIST = FMORLSEAS.HSLIST
             and  FMORLS.OLITEM = :#Item
             and  FMORLS.OLSIZE = :#Size
           Fetch  First Row Only;

         Return #OrderListItem;

      /End-Free
     P OrderListItem   E
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
     P SCategory       B
     D SCategory       PI             4A
     D   #Size                        3A   CONST
     D #SCategory      S              4A
      /Free

         Exec SQL
           SELECT SCCATG
           into :#SCategory
           FROM FMSIZC
           WHERE SCSIZE = :#Size
           Fetch First Row Only;

         Return #SCategory;

      /End-Free
     P SCategory       E
      //_____________________________________________________________________
      //

       dcl-proc isCustom;
         dcl-pi *n ind;
           Order# packed(6:0);
         END-PI;
         dcl-s custom ind Inz(*off);

         Reset Custom;

         Exec SQL
           Select '1' into :Custom from FHORDRCSTM where COORD# = :SELORDER;

         return Custom;

       END-PROC;

    ?D/COPY QFunctDefn,$ErrMsgSP
