create or replace view Kube_Pak_Plugs_From_Plugs
  for system name KPPLUGPLG as
  select * from KUBEPAK_PLUG_ITEMS as inv
  where inv.imfrsz not in ('CUT','   ');

select * from Kube_Pak_Plugs_From_Plugs;
