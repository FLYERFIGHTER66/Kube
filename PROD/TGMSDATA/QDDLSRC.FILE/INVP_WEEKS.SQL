CREATE OR REPLACE VIEW
TGMSDATA.INVP_WEEKS AS

select MONDAY_WEEK,
Item_Number, Item_Size, Item_Description
, Quantity_Available as Week_01_QTY
, 0                  as Week_02_QTY
, 0                  as Week_03_QTY
, 0                  as Week_04_QTY
, 0                  as Week_05_QTY
, 0                  as Week_06_QTY
, 0                  as Week_07_QTY
, 0                  as Week_08_QTY
, 0                  as Week_09_QTY
, 0                  as Week_10_QTY
from Inv_Plugs_Ready_union_Spec_w_holdback join mondays
on Ready_date = MONDAY_DATE
where monday_date > current date + (00*7) days
  and monday_date < current date + (01*7) days

UNION

select MONDAY_WEEK,
Item_Number, Item_Size, Item_Description
, 0                  as Week_01_QTY
, Quantity_Available as Week_02_QTY
, 0                  as Week_03_QTY
, 0                  as Week_04_QTY
, 0                  as Week_05_QTY
, 0                  as Week_06_QTY
, 0                  as Week_07_QTY
, 0                  as Week_08_QTY
, 0                  as Week_09_QTY
, 0                  as Week_10_QTY
from Inv_Plugs_Ready_union_Spec_w_holdback join mondays
on Ready_date = MONDAY_DATE
where monday_date > current date + (01*7) days
  and monday_date < current date + (02*7) days

UNION

select MONDAY_WEEK,
Item_Number, Item_Size, Item_Description
, 0                  as Week_01_QTY
, 0                  as Week_02_QTY
, Quantity_Available as Week_03_QTY
, 0                  as Week_04_QTY
, 0                  as Week_05_QTY
, 0                  as Week_06_QTY
, 0                  as Week_07_QTY
, 0                  as Week_08_QTY
, 0                  as Week_09_QTY
, 0                  as Week_10_QTY
from Inv_Plugs_Ready_union_Spec_w_holdback join mondays
on Ready_date = MONDAY_DATE
where monday_date > current date + (02*7) days
  and monday_date < current date + (03*7) days

UNION

select MONDAY_WEEK,
Item_Number, Item_Size, Item_Description
, 0                  as Week_01_QTY
, 0                  as Week_02_QTY
, 0                  as Week_03_QTY
, Quantity_Available as Week_04_QTY
, 0                  as Week_05_QTY
, 0                  as Week_06_QTY
, 0                  as Week_07_QTY
, 0                  as Week_08_QTY
, 0                  as Week_09_QTY
, 0                  as Week_10_QTY
from Inv_Plugs_Ready_union_Spec_w_holdback join mondays
on Ready_date = MONDAY_DATE
where monday_date > current date + (03*7) days
  and monday_date < current date + (04*7) days

UNION

select MONDAY_WEEK,
Item_Number, Item_Size, Item_Description
, 0                  as Week_01_QTY
, 0                  as Week_02_QTY
, 0                  as Week_03_QTY
, 0                  as Week_04_QTY
, Quantity_Available as Week_05_QTY
, 0                  as Week_06_QTY
, 0                  as Week_07_QTY
, 0                  as Week_08_QTY
, 0                  as Week_09_QTY
, 0                  as Week_10_QTY
from Inv_Plugs_Ready_union_Spec_w_holdback join mondays
on Ready_date = MONDAY_DATE
where monday_date > current date + (04*7) days
  and monday_date < current date + (05*7) days

UNION

select MONDAY_WEEK,
Item_Number, Item_Size, Item_Description
, 0                  as Week_01_QTY
, 0                  as Week_02_QTY
, 0                  as Week_03_QTY
, 0                  as Week_04_QTY
, 0                  as Week_05_QTY
, Quantity_Available as Week_06_QTY
, 0                  as Week_07_QTY
, 0                  as Week_08_QTY
, 0                  as Week_09_QTY
, 0                  as Week_10_QTY
from Inv_Plugs_Ready_union_Spec_w_holdback join mondays
on Ready_date = MONDAY_DATE
where monday_date > current date + (05*7) days
  and monday_date < current date + (06*7) days

UNION

select MONDAY_WEEK,
Item_Number, Item_Size, Item_Description
, 0                  as Week_01_QTY
, 0                  as Week_02_QTY
, 0                  as Week_03_QTY
, 0                  as Week_04_QTY
, 0                  as Week_05_QTY
, 0                  as Week_06_QTY
, Quantity_Available as Week_07_QTY
, 0                  as Week_08_QTY
, 0                  as Week_09_QTY
, 0                  as Week_10_QTY
from Inv_Plugs_Ready_union_Spec_w_holdback join mondays
on Ready_date = MONDAY_DATE
where monday_date > current date + (06*7) days
  and monday_date < current date + (07*7) days

UNION

select MONDAY_WEEK,
Item_Number, Item_Size, Item_Description
, 0                  as Week_01_QTY
, 0                  as Week_02_QTY
, 0                  as Week_03_QTY
, 0                  as Week_04_QTY
, 0                  as Week_05_QTY
, 0                  as Week_06_QTY
, 0                  as Week_07_QTY
, Quantity_Available as Week_08_QTY
, 0                  as Week_09_QTY
, 0                  as Week_10_QTY
from Inv_Plugs_Ready_union_Spec_w_holdback join mondays
on Ready_date = MONDAY_DATE
where monday_date > current date + (07*7) days
  and monday_date < current date + (08*7) days

UNION

select MONDAY_WEEK,
Item_Number, Item_Size, Item_Description
, 0                  as Week_01_QTY
, 0                  as Week_02_QTY
, 0                  as Week_03_QTY
, 0                  as Week_04_QTY
, 0                  as Week_05_QTY
, 0                  as Week_06_QTY
, 0                  as Week_07_QTY
, 0                  as Week_08_QTY
, Quantity_Available as Week_09_QTY
, 0                  as Week_10_QTY
from Inv_Plugs_Ready_union_Spec_w_holdback join mondays
on Ready_date = MONDAY_DATE
where monday_date > current date + (08*7) days
  and monday_date < current date + (09*7) days

UNION

select MONDAY_WEEK,
Item_Number, Item_Size, Item_Description
, 0                  as Week_01_QTY
, 0                  as Week_02_QTY
, 0                  as Week_03_QTY
, 0                  as Week_04_QTY
, 0                  as Week_05_QTY
, 0                  as Week_06_QTY
, 0                  as Week_07_QTY
, 0                  as Week_08_QTY
, 0                  as Week_09_QTY
, Quantity_Available as Week_10_QTY
from Inv_Plugs_Ready_union_Spec_w_holdback join mondays
on Ready_date = MONDAY_DATE
where monday_date > current date + (09*7) days
  and monday_date < current date + (10*7) days

