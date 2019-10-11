-- Create Binary Radix index 1 for FCALEN
CREATE INDEX FCALEN_INDEX_00001 ON FCALEN (CL#Y, CLCYMD) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FCALEN_INDEX_00001
LABEL ON INDEX FCALEN_INDEX_00001 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 2 for FCALEN
CREATE INDEX FCALEN_INDEX_00002 ON FCALEN (CLCENT, CLCYMD) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FCALEN_INDEX_00002
LABEL ON INDEX FCALEN_INDEX_00002 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 3 for FCALEN
CREATE INDEX FCALEN_INDEX_00003 ON FCALEN (CLDATE, CLCYMD) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FCALEN_INDEX_00003
LABEL ON INDEX FCALEN_INDEX_00003 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 4 for FCALEN
CREATE INDEX FCALEN_INDEX_00004 ON FCALEN (CLCENT, CL#Y, CLCYMD) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FCALEN_INDEX_00004
LABEL ON INDEX FCALEN_INDEX_00004 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"

