     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H BndDir('KPFUNCTION')
     H DATFMT(*USA)
     H NOMAIN

    ? //?$LotPartPct - Returns the Percentage of the Partials on a LOT.
    ? //?$OrdSeqLot  - Returns TRUE if an FALITEM/FDLOTRD Exist for this Ord#/Seq#
    ? //?$OrdSeq990  - Returns TRUE if a 990 exists for a lot this Ord#/Seq# is allocated against.
    ? //?$OrdSeq997  - Returns TRUE if a 997 exists for a lot this Ord#/Seq# is allocated against.
    ? //?$Get990Key  - Returns a DS with the Keys to a 990 records for the order/seq# passed in.
    ? //?$Update990  - Update Quantities on Specified 990 records.
    ? //?$Update997  - Update Quantities on Specified 997 records.

      *? Function Prototypes
     D/Copy QFunctDefn,$_Lot

?     //? $LotPartPct
     P $LotPartPct     B                   Export
     D $LotPartPct     PI             4S 2                                      Percent As Decimal
     D  $Item                        12A
     D  $Size                         3A
     D  $SowD                         7P 0
     D  $Ready                        7P 0

     D  $Percentage    S              4S 2
?    ?*  The $LotPartPct routine returns the Percentage of the Partials on a LOT.
      /Free

         Exec SQL
              Select    Sum(LOSS.LDPRTT)
              Into      :$Percentage
              FROM      FLOSSLOT as LOSS
              Where     LOSS.LDITEM = :$Item
                and     LOSS.LDSIZE = :$Size
                and     LOSS.LDSOWD = :$SowD
                and     LOSS.LDREDY = :$Ready
                and     LOSS.LDPRTT <> 0  ;

         If SQLSTT <> '00000';
           Return *Zero;
         Else;
           Return $Percentage;
         EndIf;

      /End-Free
     P $LotPartPct     E


?     //? $OrdSeq990
     P $OrdSeq990      B                   Export
     D $OrdSeq990      PI              N                                        Logical
     D  $Ord#                         6P 0 Const
     D  $Seq#                         3P 0 Const
    ??*$OrdSeq990 Returns TRUE if a 990 exists for a lot this Ord#/Seq# is allocated against.
     D  $Count         S              6S 0
      /Free

       Exec SQL
           Select   Count(*)
           Into     :$Count
           From     FALITEM , FDLOTRD990
           Where    FALITEM.AIITEM = FDLOTRD990.LRITEM
             and    FALITEM.AISIZE = FDLOTRD990.LRSIZE
             and    FALITEM.AISOWD = FDLOTRD990.LRSOWD
             and    FALITEM.AICRDY = FDLOTRD990.LRCRDY
             and    FALITEM.AIORD# = :$Ord#
             and    FALITEM.AIOSEQ = :$Seq#
             and    FALITEM.AIQTOA > 0
             and    FDLOTRD990.LRQTOH - FDLOTRD990.LRQTAL <> 0 ;

         If SQLSTT <> '00000' or $Count = *Zero;
           Return *Off ;
         Else;
           Return *On  ;
         EndIf;

      /End-Free
     P $OrdSeq990      E


?     //? $OrdSeq997
     P $OrdSeq997      B                   Export
     D $OrdSeq997      PI              N                                        Logical
     D  $Ord#                         6P 0 Const
     D  $Seq#                         3P 0 Const
    ??*$OrdSeq997 Returns TRUE if a 997 exists for a lot this Ord#/Seq# is allocated against.
     D  $Count         S              6S 0
      /Free

       Exec SQL
           Select   Count(*)
           Into     :$Count
           From     FALITEM, FDLOTRD997
           Where    FALITEM.AIITEM = FDLOTRD997.LRITEM
             and    FALITEM.AISIZE = FDLOTRD997.LRSIZE
             and    FALITEM.AISOWD = FDLOTRD997.LRSOWD
             and    FALITEM.AICRDY = FDLOTRD997.LRCRDY
             and    FALITEM.AIORD# = :$Ord#
             and    FALITEM.AIOSEQ = :$Seq#
             and    FALITEM.AIQTOA > 0
             and    FDLOTRD997.LRQTOH - FDLOTRD997.LRQTAL > 0 ;

         If SQLSTT <> '00000' or $Count = *Zero;
           Return *Off ;
         Else;
           Return *On  ;
         EndIf;

      /End-Free
     P $OrdSeq997      E


