create or replace view KUBEPAK_PLUG_ITEMS
  for system name PLUG_ITEMS as
  select * from fminvt as inv
           join fmsizc as cat on inv.imsize = cat.scsize
  where cat.sccatg = 'PLUG'
    and inv.imstat = 'A';

select * from KUBEPAK_PLUG_ITEMS;
