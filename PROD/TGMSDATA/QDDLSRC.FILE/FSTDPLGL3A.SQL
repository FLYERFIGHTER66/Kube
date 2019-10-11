create or replace view Kube_Pak_Standard_Plug_Inventory_L3A for system name FSTDPLGL3A as
-- -----------------------------------------------------------------------------
-- 3.  Seed Items we CAN produce
-- -----------------------------------------------------------------------------

--      Select dates between current date + max weeks to grow + 1 week and 365 days from now
--      Omit from size 'CUT'
--      Omit Unavailable items
--      Omit Unavailable Item/Size

-- Seed Items that we can produce
SELECT   PLUG_CTL_TYPE        as View_Control_Type
        ,MONDAY_DATE          as Ready_Date
        ,MONDAY_DATE_CYYMMDD  as Ready_Date_7
        ,SowDate(IMITEM,IMSIZE,MONDAY_DATE)
                              as SowDate
        ,IMITEM               as Item_Number
        ,IMSIZE               as Item_Size
        ,IMDES1               as Item_Description
        ,IMLOOK               as Item_Sort
        ,int(500)             as Quantity_Available
        ,current Timestamp    as Retrieved_Time

FROM      MONDAYS
   ,      Kube_Pak_Plugs_From_Seed join Inventory_View_Control_File on IMSOWC = PLUG_CTL_CODE

WHERE   MONDAY_DATE between current date and current date + 365 days
  and   (IMITEM, MONDAY_DATE)         not in (Select AVITEM, DATEFLD from Unavailable_items_400)
  and   (IMITEM, IMSIZE, MONDAY_DATE) not in (Select AVITEM, AVSIZE, DATEFLD from Unavailable_item_Size_400)
  and   SowDate(IMITEM,IMSIZE,MONDAY_DATE) >= max(NEXT_SOW_DATE_SEED,HOLD_SOW_DATE_SEED)