?     //?    $Get990Key
     P $Get990Key      B                   Export
     D $Get990Key      PI           256                                         Logical
     D  $Ord#                         6P 0 Const
     D  $Seq#                         3P 0 Const
    ??*$Get990Key Returns a DS with the Keys to a 990 records for the order/seq# passed in.
     D  $LotKeyDS      DS           256
     D  $Item                        12A
     D  $Size                         3A
     D  $SowD                         7P 0
     D  $CRdy                         7P 0
      /Free

       Exec SQL
           Select   FDLOTRD990.LRITEM
               ||   FDLOTRD990.LRSIZE
               ||   FDLOTRD990.LRSOWD
               ||   FDLOTRD990.LRCRDY
           Into     :$LotKeyDS
           From     FALITEM , FDLOTRD990
           Where    FALITEM.AIITEM = FDLOTRD990.LRSIZE
             and    FALITEM.AISIZE = FDLOTRD990.LRSIZE
             and    FALITEM.AISOWD = FDLOTRD990.LRSOWD
             and    FALITEM.AICRDY = FDLOTRD990.LRCRDY
             and    FALITEM.AIORD# = :$Ord#
             and    FALITEM.AIOSEQ = :$Seq#
             and    FDLOTRD990.LRQTOH - FDLOTRD990.LRQTAL <> 0 ;

         If SQLSTT <> '00000';
           Return *Blanks ;
         Else;
           Return $LotKeyDS;
         EndIf;

      /End-Free
     P $Get990Key      E


?     //?    $Update990
     P $Update990      B                   Export
     D $Update990      PI              N                                        Logical
     D  $Item                        12A   Const
     D  $Size                         3A   Const
     D  $SowD                         7P 0 Const
     D  $CRdy                         7P 0 Const
     D  $Add2OH                       7P 1 Const
     D  $Add2AL                       7P 1 Const
     D  $Add2AV                       7P 1 Const
     D  $UserID                      10A   Const
    ??*$Update990 Update Quantities on Specified 990 records.
     D  TimeNow        S              6S 0
     D  DateNow        S              6S 0

     D/Copy QFunctDefn,$_Dates
     D/Copy QFunctDefn,$User
     D/Copy QFunctDefn,$Now

      /Free

         TimeNow = $Now();
         DateNow = $MDYDate($Date(0));

       Exec SQL
           Update   FDLOTRD990
           Set      FDLOTRD990.LRQTOH = FDLOTRD990.LRQTOH + :$Add2OH
             ,      FDLOTRD990.LRQTAL = FDLOTRD990.LRQTAL + :$Add2AL
             ,      FDLOTRD990.LRQTAV = FDLOTRD990.LRQTAV + :$Add2AV
             ,      FDLOTRD990.LRDTLA = :DateNow
             ,      FDLOTRD990.LRTIME = :TimeNow
             ,      FDLOTRD990.LRUSER = :$UserID
           Where    FDLOTRD990.LRITEM = :$Item
             and    FDLOTRD990.LRSIZE = :$Size
             and    FDLOTRD990.LRSOWD = :$SowD
             and    FDLOTRD990.LRCRDY = :$CRdy  ;

         If SQLSTT = '00000';
           Return *On;
         Else;
           Return *Off;
         EndIf;

      /End-Free
     P $Update990      E


