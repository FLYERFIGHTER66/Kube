-- Create Binary Radix index 1 for FARLCD
CREATE INDEX FARLCD_INDEX_00001 ON FARLCD (ARCUST, ARINV#, ARLMLC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FARLCD_INDEX_00001
LABEL ON INDEX FARLCD_INDEX_00001 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 2 for FARLCD
CREATE INDEX FARLCD_INDEX_00002 ON FARLCD (ARCUST, ARLMLC, ARINV#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FARLCD_INDEX_00002
LABEL ON INDEX FARLCD_INDEX_00002 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"

