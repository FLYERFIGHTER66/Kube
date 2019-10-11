create or replace view Kube_Pak_Standard_Plug_Inventory for system name FSTDPLGINV as
-- -----------------------------------------------------------------------
-- 1. Currently Available
-- -----------------------------------------------------------------------

-- A. Full Trays Ready Bay
SELECT * FROM FSTDPLGL1A
-- B. Partial Trays Ready Bay
union
SELECT * FROM FSTDPLGL1B
-- C. Future Lot Inventory Full Trays
union
SELECT * FROM FSTDPLGL1C

-- -----------------------------------------------------------------------------
-- 2. Projected Available
-- -----------------------------------------------------------------------------
union
Select * from FSTDPLGPF1
union
Select * from FSTDPLGPF2
-- -------------------------------------------------------------------------------
-- END OF SQL SOURCE
-- -------------------------------------------------------------------------------

