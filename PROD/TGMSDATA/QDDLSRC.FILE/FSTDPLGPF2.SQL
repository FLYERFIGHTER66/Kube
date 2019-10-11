-- FSTDPLGPF2 is a summary PF of FSTDPLGL2C & FSTDPLGL4A (It will replace these views in the Kube_Pak_Standard_Plug_Inventory view.

create or replace table Kube_Pak_Standard_Plug_Inventory_Stat2 for system name FSTDPLGPF2 as
(Select * from FSTDPLGL4A) WITH NO DATA ;
