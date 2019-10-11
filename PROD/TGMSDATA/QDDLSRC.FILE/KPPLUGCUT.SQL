create or replace view Kube_Pak_Plugs_From_Cuttings
  for system name KPPLUGCUT as
  select * from KUBEPAK_PLUG_ITEMS as inv
  where inv.imfrsz = 'CUT';

select * from Kube_Pak_Plugs_From_Cuttings;
