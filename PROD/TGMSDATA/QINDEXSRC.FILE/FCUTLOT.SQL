-- Create Binary Radix index 1 for FCUTLOT
CREATE INDEX FCUTLOT_INDEX_00001 ON FCUTLOT (CLSOWD, CLITEM, CLQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FCUTLOT_INDEX_00001
LABEL ON INDEX FCUTLOT_INDEX_00001 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 2 for FCUTLOT
CREATE INDEX FCUTLOT_INDEX_00002 ON FCUTLOT (CLQTOO) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FCUTLOT_INDEX_00002
LABEL ON INDEX FCUTLOT_INDEX_00002 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 3 for FCUTLOT
CREATE INDEX FCUTLOT_INDEX_00003 ON FCUTLOT (CLSOWD, CLITEM, CLQTOO) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FCUTLOT_INDEX_00003
LABEL ON INDEX FCUTLOT_INDEX_00003 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 4 for FCUTLOT
CREATE INDEX FCUTLOT_INDEX_00004 ON FCUTLOT (CLSOWD, CLVEND, CLSIZE, CLITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FCUTLOT_INDEX_00004
LABEL ON INDEX FCUTLOT_INDEX_00004 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 5 for FCUTLOT
CREATE INDEX FCUTLOT_INDEX_00005 ON FCUTLOT (CLSIZE, CLITEM, CLSOWD) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FCUTLOT_INDEX_00005
LABEL ON INDEX FCUTLOT_INDEX_00005 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 6 for FCUTLOT
CREATE INDEX FCUTLOT_INDEX_00006 ON FCUTLOT (CLSOWD, CLLOOK, CLVEND, CLITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FCUTLOT_INDEX_00006
LABEL ON INDEX FCUTLOT_INDEX_00006 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"

