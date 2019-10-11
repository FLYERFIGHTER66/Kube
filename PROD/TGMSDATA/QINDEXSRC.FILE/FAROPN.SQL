-- Create Binary Radix index 1 for FAROPN
CREATE INDEX FAROPN_INDEX_00001 ON FAROPN (ARSEQ#, ARCUST, ARINV#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FAROPN_INDEX_00001
LABEL ON INDEX FAROPN_INDEX_00001 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 2 for FAROPN
CREATE INDEX FAROPN_INDEX_00002 ON FAROPN (ARSEQ#, ARCUST, ARTTYP, ARDUE$) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FAROPN_INDEX_00002
LABEL ON INDEX FAROPN_INDEX_00002 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 3 for FAROPN
CREATE INDEX FAROPN_INDEX_00003 ON FAROPN (ARTTYP, ARCUST, ARDUE$) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FAROPN_INDEX_00003
LABEL ON INDEX FAROPN_INDEX_00003 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 4 for FAROPN
CREATE INDEX FAROPN_INDEX_00004 ON FAROPN (ARTTYP, ARDUE$) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FAROPN_INDEX_00004
LABEL ON INDEX FAROPN_INDEX_00004 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 5 for FAROPN
CREATE INDEX FAROPN_INDEX_00005 ON FAROPN (ARSUFF, ARCUST, ARTTYP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FAROPN_INDEX_00005
LABEL ON INDEX FAROPN_INDEX_00005 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 6 for FAROPN
CREATE INDEX FAROPN_INDEX_00006 ON FAROPN (ARSEQ#, ARCUST, ARTTYP, ARINV#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FAROPN_INDEX_00006
LABEL ON INDEX FAROPN_INDEX_00006 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 7 for FAROPN
CREATE INDEX FAROPN_INDEX_00007 ON FAROPN (ARSUFF, ARTTYP, ARCUST, ARINV#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FAROPN_INDEX_00007
LABEL ON INDEX FAROPN_INDEX_00007 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 8 for FAROPN
CREATE INDEX FAROPN_INDEX_00008 ON FAROPN (ARSUFF, ARSEQ#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FAROPN_INDEX_00008
LABEL ON INDEX FAROPN_INDEX_00008 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 9 for FAROPN
CREATE INDEX FAROPN_INDEX_00009 ON FAROPN (ARSEQ#, ARSUFF, ARCUST, ARINV#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FAROPN_INDEX_00009
LABEL ON INDEX FAROPN_INDEX_00009 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 10 for FAROPN
CREATE INDEX FAROPN_INDEX_00010 ON FAROPN (ARINV#, ARCUST, ARTDAT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FAROPN_INDEX_00010
LABEL ON INDEX FAROPN_INDEX_00010 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 11 for FAROPN
CREATE INDEX FAROPN_INDEX_00011 ON FAROPN (ARCUST, ARTTYP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FAROPN_INDEX_00011
LABEL ON INDEX FAROPN_INDEX_00011 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 12 for FAROPN
CREATE INDEX FAROPN_INDEX_00012 ON FAROPN (ARSUFF, ARCUST, ARINV#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FAROPN_INDEX_00012
LABEL ON INDEX FAROPN_INDEX_00012 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 13 for FAROPN
CREATE INDEX FAROPN_INDEX_00013 ON FAROPN (ARDISC, ARSTAT, ARSUFF, ARSEQ#, ARCUST, ARINV#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FAROPN_INDEX_00013
LABEL ON INDEX FAROPN_INDEX_00013 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Encoded vector (not unique) index 14 for FAROPN
CREATE ENCODED VECTOR INDEX FAROPN_INDEX_00014 ON FAROPN (ARCUST) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FAROPN_INDEX_00014
LABEL ON INDEX FAROPN_INDEX_00014 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"

