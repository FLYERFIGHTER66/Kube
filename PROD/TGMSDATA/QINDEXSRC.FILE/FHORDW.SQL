-- Create Binary Radix index 1 for FHORDW
CREATE INDEX FHORDW_INDEX_00001 ON FHORDW (WHINV#, WHTMCD) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDW_INDEX_00001
LABEL ON INDEX FHORDW_INDEX_00001 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 2 for FHORDW
CREATE INDEX FHORDW_INDEX_00002 ON FHORDW (WHTRAT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDW_INDEX_00002
LABEL ON INDEX FHORDW_INDEX_00002 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 3 for FHORDW
CREATE INDEX FHORDW_INDEX_00003 ON FHORDW (WHINDT, WHBLCU, WHINV#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDW_INDEX_00003
LABEL ON INDEX FHORDW_INDEX_00003 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 4 for FHORDW
CREATE INDEX FHORDW_INDEX_00004 ON FHORDW (WHINDT, WHBLCU, WHCUST, WHINV#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDW_INDEX_00004
LABEL ON INDEX FHORDW_INDEX_00004 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 5 for FHORDW
CREATE INDEX FHORDW_INDEX_00005 ON FHORDW (WHBLCU, WHINDT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDW_INDEX_00005
LABEL ON INDEX FHORDW_INDEX_00005 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 6 for FHORDW
CREATE INDEX FHORDW_INDEX_00006 ON FHORDW (WHTDAT, WHTXJU) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDW_INDEX_00006
LABEL ON INDEX FHORDW_INDEX_00006 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 7 for FHORDW
CREATE INDEX FHORDW_INDEX_00007 ON FHORDW (WHTXJU, WHTDAT, WHTAX$) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDW_INDEX_00007
LABEL ON INDEX FHORDW_INDEX_00007 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 8 for FHORDW
CREATE INDEX FHORDW_INDEX_00008 ON FHORDW (WHTAX$, WHTXJU) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDW_INDEX_00008
LABEL ON INDEX FHORDW_INDEX_00008 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Encoded vector (not unique) index 9 for FHORDW
CREATE ENCODED VECTOR INDEX FHORDW_INDEX_00009 ON FHORDW (WHTDAT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDW_INDEX_00009
LABEL ON INDEX FHORDW_INDEX_00009 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Encoded vector (not unique) index 10 for FHORDW
CREATE ENCODED VECTOR INDEX FHORDW_INDEX_00010 ON FHORDW (WHTXJU) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDW_INDEX_00010
LABEL ON INDEX FHORDW_INDEX_00010 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 11 for FHORDW
CREATE INDEX FHORDW_INDEX_00011 ON FHORDW (WHCUST, WHTRDC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDW_INDEX_00011
LABEL ON INDEX FHORDW_INDEX_00011 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 12 for FHORDW
CREATE INDEX FHORDW_INDEX_00012 ON FHORDW (WHTYPE, WHTAX$) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDW_INDEX_00012
LABEL ON INDEX FHORDW_INDEX_00012 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 13 for FHORDW
CREATE INDEX FHORDW_INDEX_00013 ON FHORDW (WHCUST, WHDTAC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDW_INDEX_00013
LABEL ON INDEX FHORDW_INDEX_00013 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"

