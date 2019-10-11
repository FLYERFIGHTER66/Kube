create or replace view Kube_Pak_Standard_Plug_Inventory_L1A FOR system name FSTDPLGL1A as
-- -----------------------------------------------------------------------
-- 1. Currently Available
-- -----------------------------------------------------------------------

-- A. Full Trays Ready Bay
SELECT
         PLUG_CTL_TYPE         as View_Control_Type
        ,ready_bay_week        as Ready_Date
        ,date7(ready_bay_week) as Ready_Date_7
        ,sowDate(LRITEM,LRSIZE,ready_bay_week)
                               as SowDate
        ,LRITEM                as Item_Number
        ,LRSIZE                as Item_Size
        ,IMDES1                as Item_Description
        ,IMLOOK                as Item_Sort
        ,int(sum(LRQTAV))      as Quantity_Available
        ,current Timestamp     as Retrieved_Time
FROM    MONDAYS, FDLOTRD,  KUBEPAK_PLUG_ITEMS, Inventory_View_Control_File
WHERE   LRITEM=IMITEM
  and   LRSIZE=IMSIZE
  and   LRCRDY=MONDAY_DATE_CYYMMDD
  and   LRCUST < 999990
  and   LRGLOC = 'R'
  and   LRQTAV > 0
  and   IMSOWC = PLUG_CTL_CODE
GROUP BY PLUG_CTL_TYPE, MONDAY_DATE, MONDAY_DATE_CYYMMDD, LRITEM, LRCRDY, LRSIZE, IMDES1, IMLOOK

