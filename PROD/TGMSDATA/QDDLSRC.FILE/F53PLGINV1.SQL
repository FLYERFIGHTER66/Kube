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
case when ready_date = wk05 then quantity_available end as wk05,
case when ready_date = wk06 then quantity_available end as wk06,
case when ready_date = wk07 then quantity_available end as wk07,
case when ready_date = wk08 then quantity_available end as wk08,
case when ready_date = wk09 then quantity_available end as wk09,

case when ready_date = wk10 then quantity_available end as wk10,
case when ready_date = wk11 then quantity_available end as wk11,
case when ready_date = wk12 then quantity_available end as wk12,
case when ready_date = wk13 then quantity_available end as wk13,
case when ready_date = wk14 then quantity_available end as wk14,
case when ready_date = wk15 then quantity_available end as wk15,
case when ready_date = wk16 then quantity_available end as wk16,
case when ready_date = wk17 then quantity_available end as wk17,
case when ready_date = wk18 then quantity_available end as wk18,
case when ready_date = wk19 then quantity_available end as wk19,

case when ready_date = wk20 then quantity_available end as wk20,
case when ready_date = wk21 then quantity_available end as wk21,
case when ready_date = wk22 then quantity_available end as wk22,
case when ready_date = wk23 then quantity_available end as wk23,
case when ready_date = wk24 then quantity_available end as wk24,
case when ready_date = wk25 then quantity_available end as wk25,
case when ready_date = wk26 then quantity_available end as wk26,
case when ready_date = wk27 then quantity_available end as wk27,
case when ready_date = wk28 then quantity_available end as wk28,
case when ready_date = wk29 then quantity_available end as wk29,

case when ready_date = wk30 then quantity_available end as wk30,
case when ready_date = wk31 then quantity_available end as wk31,
case when ready_date = wk32 then quantity_available end as wk32,
case when ready_date = wk33 then quantity_available end as wk33,
case when ready_date = wk34 then quantity_available end as wk34,
case when ready_date = wk35 then quantity_available end as wk35,
case when ready_date = wk36 then quantity_available end as wk36,
case when ready_date = wk37 then quantity_available end as wk37,
case when ready_date = wk38 then quantity_available end as wk38,
case when ready_date = wk39 then quantity_available end as wk39,

case when ready_date = wk40 then quantity_available end as wk40,
case when ready_date = wk41 then quantity_available end as wk41,
case when ready_date = wk42 then quantity_available end as wk42,
case when ready_date = wk43 then quantity_available end as wk43,
case when ready_date = wk44 then quantity_available end as wk44,
case when ready_date = wk45 then quantity_available end as wk45,
case when ready_date = wk46 then quantity_available end as wk46,
case when ready_date = wk47 then quantity_available end as wk47,
case when ready_date = wk48 then quantity_available end as wk48,
case when ready_date = wk49 then quantity_available end as wk49,

case when ready_date = wk50 then quantity_available end as wk50,
case when ready_date = wk51 then quantity_available end as wk51,
case when ready_date = wk52 then quantity_available end as wk52,
case when ready_date = wk53 then quantity_available end as wk53

from kube_pak_standard_plug_inventory, fifty_three_weeks
where view_control_type = 'WEB';

