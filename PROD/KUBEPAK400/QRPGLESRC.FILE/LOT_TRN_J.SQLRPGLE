      /COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
?     // ?:````````````````````````````````````````````````````````````:?
?     // ?:         Lot Transaction - NA - Noxers &  Un-sown           :?
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

     FJALITEM997IF   E           K DISK
     FFALITEM   UF A E           K DISK
     FFDLOTRDCLTUF A E           K DISK
     FFIORDR    UF A E           K DISK
     FFIORDRPARTO  A E           K DISK

      //? Function Prototypes
    ?D/COPY QFunctDefn,$_LOT
    ?D/COPY QFunctDefn,$_OE
    ?D/COPY QFunctDefn,$_IC
    ?D/COPY QFunctDefn,$_Dates
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Now

      //? Subprocedure Prototypes

      //? Program Prototype
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
      //? Program Interface
     D LOT_TRN_J       PI                                                       Procedure Interface
     D PORDER                         6  0                                      Order Number
     D PSEQ#                          3  0                                      Order Seq# to Start
     D P990Item                      12                                         990 Item Number
     D P990Size                       3                                         990 Size Code
     D P990CRDY                       7  0                                      990 Current Ready
     D P990SOWD                       7  0                                      990 Sow Date
     D P990SHPD                       7  0                                      990 Ship Date
     D PQTY                           6  0                                      Quantity
     D PCOMMENT                        N                                        Include Comment

      //? Field Definitions
     D User            S             10A                                        ?Current User ID
     D CommentLine#    S                   Like(OISEQ#)                         ?Comment Line #
     D PartialLine#    S                   Like(OISEQ#)                         ?Comment Line #
     D Eleven1         S             11P 1 Inz(1)                               ?One

     D #PartialPCT     S              4S 2                                      ?One
     D #Saleable       S              5S 0                                      ?One
     D #Cells          S              3S 0                                      ?One
     D #ofCells        S              3S 0                                      ?One
     D #Discount       S              4S 1                                      ?One

      //? Indicators
     D EndOfFile01     S               N   Inz(*Off)

      //? Data Areas
     D Key990DS        DS           256
     D  $Item                        12A
     D  $Size                         3A
     D  $SowD                         7P 0
     D  $CRdy                         7P 0

      /Free

       // Get Order Detail. Make sure we have enough Order Quantity for the requested Qty
         Chain (POrder:PSEQ#) Fiordr;
         If OIQORD - OIQSHP >=1;
           PQTY = OIQORD - OIQSHP;
       // Reduce Ordered Quantity and Adjust Extended Price.  Deallocate Lot Inventory.  Update.
           OIQORD -= 1;
           OIEXT$ = OIQORD * OIUPRI;
           CallP  $DlcLotInv(POrder:PSEQ#:Eleven1:
                   P990Item:P990Size:P990SOWD:P990CRDY);
           If OIQORD > 0;
             Update RIORDR;
             PartialLine# = PSEQ# + 1;  // Insert Partial after Original Line
             $InsOrdLin(POrder:PSEQ#+1:2); // Insert line for Partial & Comment
           Else;
             Delete RIORDR;
             PartialLine# = PSEQ# + 0;  // Replace Original Line with Partial Line
             $InsOrdLin(POrder:PSEQ#+1:1); // Insert line for Comment Only
           EndIf;
           CommentLine# = PartialLine# + 1;  // Comment is on line after Partial
       // Write/Update FALITEM record for Partial.
           Chain (POrder:PartialLine#) FAlItem;
           AIORD# = POrder;
           AIOSEQ = PartialLine#;
           AISHPD = P990SHPD;
           AISTAT = 'A';
           AIITEM = P990Item;
           AISIZE = P990Size;
           AIWHSE = *Blanks;
           AISOWD = P990SOWD;
           AIGLOC = ' ';
           AIPHYT = *Blanks;
           AICRDY = P990CRDY;
           AICUST = 999997;
           AICOMP = 1;
           AIQTOA = 1;
           AIDTLA = $MDYDate($Date(0));
           AITIME = $Now();
           AIUSER = $User();
           AIPRCL = OIPRCL;
           Write RALITEM;
       // Update LOTRD File and Allocate inventory
           Chain (AIITEM:
                  AISIZE:
                  AIWHSE:
                  AISOWD:
                  AICRDY:
                  AICUST ) FDLOTRDCLT;
           LRQTAL += 1;
             LRQTAV -= 1;
           If %Found(FDLOTRDCLT);
             Update RDLOTRD;
           Else;
             LRITEM = AIITEM;
             LRSIZE = AISIZE;
             LRWHSE = AIWHSE;
             LRSOWD = AISOWD;
             LRCRDY = AICRDY;
             LRCUST = AICUST;
             LRGLOC = AIGLOC;
             Write RDLOTRD;
           ENDIF;
       // Create Partial Line;
           OISEQ# = PartialLine#;
           OIQORD = 1;
           #PartialPCT = $LotPartPct(P990ITEM:P990SIZE:P990SOWD:P990CRDY);
           If #PartialPCT = *Zero;
             #PartialPCT = 1;
           EndIf;
           OIOVER = 'Y';
           OIUPRI *= (#PartialPCT);
           OIEXT$ = OIUPRI;
           Write RIORDR;
           OIPCTF = #PartialPCT * 100;
           Write RIORDRPART;
       // Create Comment Line
           OISEQ# = CommentLine#;
           OIITYP = 'C';
           OIQORD = *Zero;
           OIQBOO = *Zero;
           OIQSHP = *Zero;
           #Saleable = $Saleable(OISIZE);
           #Cells    = #Saleable*(#PartialPCT);
           #ofCells  = #Saleable;
           #Discount = (1-(#Cells/#Saleable))*100;
           OIDES1 = 'Adj: (' + %Trim(%EditC(#Cells:'Z')) +
                    ' of '+ %Trim(%EditC(#ofCells:'Z')) + ') Disc: ' +
                    %Trim(%EditW(#Discount:'   .0%'));
           Write RIORDR;
         ENDIF;

         *InLR = *On;

      /END-FREE
