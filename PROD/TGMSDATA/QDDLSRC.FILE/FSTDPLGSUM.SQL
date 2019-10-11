create or replace view Kube_Pak_Standard_Plug_Inventory_Summary for system name FSTDPLGSUM as

SELECT    View_Control_Type
        , Ready_Date
        , Ready_Date_7
        , SowDate
        , Item_Number
        , Item_Size
        , Item_Description
        , Item_Sort
        , Sum(Quantity_Available) as Sum_Quantity_Available
FROM    Kube_Pak_Standard_Plug_Inventory
GROUP BY  View_Control_Type
        , Ready_Date
        , Ready_Date_7
        , SowDate
        , Item_Number
        , Item_Size
        , Item_Description
        , Item_Sort
