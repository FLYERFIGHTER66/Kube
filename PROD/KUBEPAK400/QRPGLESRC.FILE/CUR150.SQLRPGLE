    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *     Cuttings move OVER to SHORT

     D DataStruct      DS
     D  SowDate                       7S 0 Inz(*Zeros)
     D  Item                         12A   Inz(*Blanks)
     D  ShortVendor                   6S 0 Inz(*Zeros)
     D  ShortSize                     3A   Inz(*Blanks)
     D  ShortQty                      7S 0 Inz(*Zeros)
     D  OverVendor                    6S 0 Inz(*Zeros)
     D  OverSize                      3A   Inz(*Blanks)
     D  OverQty                       7S 0 Inz(*Zeros)

     D  Today          S              7S 0 Inz(*Zeros)
     D  Order          S              6S 0 Inz(*Zeros)
     D  QtyToMove      S              7S 0 Inz(*Zeros)

      *? Function Prototypes
     D/COPY QFunctDefn,$_Dates

     D CUR150          PR                  ExtPgm('CUR150')
     D CUR150          PI

      /Free

         Today = $Date7($Date(0));

         // Make sure the Available Quantity is correct
         Exec SQL
           UPDATE  FCUTLOT
           SET     CLQTAV  = CLQTOH+CLQTOO-CLQTSL
           WHERE   CLQTAV <> CLQTOH+CLQTOO-CLQTSL
             and   CLSOWD  > :Today ;

         // Loop through all instances where we can make positive progress
         DoW not *InLR;

           Clear DataStruct;

           Exec SQL
             SELECT     SHT.CLSOWD
                  ,     SHT.CLITEM
                  ,     SHT.CLVEND
                  ,     SHT.CLSIZE
                  ,     SHT.CLQTAV
                  ,     OVR.CLVEND
                  ,     OVR.CLSIZE
                  ,     OVR.CLQTAV-OVR.CLQTOO
             INTO      :DataStruct
             FROM       FCUTLOT as sht
                ,       FCUTLOT as ovr
             WHERE      sht.CLSOWD =  ovr.CLSOWD
               and      sht.CLITEM =  ovr.CLITEM
               and      sht.CLSIZE <> ovr.CLSIZE
               and      sht.CLSOWD > :Today
               and      sht.CLQTAV            < 0
               and      ovr.CLQTAV-ovr.CLQTOO > 0
               and      ovr.CLQTOO >= 0
             ORDER BY   sht.CLSOWD
                    ,   sht.CLITEM
                    ,   sht.CLQTAV DESC
             Fetch First Row Only;

           If Item = ' ';
             *InLr = *On;
            Else;
             // Calculate Quantity to Move
             If %Abs(ShortQty) > %Abs(OverQty);
               QtyToMove = %Abs(OverQty);
              Else;
               QtyToMove = %Abs(ShortQty);
             EndIf;

             // Add Quantity to Move to Short Record
             Exec SQL
               Update FCUTLOT
               Set    CLQTOH = CLQTOH + :QtyToMove
                 ,    CLQTAV = CLQTAV + :QtyToMove
               Where  CLSOWD = :SowDate
                 and  CLITEM = :Item
                 and  CLVEND = :ShortVendor
                 and  CLSIZE = :ShortSize;

             // Subtract Quantity to Move from Over Record
             Exec SQL
               Update FCUTLOT
               Set    CLQTOH = CLQTOH - :QtyToMove
                 ,    CLQTAV = CLQTAV - :QtyToMove
               Where  CLSOWD = :SowDate
                 and  CLITEM = :Item
                 and  CLVEND = :OverVendor
                 and  CLSIZE = :OverSize;

             // Get Next Vendor Transaction Order Numbers
             Exec SQL
               Select CCNXTM into :Order from FCUTCTL
                 Where CCCONO = 1 and CCVEND = :OverVendor;
             Exec SQL
               Update FCUTCTL Set CCNXTM = CCNXTM + 2
                 Where CCCONO = 1 and CCVEND = :OverVendor;

             // Write "Transfer To" transaction record
             Exec SQL
               Insert Into FCUTORD
               Values(
                  :OverVendor
                , 'M'
                , :Order
                , :Item
                , :OverSize
                , ' '
                , :Today
                , :SowDate
                , 0
                , ' '
                , 'Auto Transfer'
                , :OverVendor
                , 'Move to   '||:ShortSize
                , 0
                , -:QtyToMove
                , 'Y'
                , 'Y' );

             // Write "Transfer From" transaction record
             Exec SQL
               Insert Into FCUTORD
               Values(
                  :OverVendor
                , 'M'
                , :Order + 1
                , :Item
                , :ShortSize
                , ' '
                , :Today
                , :SowDate
                , 0
                , ' '
                , 'Auto Transfer'
                , :OverVendor
                , 'Move from '||:OverSize
                , 0
                , :QtyToMove
                , 'Y'
                , 'Y' );

           ENDIF;

         ENDDO;

      /End-Free
