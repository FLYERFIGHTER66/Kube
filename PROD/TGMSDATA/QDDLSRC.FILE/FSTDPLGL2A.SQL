create or replace view Kube_Pak_Standard_Plug_Inventory_L2A for system name FSTDPLGL2A as

-- -----------------------------------------------------------------------------
-- 2.  Currently Unavailable Items
-- -----------------------------------------------------------------------------
--  UNAVAILABLE PLUG ITEMS
    --    Item in Unavailable_items_400
    --    Item/Size in Unavailable_item_Size_400

SELECT   PLUG_CTL_TYPE          as View_Control_Type
        ,ready_date             as Ready_Date
        ,ready_date_7           as Ready_Date_7
        ,SowDate                as SowDate
        ,Item_Number            as Item_Number
        ,Item_Size              as Item_Size
        ,Item_Description       as Item_Description
        ,Item_Sort              as Item_Sort
        ,0                      as Quantity_Available
        ,current Timestamp      as Retrieved_Time

FROM    Kube_Pak_Plugs_All_Lots as lots
join    FMAVDTE                             on  lots.Item_Number = AVITEM
join    Inventory_View_Control_File         on  lots.Sow_Code = PLUG_CTL_CODE

Where  (AVSIZE = Item_Size or AVSIZE = '')
  and   Ready_Date between current date and current date + 1 years
  and   Ready_Date <= DATE(TIMESTAMP_FORMAT(CHAR(AVDYMD),'YYYYMMDD'));

