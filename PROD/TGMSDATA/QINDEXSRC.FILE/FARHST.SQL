-- Create Binary Radix index 1 for FARHST
CREATE INDEX FARHST_INDEX_00001 ON FARHST (HSFIL2, HSCUST, HSCRCD) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FARHST_INDEX_00001
LABEL ON INDEX FARHST_INDEX_00001 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 2 for FARHST
CREATE INDEX FARHST_INDEX_00002 ON FARHST (HSCUST, HSFIL2, HSCRC#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FARHST_INDEX_00002
LABEL ON INDEX FARHST_INDEX_00002 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"

