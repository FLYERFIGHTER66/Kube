create or replace view PLUG_INVENTORY_JOIN_53WEEKS for system name F53PLGINV1 as

select
Item_Number,
Item_Size,
Item_Description,
Item_Sort,

case when ready_date = wk00 then quantity_available end as wk00,
case when ready_date = wk01 then quantity_available end as wk01,
case when ready_date = wk02 then quantity_available end as wk02,
case when ready_date = wk03 then quantity_available end as wk03,
case when ready_date = wk04 then quantity_available end as wk04,
case when ready_date = wk05 then quantity_available end as wk05

from kube_pak_standard_plug_inventory, Next_five_weeks
where view_control_type = 'WEB';

