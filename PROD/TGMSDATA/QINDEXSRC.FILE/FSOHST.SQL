-- Create Binary Radix index 1 for FSOHST
CREATE INDEX FSOHST_INDEX_00001 ON FSOHST (SOCUST, SOSIZE, SOSHDT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FSOHST_INDEX_00001
LABEL ON INDEX FSOHST_INDEX_00001 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 2 for FSOHST
CREATE INDEX FSOHST_INDEX_00002 ON FSOHST (SOCUST, SOBLCU) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FSOHST_INDEX_00002
LABEL ON INDEX FSOHST_INDEX_00002 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 3 for FSOHST
CREATE INDEX FSOHST_INDEX_00003 ON FSOHST (SOSIZE, SOCUST, SOITEM, SOORD#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FSOHST_INDEX_00003
LABEL ON INDEX FSOHST_INDEX_00003 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 4 for FSOHST
CREATE INDEX FSOHST_INDEX_00004 ON FSOHST (SOSHDT, SOCUST, SOORD#, SODES1) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FSOHST_INDEX_00004
LABEL ON INDEX FSOHST_INDEX_00004 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 5 for FSOHST
CREATE INDEX FSOHST_INDEX_00005 ON FSOHST (SOSIZE, SOLOOK, SOCUST, SOSHDT, SOITAL, SOITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FSOHST_INDEX_00005
LABEL ON INDEX FSOHST_INDEX_00005 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 6 for FSOHST
CREATE INDEX FSOHST_INDEX_00006 ON FSOHST (SOBLCU, SOSIZE, SOITAL, SOITEM, SODES1, SOSHDT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FSOHST_INDEX_00006
LABEL ON INDEX FSOHST_INDEX_00006 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"

