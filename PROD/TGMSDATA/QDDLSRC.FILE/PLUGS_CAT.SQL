drop view PLUG_ITEMS_IN_CATALOG;

create or replace view PLUG_ITEMS_IN_CATALOG
  for system name PLUGS_CAT as
  select * from fminvt as inv
           join fmsizc as cat on inv.imsize = cat.scsize
  where cat.sccatg = 'PLUG'
    and inv.imstat = 'A'
    and inv.imsowc = ' ';
