create or replace view Kube_Pak_Standard_Plug_Inventory_L3C for system name FSTDPLGL3C as
-- -----------------------------------------------------------------------------
-- 3.  CUT Items w/out Supp. Inventory
-- -----------------------------------------------------------------------------

SELECT   'Kube-Pak'           as View_Control_Type
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
   ,    Kube_Pak_Plugs_From_Cuttings as itm

WHERE   MONDAY_DATE between current date and current date + 365 days
  and   (itm.IMITEM, MONDAY_DATE)             not in (Select AVITEM, DATEFLD from Unavailable_items_400)
  and   (itm.IMITEM, itm.IMSIZE, MONDAY_DATE) not in (Select AVITEM, AVSIZE, DATEFLD from Unavailable_item_Size_400)
  and   SowDate(itm.IMITEM,itm.IMSIZE,MONDAY_DATE)  >= max(Next_Sow_Date_Cut, Hold_Sow_Date_Cut)
  and   itm.IMFRSZ = 'CUT'
  and   itm.IMVEND not in (select distinct  vendor_number from Supplier_Inventory)
  ;
