create or replace view Kube_Pak_Standard_Plug_Inventory_L4A for system name FSTDPLGL4A as
-- -----------------------------------------------------------------------------
-- 4.  Plug Items we CAN produce based on Supplier Availability
-- -----------------------------------------------------------------------------

-- Plug Items that we can produce
SELECT   PLUG_CTL_TYPE          as View_Control_Type
        ,ready_date             as Ready_Date
        ,ready_date_7           as Ready_Date_7
        ,SowDate                as SowDate
        ,Item_Number            as Item_Number
        ,Item_Size              as Item_Size
        ,Item_Description       as Item_Description
        ,Item_Sort              as Item_Sort
        ,floor(SUPPLIER_QUANTITY_AVAILABLE / Saleable_Cells)
                                as Quantity_Available
        ,current Timestamp      as Retrieved_Time

FROM    Kube_Pak_Plugs_All_Lots as lots
join    Inventory_View_Control_File             on  lots.Sow_Code = PLUG_CTL_CODE
join    Supplier_Inventory_Summary              on  Item_Number = KUBE_PAK_ITEM and AVAILABLE_DATE = SOWDATE

WHERE   READY_DATE between current date and current date + 365 days
  and   SowDate >= max(Next_Sow_Date_Cut, Hold_Sow_Date_Cut)
  and   (Item_Number, READY_DATE)             not in (Select AVITEM, DATEFLD from Unavailable_items_400)
  and   (Item_Number, Item_Size, READY_DATE)  not in (Select AVITEM, AVSIZE, DATEFLD from Unavailable_item_Size_400);
