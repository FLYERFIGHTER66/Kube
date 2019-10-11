CREATE OR REPLACE VIEW TGMSDATA.FINISHED_AVAILABILITY AS

 select HSSNCD as Season_Code
    ,   HSSEAS as Season
    ,   HLLIST as Order_List
    ,   HLDESC as List_Description
    ,   OLSEQ# as List_Sequence
    ,   OLLOOK as List_Alpha
    ,   IMITEM as Item
    ,   IMSIZE as Size
    ,   IMDES1 as Item_Description
    ,   IMQTOH - IMQTAL as Available_Qty
    ,   IMSEL1 as Price_Delivered_in_NJ
    ,   IMSEL2 as Price_Delivered_out_of_State
    ,   IMSEL3 as Price_Picked_up
    ,   IMSEL4 as Price_MUMS_Truckload_NJ
    ,   IMSEL5 as Price_MUMS_Truckload_out_of_State
    ,   IMSEL5 as Price_FlowerTent
    ,   OLRDYC as Ready_color
    ,   OLNOTE as Item_Note

from FMORLSEAS  join FMORLH on  HSLIST = HLLIST
                join FMORLS on  HSLIST = OLLIST
                join FMINVT on  OLITEM = IMITEM
                            and OLSIZE = IMSIZE

order by HSSNCD, OLLIST, OLSEQ#, OLLOOK;



select  *
from FMORLSEAS  join FMORLH on  HSLIST = HLLIST
                join FMORLS on  HSLIST = OLLIST
                join FMINVT on  OLITEM = IMITEM
                            and OLSIZE = IMSIZE

order by HSSNCD, OLLIST, OLSEQ#, OLLOOK
