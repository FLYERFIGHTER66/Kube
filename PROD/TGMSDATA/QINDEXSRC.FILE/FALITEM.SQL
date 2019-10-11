-- 11/16/2018
-- Create Binary Radix index 1 for FALITEM
CREATE INDEX FALITEM_INDEX_00001 ON FALITEM (AIOSEQ, AIORD#, AIQTOA) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FALITEM_INDEX_00001
LABEL ON INDEX FALITEM_INDEX_00001 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 2 for FALITEM
CREATE INDEX FALITEM_INDEX_00002 ON FALITEM (AISIZE, AIORD#, AISOWD, AICRDY, AIOSEQ, AIITEM, AIQTOA) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FALITEM_INDEX_00002
LABEL ON INDEX FALITEM_INDEX_00002 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 3 for FALITEM
CREATE INDEX FALITEM_INDEX_00003 ON FALITEM (AICRDY, AIQTOA) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FALITEM_INDEX_00003
LABEL ON INDEX FALITEM_INDEX_00003 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 4 for FALITEM
CREATE INDEX FALITEM_INDEX_00004 ON FALITEM (AICRDY, AISHPD, AIQTOA) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FALITEM_INDEX_00004
LABEL ON INDEX FALITEM_INDEX_00004 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 5 for FALITEM
CREATE INDEX FALITEM_INDEX_00005 ON FALITEM (AIQTOA) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FALITEM_INDEX_00005
LABEL ON INDEX FALITEM_INDEX_00005 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 6 for FALITEM
CREATE INDEX FALITEM_INDEX_00006 ON FALITEM (AIGLOC, AIORD#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FALITEM_INDEX_00006
LABEL ON INDEX FALITEM_INDEX_00006 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 7 for FALITEM
CREATE INDEX FALITEM_INDEX_00007 ON FALITEM (AIOSEQ, AIORD#, AICRDY) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FALITEM_INDEX_00007
LABEL ON INDEX FALITEM_INDEX_00007 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 8 for FALITEM
CREATE INDEX FALITEM_INDEX_00008 ON FALITEM (AICUST, AIITEM, AICRDY) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FALITEM_INDEX_00008
LABEL ON INDEX FALITEM_INDEX_00008 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 9 for FALITEM
CREATE INDEX FALITEM_INDEX_00009 ON FALITEM (AICUST, AIQTOA) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FALITEM_INDEX_00009
LABEL ON INDEX FALITEM_INDEX_00009 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 10 for FALITEM
CREATE INDEX FALITEM_INDEX_00010 ON FALITEM (AISOWD, AICRDY, AISIZE, AIITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FALITEM_INDEX_00010
LABEL ON INDEX FALITEM_INDEX_00010 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 11 for FALITEM
CREATE INDEX FALITEM_INDEX_00011 ON FALITEM (AISHPD, AICRDY) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FALITEM_INDEX_00011
LABEL ON INDEX FALITEM_INDEX_00011 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 12 for FALITEM
CREATE INDEX FALITEM_INDEX_00012 ON FALITEM (AIITEM, AICRDY) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FALITEM_INDEX_00012
LABEL ON INDEX FALITEM_INDEX_00012 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 13 for FALITEM
CREATE INDEX FALITEM_INDEX_00013 ON FALITEM (AIORD#, AICRDY) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FALITEM_INDEX_00013
LABEL ON INDEX FALITEM_INDEX_00013 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"

