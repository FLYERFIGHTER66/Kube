--drop table lstyr1801.GL_data_from_details_and_consolidation;
--create or replace table lstyr1801.GL_data_from_details_and_consolidation for system name GL_DATE as  (;

--select * from lstyr1801.GL_data_from_details_and_consolidation;
delete from lstyr1801.GL_data_from_details_and_consolidation;

insert into lstyr1801.GL_data_from_details_and_consolidation (
--non-consolidated G/L
SELECT 'A/R' as Trans_Type
, det.GTACCT as GL_Account
, det.GTDOL$ as GL_Dollars
, det.GTTDAT as GL_Transaction_Date
, det.GTSRCE as GL_Source
, det.GTJEDS as GL_Description
, coalesce(cus1.cmstst,'NJ') as GL_State
, coalesce(cus1.cmzip,'83501') as GL_Zip
from
S105R9YM.lstyr1801.fgldet as det left outer join S105R9YM.TGMSDATA.fmcust as cus1 on substr(det.gtjeds,20,11) = 'Cust '||right('000000'||trim(char(cus1.cmcust)),6)
where det.gtcon# = 0 and det.gtacct between 30000000 and 39999999
and det.gtacct not in (30900000,32000000,33500000,34000000,35000000,36000000)
);

--Consolidated G/L
--INV;
insert into lstyr1801.GL_data_from_details_and_consolidation (
SELECT 'INV' as Trans_Type
, inv.GTACCT as GL_Account
, inv.GTDOL$ as GL_Dollars
, inv.GTTDAT as GL_Transaction_Date
, inv.GTSRCE as GL_Source
, inv.GTJEDS as GL_Description
, coalesce(i1.whshst,'NJ') as GL_State
, coalesce(i1.whshzp,'83501') as GL_Zip
from
S105R9YM.lstyr1801.fgldcon as inv  left outer join S105R9YM.TGMSDATA.fhordw as i1 on substr(inv.gtjeds,1,10) = 'Inv '||right('000000'||trim(char(i1.whinv#)),6)
where inv.gtacct between 30000000 and 39999999
  and inv.gtacct not in (30900000,32000000,33500000,34000000,35000000,36000000)
  and inv.gtjeds like 'Inv %'
);


--Late Charge
insert into lstyr1801.GL_data_from_details_and_consolidation (
SELECT 'L/C' as Trans_Type
, lat.GTACCT as GL_Account
, lat.GTDOL$ as GL_Dollars
, lat.GTTDAT as GL_Transaction_Date
, lat.GTSRCE as GL_Source
, lat.GTJEDS as GL_Description
, coalesce(i2.whshst,'NJ') as GL_State
, coalesce(i2.whshzp,'83501') as GL_Zip
from
S105R9YM.lstyr1801.fgldcon as lat  left outer join S105R9YM.TGMSDATA.fhordw as i2 on substr(lat.gtjeds,1,15) = 'Late Chg '||right('000000'||trim(char(i2.whinv#)),6)
where lat.gtacct between 30000000 and 39999999
  and lat.gtacct not in (30900000,32000000,33500000,34000000,35000000,36000000)
  and lat.gtjeds like 'Late %'
);

--Credit Memos
insert into lstyr1801.GL_data_from_details_and_consolidation (
SELECT 'C/M' as Trans_Type
, crm.GTACCT as GL_Account
, crm.GTDOL$ as GL_Dollars
, crm.GTTDAT as GL_Transaction_Date
, crm.GTSRCE as GL_Source
, crm.GTJEDS as GL_Description
, coalesce(c1.chshst,'NJ') as GL_State
, coalesce(c1.chshzp,'83501') as GL_Zip
from
S105R9YM.lstyr1801.fgldcon as crm  left outer join S105R9YM.TGMSDATA.fhorcw as c1 on substr(crm.gtjeds,1,10) = 'Crm '||right('000000'||trim(char(c1.chcrm#)),6)
where crm.gtacct between 30000000 and 39999999
  and crm.gtacct not in (30900000,32000000,33500000,34000000,35000000,36000000)
  and crm.gtjeds like 'Crm %'
);

--Adjustments
insert into lstyr1801.GL_data_from_details_and_consolidation (
SELECT 'Adj' as Trans_Type
, adj.GTACCT as GL_Account
, adj.GTDOL$ as GL_Dollars
, adj.GTTDAT as GL_Transaction_Date
, adj.GTSRCE as GL_Source
, adj.GTJEDS as GL_Description
, coalesce(i3.whshst,'NJ') as GL_State
, coalesce(i3.whshzp,'83501') as GL_Zip
from
S105R9YM.lstyr1801.fgldcon as adj  left outer join S105R9YM.TGMSDATA.fhordw as i3 on substr(adj.gtjeds,1,10) = 'Adj '||right('000000'||trim(char(i3.whinv#)),6)
where adj.gtacct between 30000000 and 39999999
  and adj.gtacct not in (30900000,32000000,33500000,34000000,35000000,36000000)
  and adj.gtjeds like 'Adj %'
);

insert into lstyr1801.GL_data_from_details_and_consolidation (
SELECT 'REF' as Trans_Type
, ref.GTACCT as GL_Account
, ref.GTDOL$ as GL_Dollars
, ref.GTTDAT as GL_Transaction_Date
, ref.GTSRCE as GL_Source
, ref.GTJEDS as GL_Description
, coalesce(ven.VMSTST,'NJ') as GL_State
, coalesce(ven.VMZIPD,'83501') as GL_Zip
from
S105R9YM.lstyr1801.fgldcon as ref  left outer join S105R9YM.TGMSDATA.fmvend as ven on substr(ref.gtjeds,1,8) = 'V '||right('000000'||trim(char(ven.vmvend)),6)
where ref.gtacct between 30000000 and 39999999
  and ref.gtacct not in (30900000,32000000,33500000,34000000,35000000,36000000)
  and ref.gtjeds like 'V %'
);