?     //?$Write990
     P $Write990       B                   Export
     D $Write990       PI              N                                        Logical
     D  $Item                        12A   Const
     D  $Size                         3A   Const
     D  $SowD                         7P 0 Const
     D  $CRdy                         7P 0 Const
     D  $Qty                          7P 1 Const
     D  $UserID                      10A   Const
    ??*$Write990  Update Quantities on Specified 990 records.
     D  TimeNow        S              6S 0
     D  DateNow        S              6S 0
     D  IMLOOK         S             12A
     D  IMDES1         S             30A
     D  IMPCL1         S              2A

     D/Copy QFunctDefn,$_Dates
     D/Copy QFunctDefn,$User
     D/Copy QFunctDefn,$Now

      /Free

         TimeNow = $Now();
         DateNow = $MDYDate($Date(0));

       Exec SQL
           Select  IMLOOK into :IMLOOK
           from    FMINVT
           where   IMITEM = :$Item
             and   IMSIZE = :$Size ;
       Exec SQL
           Select  IMDES1 into :IMDES1
           from    FMINVT
           where   IMITEM = :$Item
             and   IMSIZE = :$Size ;
       Exec SQL
           Select  IMPCL1 into :IMPCL1
           from    FMINVT
           where   IMITEM = :$Item
             and   IMSIZE = :$Size ;
       Exec SQL
           Insert
           Into     FDLOTRD
              (     LRSTAT
              ,     LRITEM
              ,     LRSIZE
              ,     LRSOWD
              ,     LRCRDY
              ,     LRCODE
              ,     LRCUST
              ,     LRCOMP
              ,     LRQTOH
              ,     LRDTLA
              ,     LRTIME
              ,     LRUSER
              ,     LRALPH
              ,     LRPRCL
              ,     LRQTAL
              ,     LRDESC
              ,     LRQTAV  )
           Values
              (     'A'                                                                  //LRSTAT
              ,     :$Item                                                               //LRITEM
              ,     :$Size                                                               //LRSIZE
              ,     :$SowD                                                               //LRSOWD
              ,     :$CRdy                                                               //LRCRDY
              ,     'A'                                                                  //LRCODE
              ,     999990                                                               //LRCUST
              ,     1                                                                    //LRCOMP
              ,     :$QTY                                                                //LRQTOH
              ,     :DateNow                                                             //LRDTLA
              ,     :TimeNow                                                             //LRTIME
              ,     :$User                                                               //LRUSER
              ,     :IMLOOK                                                              //LRALPH
              ,     :IMPCL1                                                              //LRPRCL
              ,     0                                                                    //LRQTAL
              ,     :IMDES1                                                              //LRDESC
              ,     :$QTY    ) ;                                                         //LRQTAV

         If SQLSTT = '00000';
           Return *On;
         Else;
           Return *Off;
         EndIf;

      /End-Free
     P $Write990       E


?     //?    $Update997
     P $Update997      B                   Export
     D $Update997      PI              N                                        Logical
     D  $Item                        12A   Const
     D  $Size                         3A   Const
     D  $SowD                         7P 0 Const
     D  $CRdy                         7P 0 Const
     D  $Add2OH                       7P 1 Const
     D  $Add2AL                       7P 1 Const
     D  $Add2AV                       7P 1 Const
     D  $UserID                      10A   Const
    ??*$Update990 Update Quantities on Specified 990 records.
     D  TimeNow        S              6S 0
     D  DateNow        S              6S 0

     D/Copy QFunctDefn,$_Dates
     D/Copy QFunctDefn,$User
     D/Copy QFunctDefn,$Now

      /Free

         TimeNow = $Now();
         DateNow = $MDYDate($Date(0));

       Exec SQL
           Update   FDLOTRD997
           Set      FDLOTRD997.LRQTOH = FDLOTRD997.LRQTOH + :$Add2OH
             ,      FDLOTRD997.LRQTAL = FDLOTRD997.LRQTAL + :$Add2AL
             ,      FDLOTRD997.LRQTAV = FDLOTRD997.LRQTAV + :$Add2AV
             ,      FDLOTRD997.LRDTLA = :DateNow
             ,      FDLOTRD997.LRTIME = :TimeNow
             ,      FDLOTRD997.LRUSER = :$UserID
           Where    FDLOTRD997.LRITEM = :$Item
             and    FDLOTRD997.LRSIZE = :$Size
             and    FDLOTRD997.LRSOWD = :$SowD
             and    FDLOTRD997.LRCRDY = :$CRdy  ;

         If SQLSTT = '00000';
           Return *On;
         Else;
           Return *Off;
         EndIf;

      /End-Free
     P $Update997      E
