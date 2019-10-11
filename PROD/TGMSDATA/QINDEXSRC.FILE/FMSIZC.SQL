-- Create Binary Radix index 1 for FMSIZC
CREATE INDEX FMSIZC_INDEX_00001 ON FMSIZC (SCCATG, SCSIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMSIZC_INDEX_00001
LABEL ON INDEX FMSIZC_INDEX_00001 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 2 for FMSIZC
CREATE INDEX FMSIZC_INDEX_00002 ON FMSIZC (SCSIZE, SCCATG) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMSIZC_INDEX_00002
LABEL ON INDEX FMSIZC_INDEX_00002 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"

