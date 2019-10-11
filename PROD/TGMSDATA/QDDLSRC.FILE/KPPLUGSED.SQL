create or replace view Kube_Pak_Plugs_From_Seed
  for system name KPPLUGSED as
  select * from KUBEPAK_PLUG_ITEMS as inv
  where inv.imfrsz = '   ';

select * from Kube_Pak_Plugs_From_Seed;
