     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:         Recip Sow line operation Display Un-sown            ?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Aug. 2004            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program generates a report which shows the Tray    ?:
      *? : and Soil breakdown for the specified Sow Week.            ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? : Subroutine ?-Subroutine Description                  ?  ?:
      *? :  *INZSR      -?Initialization Subroutine                  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? : Function   ?-Function Description                    ?  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  11      ?Overflow indicator                              ?:
      *? :  12      ?First Page indicator                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FSOW035P   O    E             PRINTER OFLIND(*IN11)

     FFMINVT    IF   E           K DISK                                         ?Item Master
     FFMSIZE    IF   E           K DISK                                         ?Size Master
     FFTRAYR    IF   E           K DISK                                         ?Tray Master

      *?  LDA
     D                UDS

      *? Sow File Data Structure
     D  UnSown_DS      DS                  INZ
     D  SowDate                            Like(TRSCYM)                         ?Sow_Date
     D  ReadyDate                          Like(TRCRDT)                         ?Ready_Date
     D  Size                               Like(TRSIZE)                         ?Size
     D  Item                               Like(TRITEM)                         ?Item
     D  Alpha                              Like(TRALPH)                         ?Alpha
     D  Desc01                             Like(IMDES1)                         ?Description
     D  Factor                        5S 3                                      ?Factor
     D  Seed_Cell                          Like(IM#SED)                         ?Seed_Cell
     D  Cell_Tray                          Like(SZCELL)                         ?Cell_Tray
     D  Tray_Count                    4S 0                                      ?Tray_Count
     D  Seed_Need                     7S 0                                      ?Seed_Need
     D  On_Hand                            Like(IMQTOH)                         ?On_Hand
     D  Available                          Like(IMQTAV)                         ?Available
     D  Sow_Method                         Like(IMTPSW)                         ?Sow Method

      *? Fields
     D  RecordCount    S              5S 0 INZ(0)

      *? Indicators
     D  EndOfFile      S               N   INZ(*Off)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User

      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

    ?C                   ExSr      GetData
    ?
      *? Read through SQL cursor and Print
    ?C                   ExSr      ReadData
     C                   DoW       not EndOfFile
     C                   ExSr      PrintData
    ?C                   ExSr      ReadData
     C                   EndDo

     C                   If        RecordCount > *Zeros
    ?C*                  Write     SubTotal
    ?C*                  Write     Total
     C                   Else
    ?C                   Write     NoData
     C                   EndIf

     C                   Eval      *InLR = *On
     C                   ExSr      CloseData


      *?  ...........................................................
      *?  :      GetData - Run SQL to select Data                   :
      *?  :.........................................................:

     C     GetData       BegSr

      *? Select Un-confirmed trays from FTRAYR

    ?C                   Select                                                 ?
    ?C                   When      OperType = 'R'                               ?Recip. Sowing
    ?c/exec sql
    ?c+
    ?c+  DECLARE   C1 cursor for
    ?c+
    ?c+    SELECT      Tray.TRSCYM                       as Sow_Date
    ?c+         ,      Tray.TRCRDT                       as Ready_Date
    ?c+         ,      Tray.TRSIZE                       as Size
    ?c+         ,      Tray.TRITEM                       as Item
    ?c+         ,      Tray.TRALPH                       as Alpha
    ?c+         ,      Item.IMDES1                       as Description
    ?c+         ,      DEC(AVG(1+(Seed.IMMULT/100)),5,3) as Factor
    ?c+         ,      INT(AVG(Item.IM#SED))             as Seed_Cell
    ?c+         ,      INT(AVG(Size.SZCELL))             as Cell_Tray
    ?c+         ,      Count(*)                          as Tray_Count
    ?c+         ,      INT(Sum(Round(
    ?c+                    (1+(Float(Seed.IMMULT)/100))
    ?c+                      * Float(Item.IM#SED)
    ?c+                      * Float(Size.SZCELL),0)))   as Seed_Need
    ?c+         ,      Seed.IMQTOH                       as On_Hand
    ?c+         ,      Seed.IMQTAV                       as Available
    ?c+         ,      Item.IMTPSW                       as Sow_Method
    ?c+
    ?c+    FROM        FTRAYR as Tray
    ?c+         ,      FMSIZE as Size
    ?c+         ,      FMINVT as Item
    ?c+         ,      FMINVT as Seed
    ?c+
    ?c+    WHERE       Tray.TRSIZE = Size.SZCODE
    ?c+      and       Tray.TRITEM = Item.IMITEM
    ?c+      and       Tray.TRSIZE = Item.IMSIZE
    ?c+      and       Tray.TRITEM = Seed.IMITEM
    ?c+      and       Seed.IMSIZE = 'SED'
    ?c+      and       Item.IMTPSW not in ('R', 'P')
    ?c+
    ?c+    GROUP BY    Tray.TRSCYM
    ?c+           ,    Tray.TRSIZE
    ?c+           ,    Tray.TRALPH
    ?c+           ,    Item.IMDES1
    ?c+           ,    Tray.TRITEM
    ?c+           ,    Tray.TRCRDT
    ?c+           ,    Seed.IMQTOH
    ?c+           ,    Seed.IMQTAV
    ?c+           ,    Item.IMTPSW
    ?c+
    ?c+    ORDER BY    Tray.TRSCYM
    ?c+           ,    Tray.TRSIZE
    ?c+           ,    Tray.TRALPH
    ?c+           ,    Item.IMDES1
    ?c+           ,    Tray.TRITEM
    ?c+           ,    Tray.TRCRDT
    ?c+           ,    Seed.IMQTOH
    ?c+           ,    Seed.IMQTAV
    ?c+
    ?c+  For Read only
    ?c+
    ?c/end-exec

     ?*  Open the SQL recordset
    ?c/exec sql
    ?c+                  Open      C1
    ?c/end-exec

    ?C                   Other                                                  ?all other Sowing

    ?c/exec sql
    ?c+
    ?c+  DECLARE   C2 cursor for
    ?c+
    ?c+    SELECT      Tray.TRSCYM                       as Sow_Date
    ?c+         ,      Tray.TRCRDT                       as Ready_Date
    ?c+         ,      Tray.TRSIZE                       as Size
    ?c+         ,      Tray.TRITEM                       as Item
    ?c+         ,      Tray.TRALPH                       as Alpha
    ?c+         ,      Item.IMDES1                       as Description
    ?c+         ,      DEC(AVG(1+(Seed.IMMULT/100)),5,3) as Factor
    ?c+         ,      INT(AVG(Item.IM#SED))             as Seed_Cell
    ?c+         ,      INT(AVG(Size.SZCELL))             as Cell_Tray
    ?c+         ,      Count(*)                          as Tray_Count
    ?c+         ,      INT(Sum(Round(
    ?c+                    (1+(Float(Seed.IMMULT)/100))
    ?c+                      * Float(Item.IM#SED)
    ?c+                      * Float(Size.SZCELL),0)))   as Seed_Need
    ?c+         ,      Seed.IMQTOH                       as On_Hand
    ?c+         ,      Seed.IMQTAV                       as Available
    ?c+         ,      Item.IMTPSW                       as Sow_Method
    ?c+
    ?c+    FROM        FTRAYR as Tray
    ?c+         ,      FMSIZE as Size
    ?c+         ,      FMINVT as Item
    ?c+         ,      FMINVT as Seed
    ?c+
    ?c+    WHERE       Tray.TRSIZE = Size.SZCODE
    ?c+      and       Tray.TRITEM = Item.IMITEM
    ?c+      and       Tray.TRSIZE = Item.IMSIZE
    ?c+      and       Tray.TRITEM = Seed.IMITEM
    ?c+      and       Tray.TRSTAT <> 'D'
    ?c+      and       Seed.IMSIZE = 'SED'
    ?c+      and       Item.IMTPSW = Case :OperType When 'C' then 'R'
    ?c+                                             When 'T' then 'P' end
    ?c+
    ?c+    GROUP BY    Tray.TRSCYM
    ?c+           ,    Tray.TRSIZE
    ?c+           ,    Tray.TRALPH
    ?c+           ,    Item.IMDES1
    ?c+           ,    Tray.TRITEM
    ?c+           ,    Tray.TRCRDT
    ?c+           ,    Seed.IMQTOH
    ?c+           ,    Seed.IMQTAV
    ?c+           ,    Item.IMTPSW
    ?c+
    ?c+    ORDER BY    Tray.TRSCYM
    ?c+           ,    Tray.TRSIZE
    ?c+           ,    Tray.TRALPH
    ?c+           ,    Item.IMDES1
    ?c+           ,    Tray.TRITEM
    ?c+           ,    Tray.TRCRDT
    ?c+           ,    Seed.IMQTOH
    ?c+           ,    Seed.IMQTAV
    ?c+
    ?c+  For Read only
    ?c+
    ?c/end-exec

     ?*  Open the SQL recordset
    ?c/exec sql
    ?c+                  Open      C2
    ?c/end-exec
    ?C                   EndSl                                                  ?

     C                   EndSr

      *?  ...........................................................
      *?  :      CloseData - Close the Data Set                     :
      *?  :.........................................................:

     C     CloseData     BegSr

     ?*  Close the SQL recordset
    ?C                   Select                                                 ?
    ?C                   When      OperType = 'R'                               ?Recip. Sowing
    ?c/exec sql
    ?c+                  Close     C1
    ?c/end-exec
    ?C                   Other                                                  ?Other Sowing
    ?c/exec sql
    ?c+                  Close     C2
    ?c/end-exec
    ?C                   EndSl

     C                   EndSr

      *?  ...........................................................
      *?  :      ReadData - Read Data                               :
      *?  :.........................................................:

     C     ReadData      BegSr

     ?*  Read Unsown records
    ?C                   Select                                                 ?
    ?C                   When      OperType = 'R'                               ?Recip. Sowing
    ?c/exec sql
    ?c+ Fetch C1 into :UnSown_DS
    ?c/end-exec
    ?C                   Other                                                  ?Other Sowing
    ?c/exec sql
    ?c+ Fetch C2 into :UnSown_DS
    ?c/end-exec
    ?C                   EndSl

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Eval      RecordCount = RecordCount + 1                ?Record Count
     C                   EndIf

     C                   EndSr

      *?  ...........................................................
      *?  :      PrintData - Print Soubroutine                      :
      *?  :.........................................................:

     C     PrintData     BegSr

      *? If it's the First Page OR an Overflow, then write the Report Header
     C                   If        *In11 or not *In12
    ?C                   WRITE     HEADER
     C                   Eval      *IN11 = *Off
     C                   Eval      *In12 = *On
     C                   EndIf

      *? Check for Subtotal Break
     C*                  If        SaveClass <> ProdClass
    ?C*                  WRITE     SubTotal
     C*                  Z-Add     *Zero         SubOrdQty
     C*                  Z-Add     *Zero         SubSowQty
     C*                  Eval      SaveClass = ProdClass
     C*                  EndIf

      *? Format the Ship Date
     C                   Eval      RdyDate6 = $MDYDate($Date(READYDATE))
     C                   Eval      SowDate6 = $MDYDate($Date(SOWDATE))
     C                   Eval      ITEM5 = Item

      *? Add to Quantities
     C*                  ADD       OrderQty      SubOrdQty
     C*                  ADD       OrderQty      TotOrdQty

      *? Write Detail Line
    ?C                   WRITE     DETAIL

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C     *Entry        PList
     C                   Parm                    OperType          1

    ?C                   Select
    ?C                   When      OperType = 'R'
     C                   Eval      *In61 = *On                                  ?Recip. Sowing
    ?C                   When      OperType = 'C'
     C                   Eval      *In62 = *On                                  ?Rooted Cuttings
    ?C                   When      OperType = 'T'
     C                   Eval      *In63 = *On                                  ?Transplanting
    ?C                   EndSl

     C                   Eval      RunDate = $MDYDate($Date(0))
     C                   Eval      User    = $User()

      *?  Dummy reads for variable definitions
     C                   Eval      *In99 = *Off
     C   99              Read      FMINVT
     C   99              Read      FMSIZE
     C   99              Read      FTRAYR

     C                   EndSR
