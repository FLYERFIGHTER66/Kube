Create or replace view Supplier_Inventory_Summary for system name WSSUPINVL2 as

Select Available_Date                   as Available_Date
    , Kube_Pak_Item                     as Kube_Pak_Item
    , Kube_Pak_Size                     as Kube_Pak_Size
    , sum(Supplier_Quantity_Available)  as Supplier_Quantity_Available

from WSSUPINVL1 join Supplier_Defaults on Vendor = Supplier_Name
where Available_Date > current date + Supplier_CutOff_Days days
group by Available_Date
    , Kube_Pak_Item
    , Kube_Pak_Size;
