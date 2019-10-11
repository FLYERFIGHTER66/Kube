drop Table Kube_Pak_Plugs_All_Lots;
drop Table FPLUGLOTS;

-- -----------------------------------------------------------------------------

create Table Kube_Pak_Plugs_All_Lots for system name FPLUGLOTS as
(SELECT  MONDAY_DATE            as Ready_Date
        ,MONDAY_DATE_CYYMMDD    as Ready_Date_7
        ,SowDate(IMITEM,IMSIZE,MONDAY_DATE)
                                as SowDate
        ,IMITEM                 as Item_Number
        ,IMSIZE                 as Item_Size
        ,IMDES1                 as Item_Description
        ,IMLOOK                 as Item_Sort
        ,IMSOWC                 as Sow_Code
        ,IMFRSZ                 as From_Size
        ,SZPERC                 as Seed_or_Cut_per_Cell
        ,SZSALE                 as Saleable_Cells
        ,current timestamp      as Retrieved_Time
FROM      MONDAYS
   ,      KubePak_Plug_Items
join      FMSIZE on IMSIZE = SZCODE
WHERE Monday_Date between current date - 70 days and current date + 375 days )
WITH DATA;

-- -----------------------------------------------------------------------------

DROP    INDEX FPLUGLOTS_INDEX_00001;
CREATE  INDEX FPLUGLOTS_INDEX_00001 ON Kube_Pak_Plugs_All_Lots
(READY_DATE ASC, ITEM_NUMBER ASC, ITEM_SIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

DROP    INDEX FPLUGLOTS_INDEX_00002;
CREATE  INDEX FPLUGLOTS_INDEX_00002 ON Kube_Pak_Plugs_All_Lots
(READY_DATE ASC, ITEM_SORT ASC, SOW_CODE ASC) UNIT ANY  KEEP IN MEMORY NO ;

DROP    INDEX FPLUGLOTS_INDEX_00003;
CREATE  INDEX FPLUGLOTS_INDEX_00003 ON Kube_Pak_Plugs_All_Lots
(SOWDATE ASC, ITEM_NUMBER ASC, ITEM_SIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

DROP    INDEX FPLUGLOTS_INDEX_00004;
CREATE  INDEX FPLUGLOTS_INDEX_00004 ON Kube_Pak_Plugs_All_Lots
(SOWDATE ASC, ITEM_SORT ASC, SOW_CODE ASC) UNIT ANY  KEEP IN MEMORY NO ;

DROP    INDEX FPLUGLOTS_INDEX_00005;
CREATE  INDEX FPLUGLOTS_INDEX_00005 ON Kube_Pak_Plugs_All_Lots
(ITEM_SORT ASC, READY_DATE ASC, ITEM_NUMBER ASC, ITEM_SIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

DROP    INDEX FPLUGLOTS_INDEX_00006;
CREATE  INDEX FPLUGLOTS_INDEX_00006 ON Kube_Pak_Plugs_All_Lots
(ITEM_SORT ASC, SOWDATE ASC, ITEM_NUMBER ASC, ITEM_SIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

DROP    INDEX FPLUGLOTS_INDEX_00007;
CREATE  INDEX FPLUGLOTS_INDEX_00007 ON Kube_Pak_Plugs_All_Lots
(ITEM_NUMBER ASC, ITEM_SIZE ASC, READY_DATE ASC) UNIT ANY  KEEP IN MEMORY NO ;

DROP    INDEX FPLUGLOTS_INDEX_00008;
CREATE  INDEX FPLUGLOTS_INDEX_00008 ON Kube_Pak_Plugs_All_Lots
(ITEM_NUMBER ASC, ITEM_SIZE ASC, SOWDATE ASC) UNIT ANY  KEEP IN MEMORY NO ;



