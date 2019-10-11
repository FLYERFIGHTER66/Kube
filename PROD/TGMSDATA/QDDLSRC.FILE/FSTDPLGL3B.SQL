create or replace view Kube_Pak_Standard_Plug_Inventory_L3B for system name FSTDPLGL3B as
-- -----------------------------------------------------------------------------
-- 3.  Seed Items (From Transplant) we CAN produce
-- -----------------------------------------------------------------------------

SELECT   PLUG_CTL_TYPE        as View_Control_Type
        ,MONDAY_DATE          as Ready_Date
        ,MONDAY_DATE_CYYMMDD  as Ready_Date_7
        ,SowDate(itm.IMITEM,itm.IMSIZE,MONDAY_DATE)
                              as SowDate
        ,itm.IMITEM           as Item_Number
        ,itm.IMSIZE           as Item_Size
        ,itm.IMDES1           as Item_Description
        ,itm.IMLOOK           as Item_Sort
        ,int(500)             as Quantity_Available
        ,current Timestamp    as Retrieved_Time

FROM    MONDAYS
   ,    Kube_Pak_Plugs_From_Plugs   as itm
   join Inventory_View_Control_File as ivc      on  itm.IMSOWC = ivc.PLUG_CTL_CODE
   join FMINVT                      as frm      on  itm.IMITEM = frm.IMITEM
                                                and itm.IMFRSZ = frm.IMSIZE

WHERE   MONDAY_DATE between current date and current date + 365 days
  and   (itm.IMITEM, MONDAY_DATE)             not in (Select AVITEM, DATEFLD from Unavailable_items_400)
  and   (itm.IMITEM, itm.IMSIZE, MONDAY_DATE) not in (Select AVITEM, AVSIZE, DATEFLD from Unavailable_item_Size_400)
  and   SowDate(frm.IMITEM,frm.IMSIZE,SowDate(itm.IMITEM,itm.IMSIZE,MONDAY_DATE))  >= max(NEXT_SOW_DATE_SEED,HOLD_SOW_DATE_SEED)
;
