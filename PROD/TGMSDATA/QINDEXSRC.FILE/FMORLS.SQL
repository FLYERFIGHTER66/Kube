-- Create Binary Radix index 1 for FMORLS
CREATE INDEX FMORLS_INDEX_00001 ON FMORLS (OLSIZE, OLITEM, OLLIST) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMORLS_INDEX_00001
LABEL ON INDEX FMORLS_INDEX_00001 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 2 for FMORLS
CREATE INDEX FMORLS_INDEX_00002 ON FMORLS (OLSTAT, OLLIST, OLITEM, OLSIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMORLS_INDEX_00002
LABEL ON INDEX FMORLS_INDEX_00002 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 3 for FMORLS
CREATE INDEX FMORLS_INDEX_00003 ON FMORLS (OLLIST, OLSIZE, OLITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMORLS_INDEX_00003
LABEL ON INDEX FMORLS_INDEX_00003 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 4 for FMORLS
CREATE INDEX FMORLS_INDEX_00004 ON FMORLS (OLSTAT, OLSIZE, OLITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMORLS_INDEX_00004
LABEL ON INDEX FMORLS_INDEX_00004 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 5 for FMORLS
CREATE INDEX FMORLS_INDEX_00005 ON FMORLS (OLSTAT, OLLIST, OLSEQ#, OLLOOK) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMORLS_INDEX_00005
LABEL ON INDEX FMORLS_INDEX_00005 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Encoded vector (not unique) index 6 for FMORLS
CREATE ENCODED VECTOR INDEX FMORLS_INDEX_00006 ON FMORLS (OLLIST, OLITEM, OLSIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMORLS_INDEX_00006
LABEL ON INDEX FMORLS_INDEX_00006 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Encoded vector (not unique) index 7 for FMORLS
CREATE ENCODED VECTOR INDEX FMORLS_INDEX_00007 ON FMORLS (OLLIST, OLSIZE, OLITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMORLS_INDEX_00007
LABEL ON INDEX FMORLS_INDEX_00007 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Encoded vector (not unique) index 8 for FMORLS
CREATE ENCODED VECTOR INDEX FMORLS_INDEX_00008 ON FMORLS (OLITEM, OLSIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMORLS_INDEX_00008
LABEL ON INDEX FMORLS_INDEX_00008 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 9 for FMORLS
CREATE INDEX FMORLS_INDEX_00009 ON FMORLS (OLSTAT, OLLIST, OLSIZE, OLITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMORLS_INDEX_00009
LABEL ON INDEX FMORLS_INDEX_00009 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"

