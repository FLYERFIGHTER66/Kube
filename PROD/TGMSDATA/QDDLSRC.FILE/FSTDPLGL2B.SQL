create or replace view Kube_Pak_Standard_Plug_Inventory_L2B for system name FSTDPLGL2B as

-- -----------------------------------------------------------------------------
-- 2.  Currently Unavailable Items
-- -----------------------------------------------------------------------------
--  UNAVAILABLE PLUG ITEMS
    --    Past Sow (NEXT_SOW_DATE_xxxx)

  SELECT PLUG_CTL_TYPE          as View_Control_Type
        ,MONDAY_DATE            as Ready_Date
        ,MONDAY_DATE_CYYMMDD    as Ready_Date_7
        ,SowDate(IMITEM, IMSIZE, MONDAY_DATE)
                                as SowDate
        ,IMITEM                 as Item_Number
        ,IMSIZE                 as Item_Size
        ,IMDES1                 as Item_Description
        ,IMLOOK                 as Item_Sort
        , 0                     as Quantity_Available
        ,current Timestamp      as Retrieved_Time

FROM      MONDAYS
   ,      KubePak_Plug_Items join Inventory_View_Control_File on IMSOWC = PLUG_CTL_CODE

WHERE   MONDAY_DATE between ready_bay_week and ready_bay_week + 365 days
  and (  (IMFRSZ =  'CUT' and SowDate(IMITEM, IMSIZE, MONDAY_DATE)  < max(NEXT_SOW_DATE_CUT,HOLD_SOW_DATE_CUT))
      or (IMFRSZ =  '   ' and SowDate(IMITEM, IMSIZE, MONDAY_DATE)  < max(NEXT_SOW_DATE_SEED,HOLD_SOW_DATE_SEED))
      or (IMFRSZ <> 'CUT' and IMFRSZ <> '   '
                          and SowDate(IMITEM, IMFRSZ, SowDate(IMITEM, IMSIZE, MONDAY_DATE))
                                                                    < max(NEXT_SOW_DATE_SEED,HOLD_SOW_DATE_SEED)) );
