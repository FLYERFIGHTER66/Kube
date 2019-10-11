create or replace view Kube_Pak_Standard_Plug_Inventory_L1C for system name FSTDPLGL1C as
-- -----------------------------------------------------------------------
-- 1. Currently Available
-- -----------------------------------------------------------------------

-- C. Future Lot Inventory Full Trays
SELECT
        PLUG_CTL_TYPE         as View_Control_Type
        ,MONDAY_DATE          as Ready_Date
        ,MONDAY_DATE_CYYMMDD  as Ready_Date_7
        ,SowDate(LRITEM,LRSIZE,MONDAY_DATE)
                              as SowDate
        ,LRITEM               as Item_Number
        ,LRSIZE               as Item_Size
        ,IMDES1               as Item_Description
        ,IMLOOK               as Item_Sort
        ,int(sum(LRQTAV)) - 1 as Quantity_Available
        ,current Timestamp    as Retrieved_Time
FROM    MONDAYS, FDLOTRD,  KUBEPAK_PLUG_ITEMS, Inventory_View_Control_File
WHERE   LRITEM=IMITEM
  and   LRSIZE=IMSIZE
  and   LRCRDY=MONDAY_DATE_CYYMMDD
  and   MONDAY_DATE > ready_bay_week
  and   LRCUST < 999990
  and   LRGLOC = ' '
  and   LRQTAV > 0
  and   IMSOWC = PLUG_CTL_CODE
GROUP BY PLUG_CTL_TYPE, MONDAY_DATE, MONDAY_DATE_CYYMMDD, LRITEM, LRCRDY, LRSIZE, IMDES1, IMLOOK

