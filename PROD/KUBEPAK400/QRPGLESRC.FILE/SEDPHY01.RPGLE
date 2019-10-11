    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *??:````````````````````````````````````````````````````````````:?
      *??:     Process Physical Inventory Upload                      :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Aug. 2005            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program provides the ability to update seed        ?:
      *? : inventory based on an uploaded seed physical inventory.   ?:
      *? : The physical inventory is uploaded in file FPYHINV and    ?:
      *? : is procesed by this program.  The seed inventory on file  ?:
      *? : FMINVT is adjusted based on the Physical inventory and    ?:
      *? : adjusted based on the sowing done since the date of the   ?:
      *? : inventory.                                                ?:
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
      *? :  $Date        ?Get Date Value                             ?:
      *? :  $DateMDY     ?Get Date Number in MM/DD/YY                ?:
      *? :  $Monday      ?Get Monday Date Value                      ?:
      *? :  $AddDate     ?Add/Subtract Days from Date                ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFPHYINV   IF   E           K DISK                                         ?Physical Inventory
     FFTRAYSIS  IF   E           K DISK                                         ?Tray- Sow/Item/Size
     FFMINVT    UF   E           K DISK                                         ?Inventory Master
     FKPHIST    UF A E           K DISK                                         ?Inv. Transactions

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date6
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$SeedSown
    ?D/COPY QFunctDefn,$Year

      *? Data Structures
     D                SDS                                                       ?
     D    ProgID         *PROC                                                  ?Program Name

      *? Array Definitions
    ?D* None

      *? Field Definitions
     D  UserID         S             10A                                        ?
     D  Today          S              6S 0                                      ?
     D  PhyDate        S                   Like(PIDATE)                         ?
     D  PhyDate7       S              7S 0
     D  SaveITEM       S                   Like(PIITEM)                         ?
     D  SaveSIZE       S                   Like(PISIZE)                         ?
     D  SeedUsed       S             15S 0
     D  TraySeed       S              5S 0
     D  Year           S              4S 0

      *? Indicators
    ?D* None

      *?   Get the Last Physical Inventory Date
    ?C     *HiVal        SetGT     FPHYINV
    ?C                   ReadP     FPHYINV
     C                   Eval      PhyDate  = PIDATE
     C                   Eval      PhyDate7 = $Date7($Date(PIDATE))

      *?   Read the First Physical Inventory Record
    ?C     PhyDate       SetLL     FPHYINV
    ?C     PhyDate       ReadE     FPHYINV
     C                   DoW       not %EOF(FPHYINV)

      *?   Get current Inventory Record.
    ?C     ItemKey       Chain     FMINVT

      *?   Check to see if any seeds have been used since the Physical Inventory
     C                   Eval      SeedUsed = *Zero
    ?C     TrayKey       SetLL     FTRAYSIS
    ?C     PIITEM        ReadE     FTRAYSIS
     C                   DoW       not %EOF(FTRAYSIS)
     C                   ExSr      CalcSeeds
    ?C     PIITEM        ReadE     FTRAYSIS
     C                   EndDo

      *?   If the Inventory record needs to be adjusted, Update Inventory & write transaction
     C                   If        (PIQTY - SeedUsed) - IMQTOH <> 0
      *?     Write an Inventory Transaction Record
     C                   Eval      DHPITM = PIITEM                               D/G ITEM NUMBER
     C                   Eval      DHPSIZ = PISIZE                               SIZE
     C                   Eval      DHCYMD = PIDATE                               DATE AS CCYYMMDD
     C                   Eval      DHTRAN = 'P'                                  TRANS TYPE
     C                   Eval      DHTYPE = 'Physical Inv Adjust'                TYPE OF TRANSACTION
     C                   Eval      DHFWHS = '01'                                 DEFAULT RECEIVING W
     C                   Eval      DHTWHS = 1                                    DEFAULT RECEIVING W
     C                   Eval      DHTQTY = (PIQTY - SeedUsed) - IMQTOH          Opening Bal
     C                   Eval      DHPPRC = 0                                    LAST PRICE
     C                   Eval      DHPOYR = Year - 2000                          JOBBER PO YEAR
     C                   Eval      DHDGPO = $Date6($Date(PhyDate7))              JOBBER PO NUMBER
     C                   Eval      DHCLOK = 0                                    Employee Number
     C                   Eval      DHUSER = UserID                               USER
    ?C                   Write     DGHISTR

      *?     Update the Inventory Record
     C                   Eval      IMQTOH = PIQTY - SeedUsed
    ?C                   Update    RMINVT
     C                   EndIf

      *?   Read the Next Physical Inventory Record
    ?C     PhyDate       ReadE     FPHYINV
     C                   EndDo

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      CalcSeeds - Calculate Seeds Used to Sow Tray       :
      *?  :.........................................................:

    ?C     CalcSeeds     BEGSR

     C                   If        SaveItem = TRITEM and
     C                             SaveSize = TRSIZE
     C                   Else
     C                   Eval      TraySeed = $SeedSown(TRITEM:TRSIZE:1)
     C                   Eval      SaveItem = TRITEM
     C                   Eval      SaveSize = TRSIZE
     C                   EndIF
     C                   Eval      SeedUsed = SeedUsed + TraySeed

    ?C                   EndSR

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

    ?C     *INZSR        BEGSR

    ?C     ItemKey       KList
    ?C                   KFld                    PIITEM
    ?C                   KFld                    PISIZE
    ?C     TrayKey       KList
    ?C                   KFld                    PIITEM
    ?C                   KFld                    PhyDate7
     C                   Eval      Today = $MDYDate($Date(0))
     C                   Eval      Year  = $Year($Date(0))
     C                   Eval      UserID= $User()

    ?C                   EndSR
