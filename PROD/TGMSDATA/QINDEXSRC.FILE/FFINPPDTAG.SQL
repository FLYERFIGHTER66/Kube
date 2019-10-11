-- Create Binary Radix index 1 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00001 ON FFINPPDTAG (FPINVT, FPPPD#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00001
LABEL ON INDEX FFINPPDTAG_INDEX_00001 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 2 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00002 ON FFINPPDTAG (FPINVT, FPPRTD, FPWEEK) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00002
LABEL ON INDEX FFINPPDTAG_INDEX_00002 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 3 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00003 ON FFINPPDTAG (FPWEEK, FPPRTD) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00003
LABEL ON INDEX FFINPPDTAG_INDEX_00003 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 4 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00004 ON FFINPPDTAG (FPINVT, FPPRTD, FPWEEK, FPPPD#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00004
LABEL ON INDEX FFINPPDTAG_INDEX_00004 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 5 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00005 ON FFINPPDTAG (FPWEEK, FPINVT, FPPRTD) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00005
LABEL ON INDEX FFINPPDTAG_INDEX_00005 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 6 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00006 ON FFINPPDTAG (FPBAT#, FPPPD#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00006
LABEL ON INDEX FFINPPDTAG_INDEX_00006 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 7 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00007 ON FFINPPDTAG (FPWEEK, FPBAT#, FPCUST) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00007
LABEL ON INDEX FFINPPDTAG_INDEX_00007 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 8 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00008 ON FFINPPDTAG (FPPRTD, FPPPD#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00008
LABEL ON INDEX FFINPPDTAG_INDEX_00008 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 9 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00009 ON FFINPPDTAG (FPWEEK, FPITEM, FPSIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00009
LABEL ON INDEX FFINPPDTAG_INDEX_00009 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 10 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00010 ON FFINPPDTAG (FPBAT#, FPINVT, FPWEEK, FPSIZE, FPCUST, FPITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00010
LABEL ON INDEX FFINPPDTAG_INDEX_00010 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 11 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00011 ON FFINPPDTAG (FPINVT, FPPRTD, FPPPD#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00011
LABEL ON INDEX FFINPPDTAG_INDEX_00011 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 12 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00012 ON FFINPPDTAG (FPSIZE, FPITEM, FPPLTG, FPCUST, FPTIMESTAMP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00012
LABEL ON INDEX FFINPPDTAG_INDEX_00012 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 13 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00013 ON FFINPPDTAG (FPPRTD, FPINVT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00013
LABEL ON INDEX FFINPPDTAG_INDEX_00013 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 14 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00014 ON FFINPPDTAG (FPSIZE, FPINVT, FPITEM, FPPLTG, FPCUST, FPTIMESTAMP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00014
LABEL ON INDEX FFINPPDTAG_INDEX_00014 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 15 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00015 ON FFINPPDTAG (FPSIZE, FPINVT, FPITEM, FPPLTG, FPTIMESTAMP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00015
LABEL ON INDEX FFINPPDTAG_INDEX_00015 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 16 for FFINPPDTAG
CREATE INDEX FFINPPDTAG_INDEX_00016 ON FFINPPDTAG (FPSIZE, FPINVT, FPWEEK, FPITEM, FPPLTG, FPCUST, FPTIMESTAMP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00016
LABEL ON INDEX FFINPPDTAG_INDEX_00016 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Encoded vector (not unique) index 17 for FFINPPDTAG
CREATE ENCODED VECTOR INDEX FFINPPDTAG_INDEX_00017 ON FFINPPDTAG (FPWEEK) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FFINPPDTAG_INDEX_00017
LABEL ON INDEX FFINPPDTAG_INDEX_00017 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"

