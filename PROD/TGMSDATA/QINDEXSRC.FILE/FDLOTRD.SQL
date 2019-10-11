-- Create Binary Radix index 1 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00001 ON FDLOTRD (LRCUST, LRSIZE, LRCRDY, LRSOWD, LRITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00001
LABEL ON INDEX FDLOTRD_INDEX_00001 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 2 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00002 ON FDLOTRD (LRGLOC, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00002
LABEL ON INDEX FDLOTRD_INDEX_00002 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 3 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00003 ON FDLOTRD (LRGLOC, LRALPH, LRSIZE, LRITEM, LRDESC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00003
LABEL ON INDEX FDLOTRD_INDEX_00003 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 4 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00004 ON FDLOTRD (LRGLOC, LRCUST, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00004
LABEL ON INDEX FDLOTRD_INDEX_00004 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 5 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00005 ON FDLOTRD (LRGLOC, LRCRDY, LRITEM, LRUSER) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00005
LABEL ON INDEX FDLOTRD_INDEX_00005 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 6 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00006 ON FDLOTRD (LRCUST, LRGLOC, LRCRDY, LRSIZE, LRSOWD, LRITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00006
LABEL ON INDEX FDLOTRD_INDEX_00006 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 7 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00007 ON FDLOTRD (LRGLOC, LRSIZE, LRITEM, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00007
LABEL ON INDEX FDLOTRD_INDEX_00007 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 8 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00008 ON FDLOTRD (LRSOWD, LRSIZE, LRCRDY, LRITEM, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00008
LABEL ON INDEX FDLOTRD_INDEX_00008 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 9 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00009 ON FDLOTRD (LRSOWD, LRCUST, LRSIZE, LRCRDY, LRITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00009
LABEL ON INDEX FDLOTRD_INDEX_00009 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 10 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00010 ON FDLOTRD (LRSIZE, LRGLOC, LRCUST, LRCRDY, LRSOWD, LRITEM, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00010
LABEL ON INDEX FDLOTRD_INDEX_00010 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 11 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00011 ON FDLOTRD (LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00011
LABEL ON INDEX FDLOTRD_INDEX_00011 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 12 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00012 ON FDLOTRD (LRSIZE, LRGLOC, LRCUST, LRITEM, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00012
LABEL ON INDEX FDLOTRD_INDEX_00012 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 13 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00013 ON FDLOTRD (LRGLOC, LRCRDY, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00013
LABEL ON INDEX FDLOTRD_INDEX_00013 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 14 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00014 ON FDLOTRD (LRGLOC, LRCRDY, LRCUST, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00014
LABEL ON INDEX FDLOTRD_INDEX_00014 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 15 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00015 ON FDLOTRD (LRALPH, LRGLOC, LRCUST, LRSIZE, LRITEM, LRDESC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00015
LABEL ON INDEX FDLOTRD_INDEX_00015 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 16 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00016 ON FDLOTRD (LRSIZE, LRGLOC, LRITEM, LRCUST, LRCRDY, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00016
LABEL ON INDEX FDLOTRD_INDEX_00016 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 17 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00017 ON FDLOTRD (LRSOWD, LRSIZE, LRCRDY, LRITEM, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00017
LABEL ON INDEX FDLOTRD_INDEX_00017 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 18 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00018 ON FDLOTRD (LRSOWD, LRCRDY, LRITEM, LRSIZE, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00018
LABEL ON INDEX FDLOTRD_INDEX_00018 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 19 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00019 ON FDLOTRD (LRITEM, LRSIZE, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00019
LABEL ON INDEX FDLOTRD_INDEX_00019 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Encoded vector (not unique) index 20 for FDLOTRD
CREATE ENCODED VECTOR INDEX FDLOTRD_INDEX_00020 ON FDLOTRD (LRCRDY) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00020
LABEL ON INDEX FDLOTRD_INDEX_00020 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 21 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00021 ON FDLOTRD (LRSIZE, LRITEM, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00021
LABEL ON INDEX FDLOTRD_INDEX_00021 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 22 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00022 ON FDLOTRD (LRALPH, LRSIZE, LRITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00022
LABEL ON INDEX FDLOTRD_INDEX_00022 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 23 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00023 ON FDLOTRD (LRGLOC, LRCRDY, LRSIZE, LRALPH) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00023
LABEL ON INDEX FDLOTRD_INDEX_00023 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 24 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00024 ON FDLOTRD (LRCLOC, LRPRCL, LRQTAV, LRCUST) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00024
LABEL ON INDEX FDLOTRD_INDEX_00024 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 25 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00025 ON FDLOTRD (LRITEM, LRSIZE, LRCRDY, LRGLOC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00025
LABEL ON INDEX FDLOTRD_INDEX_00025 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 26 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00026 ON FDLOTRD (LRSIZE, LRGLOC, LRCUST, LRCRDY, LRITEM, LRSOWD, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00026
LABEL ON INDEX FDLOTRD_INDEX_00026 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 27 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00027 ON FDLOTRD (LRSOWD, LRGLOC, LRCUST, LRSIZE, LRCRDY, LRITEM, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00027
LABEL ON INDEX FDLOTRD_INDEX_00027 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 28 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00028 ON FDLOTRD (LRGLOC, LRITEM, LRSIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00028
LABEL ON INDEX FDLOTRD_INDEX_00028 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 29 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00029 ON FDLOTRD (LRITEM, LRGLOC, LRSIZE, LRCRDY) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00029
LABEL ON INDEX FDLOTRD_INDEX_00029 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 30 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00030 ON FDLOTRD (LRCUST, LRSIZE, LRITEM, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00030
LABEL ON INDEX FDLOTRD_INDEX_00030 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 31 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00031 ON FDLOTRD (LRCUST, LRSIZE, LRCRDY, LRITEM, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00031
LABEL ON INDEX FDLOTRD_INDEX_00031 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 32 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00032 ON FDLOTRD (LRGLOC, LRSIZE, LRITEM, LRCRDY) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00032
LABEL ON INDEX FDLOTRD_INDEX_00032 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 33 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00033 ON FDLOTRD (LRSTAT, LRGLOC, LRSIZE, LRITEM, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00033
LABEL ON INDEX FDLOTRD_INDEX_00033 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 34 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00034 ON FDLOTRD (LRSTAT, LRSIZE, LRCRDY, LRSOWD, LRITEM, LRGLOC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00034
LABEL ON INDEX FDLOTRD_INDEX_00034 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 35 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00035 ON FDLOTRD (LRCUST, LRCRDY) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00035
LABEL ON INDEX FDLOTRD_INDEX_00035 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 36 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00036 ON FDLOTRD (LRITEM, LRCRDY, LRSIZE, LRALPH) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00036
LABEL ON INDEX FDLOTRD_INDEX_00036 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 37 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00037 ON FDLOTRD (LRCRDY, LRDESC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00037
LABEL ON INDEX FDLOTRD_INDEX_00037 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 38 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00038 ON FDLOTRD (LRGLOC, LRSIZE, LRCUST, LRITEM, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00038
LABEL ON INDEX FDLOTRD_INDEX_00038 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 39 for FDLOTRD
CREATE INDEX FDLOTRD_INDEX_00039 ON FDLOTRD (LRCUST, LRGLOC, LRCRDY, LRQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FDLOTRD_INDEX_00039
LABEL ON INDEX FDLOTRD_INDEX_00039 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"

