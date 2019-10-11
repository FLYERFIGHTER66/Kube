create or replace view Kube_Pak_Standard_Plug_Inventory_L2C for system name FSTDPLGL2C as

-- -----------------------------------------------------------------------------
-- 2.  Currently Unavailable Items
-- -----------------------------------------------------------------------------
-- PLUGS FROM CUT KNOWN UNAVAILABLE FROM SUPPLIERS

SELECT   PLUG_CTL_TYPE          as View_Control_Type
        ,MONDAY_DATE            as Ready_Date
        ,MONDAY_DATE_CYYMMDD    as Ready_Date_7
        ,SowDate(IMITEM,IMSIZE,MONDAY_DATE)
                                as SowDate
        ,IMITEM                 as Item_Number
        ,IMSIZE                 as Item_Size
        ,IMDES1                 as Item_Description
        ,IMLOOK                 as Item_Sort
        ,0                      as Quantity_Available
        ,current Timestamp      as Retrieved_Time

FROM      MONDAYS
   ,      Kube_Pak_Plugs_From_Cuttings join Inventory_View_Control_File on IMSOWC = PLUG_CTL_CODE
                                       join Supplier_Inventory_Summary  on IMITEM = KUBE_PAK_ITEM

WHERE   MONDAY_DATE between current date and current date + 365 days
  and   SUPPLIER_QUANTITY_AVAILABLE = 0
  and   MONDAY_DATE = AVAILABLE_DATE;

