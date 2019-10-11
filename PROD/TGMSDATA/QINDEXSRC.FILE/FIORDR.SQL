-- Create Binary Radix index 1 for FIORDR
CREATE INDEX FIORDR_INDEX_00001 ON FIORDR (OISTAT, OISIZE, OIITYP, OIRVDT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00001
LABEL ON INDEX FIORDR_INDEX_00001 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 2 for FIORDR
CREATE INDEX FIORDR_INDEX_00002 ON FIORDR (OISTAT, OIRVDT, OIORD#, OISIZE, OIITYP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00002
LABEL ON INDEX FIORDR_INDEX_00002 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 3 for FIORDR
CREATE INDEX FIORDR_INDEX_00003 ON FIORDR (OISTAT, OIITYP, OIORD#, OIRVDT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00003
LABEL ON INDEX FIORDR_INDEX_00003 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 4 for FIORDR
CREATE INDEX FIORDR_INDEX_00004 ON FIORDR (OISTAT, OISIZE, OIITYP, OIORD#, OIRVDT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00004
LABEL ON INDEX FIORDR_INDEX_00004 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 5 for FIORDR
CREATE INDEX FIORDR_INDEX_00005 ON FIORDR (OISTAT, OIRVDT, OIORD#, OIITYP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00005
LABEL ON INDEX FIORDR_INDEX_00005 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 6 for FIORDR
CREATE INDEX FIORDR_INDEX_00006 ON FIORDR (OISTAT, OISIZE, OIITYP, OIORD#, OIITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00006
LABEL ON INDEX FIORDR_INDEX_00006 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 7 for FIORDR
CREATE INDEX FIORDR_INDEX_00007 ON FIORDR (OISTAT, OIORD#, OIRVDT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00007
LABEL ON INDEX FIORDR_INDEX_00007 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 8 for FIORDR
CREATE INDEX FIORDR_INDEX_00008 ON FIORDR (OISTAT, OIORD#, OISIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00008
LABEL ON INDEX FIORDR_INDEX_00008 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 9 for FIORDR
CREATE INDEX FIORDR_INDEX_00009 ON FIORDR (OISTAT, OIORD#, OIITYP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00009
LABEL ON INDEX FIORDR_INDEX_00009 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 10 for FIORDR
CREATE INDEX FIORDR_INDEX_00010 ON FIORDR (OISTAT, OISIZE, OIORD#, OIITYP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00010
LABEL ON INDEX FIORDR_INDEX_00010 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 11 for FIORDR
CREATE INDEX FIORDR_INDEX_00011 ON FIORDR (OISTAT, OIRVDT, OISOW, OIITEM, OISIZE, OIDES1, OIALPH) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00011
LABEL ON INDEX FIORDR_INDEX_00011 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 12 for FIORDR
CREATE INDEX FIORDR_INDEX_00012 ON FIORDR (OISTAT, OISIZE, OIORD#, OIITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00012
LABEL ON INDEX FIORDR_INDEX_00012 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 13 for FIORDR
CREATE INDEX FIORDR_INDEX_00013 ON FIORDR (OISTAT, OISIZE, OIITYP, OIITEM, OISOW) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00013
LABEL ON INDEX FIORDR_INDEX_00013 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 14 for FIORDR
CREATE INDEX FIORDR_INDEX_00014 ON FIORDR (OISTAT, OIRVDT, OISIZE, OIITEM, OICUST) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00014
LABEL ON INDEX FIORDR_INDEX_00014 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 15 for FIORDR
CREATE INDEX FIORDR_INDEX_00015 ON FIORDR (OISTAT, OIITYP, OIORD#, OIITEM, OIDES1) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00015
LABEL ON INDEX FIORDR_INDEX_00015 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 16 for FIORDR
CREATE INDEX FIORDR_INDEX_00016 ON FIORDR (OISTAT, OISIZE, OIITYP, OIORD#, OIITMA) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00016
LABEL ON INDEX FIORDR_INDEX_00016 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 17 for FIORDR
CREATE INDEX FIORDR_INDEX_00017 ON FIORDR (OIITYP, OIORD#, OISIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00017
LABEL ON INDEX FIORDR_INDEX_00017 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 18 for FIORDR
CREATE INDEX FIORDR_INDEX_00018 ON FIORDR (OISIZE, OIITEM, OISOW, OIPOST) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00018
LABEL ON INDEX FIORDR_INDEX_00018 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 19 for FIORDR
CREATE INDEX FIORDR_INDEX_00019 ON FIORDR (OISTAT, OIITYP, OIORD#, OISIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00019
LABEL ON INDEX FIORDR_INDEX_00019 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 20 for FIORDR
CREATE INDEX FIORDR_INDEX_00020 ON FIORDR (OISTAT, OISIZE, OIITYP, OIORD#, OIITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00020
LABEL ON INDEX FIORDR_INDEX_00020 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 21 for FIORDR
CREATE INDEX FIORDR_INDEX_00021 ON FIORDR (OISIZE, OIORD#, OIITEM, OIRVDT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00021
LABEL ON INDEX FIORDR_INDEX_00021 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Encoded vector (not unique) index 22 for FIORDR
CREATE ENCODED VECTOR INDEX FIORDR_INDEX_00022 ON FIORDR (OISIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00022
LABEL ON INDEX FIORDR_INDEX_00022 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 23 for FIORDR
CREATE INDEX FIORDR_INDEX_00023 ON FIORDR (OIITYP, OIITEM, OIORD#, OIDES1) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00023
LABEL ON INDEX FIORDR_INDEX_00023 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 24 for FIORDR
CREATE INDEX FIORDR_INDEX_00024 ON FIORDR (OIITYP, OISIZE, OIORD#, OIITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00024
LABEL ON INDEX FIORDR_INDEX_00024 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 25 for FIORDR
CREATE INDEX FIORDR_INDEX_00025 ON FIORDR (OISTAT, OISEQ#, OIITYP, OISIZE, OIORD#, OIITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00025
LABEL ON INDEX FIORDR_INDEX_00025 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 26 for FIORDR
CREATE INDEX FIORDR_INDEX_00026 ON FIORDR (OIORD#, OIITEM, OISEQ#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00026
LABEL ON INDEX FIORDR_INDEX_00026 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Encoded vector (not unique) index 27 for FIORDR
CREATE ENCODED VECTOR INDEX FIORDR_INDEX_00027 ON FIORDR (OIORD#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00027
LABEL ON INDEX FIORDR_INDEX_00027 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 28 for FIORDR
CREATE INDEX FIORDR_INDEX_00028 ON FIORDR (OISTAT, OIITYP, OIORD#, OIRQTY) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00028
LABEL ON INDEX FIORDR_INDEX_00028 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 29 for FIORDR
CREATE INDEX FIORDR_INDEX_00029 ON FIORDR (OIITYP, OIITEM, OIORD#, OISIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00029
LABEL ON INDEX FIORDR_INDEX_00029 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 30 for FIORDR
CREATE INDEX FIORDR_INDEX_00030 ON FIORDR (OISTAT, OISIZE, OIITEM, OISOW) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00030
LABEL ON INDEX FIORDR_INDEX_00030 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 31 for FIORDR
CREATE INDEX FIORDR_INDEX_00031 ON FIORDR (OISTAT, OIORD#, OIQORD) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00031
LABEL ON INDEX FIORDR_INDEX_00031 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 32 for FIORDR
CREATE INDEX FIORDR_INDEX_00032 ON FIORDR (OISTAT, OIQORD) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00032
LABEL ON INDEX FIORDR_INDEX_00032 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 33 for FIORDR
CREATE INDEX FIORDR_INDEX_00033 ON FIORDR (OIORD#, OISTAT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00033
LABEL ON INDEX FIORDR_INDEX_00033 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 34 for FIORDR
CREATE INDEX FIORDR_INDEX_00034 ON FIORDR (OIITMA, OIITEM, OISTAT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00034
LABEL ON INDEX FIORDR_INDEX_00034 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 35 for FIORDR
CREATE INDEX FIORDR_INDEX_00035 ON FIORDR (OIRVDT, OISIZE, OIITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00035
LABEL ON INDEX FIORDR_INDEX_00035 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 36 for FIORDR
CREATE INDEX FIORDR_INDEX_00036 ON FIORDR (OISTAT, OIDTRQ, OIORD#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00036
LABEL ON INDEX FIORDR_INDEX_00036 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 37 for FIORDR
CREATE INDEX FIORDR_INDEX_00037 ON FIORDR (OIORD#, OIITYP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00037
LABEL ON INDEX FIORDR_INDEX_00037 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 38 for FIORDR
CREATE INDEX FIORDR_INDEX_00038 ON FIORDR (OIORD#, OIPRCL) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00038
LABEL ON INDEX FIORDR_INDEX_00038 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 39 for FIORDR
CREATE INDEX FIORDR_INDEX_00039 ON FIORDR (OISEQ#, OIORD#, OICUST) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00039
LABEL ON INDEX FIORDR_INDEX_00039 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 40 for FIORDR
CREATE INDEX FIORDR_INDEX_00040 ON FIORDR (OICUST, OIITYP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00040
LABEL ON INDEX FIORDR_INDEX_00040 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 41 for FIORDR
CREATE INDEX FIORDR_INDEX_00041 ON FIORDR (OISIZE, OIITEM, OIITYP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00041
LABEL ON INDEX FIORDR_INDEX_00041 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 42 for FIORDR
CREATE INDEX FIORDR_INDEX_00042 ON FIORDR (OISIZE, OIITYP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00042
LABEL ON INDEX FIORDR_INDEX_00042 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 43 for FIORDR
CREATE INDEX FIORDR_INDEX_00043 ON FIORDR (OISIZE, OIORD#, OIOVER) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00043
LABEL ON INDEX FIORDR_INDEX_00043 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 44 for FIORDR
CREATE INDEX FIORDR_INDEX_00044 ON FIORDR (OISIZE, OIOVER) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00044
LABEL ON INDEX FIORDR_INDEX_00044 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 45 for FIORDR
CREATE INDEX FIORDR_INDEX_00045 ON FIORDR (OISTAT, OIORD#, OISOW) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00045
LABEL ON INDEX FIORDR_INDEX_00045 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 46 for FIORDR
CREATE INDEX FIORDR_INDEX_00046 ON FIORDR (OISTAT, OIRVDT, OISOW, OISIZE, OIALPH) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00046
LABEL ON INDEX FIORDR_INDEX_00046 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 47 for FIORDR
CREATE INDEX FIORDR_INDEX_00047 ON FIORDR (OISTAT, OISIZE, OISOW) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00047
LABEL ON INDEX FIORDR_INDEX_00047 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 48 for FIORDR
CREATE INDEX FIORDR_INDEX_00048 ON FIORDR (OISTAT, OISOW, OIQORD) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00048
LABEL ON INDEX FIORDR_INDEX_00048 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 49 for FIORDR
CREATE INDEX FIORDR_INDEX_00049 ON FIORDR (OISEQ#, OISIZE, OIORD#, OIITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00049
LABEL ON INDEX FIORDR_INDEX_00049 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 50 for FIORDR
CREATE INDEX FIORDR_INDEX_00050 ON FIORDR (OISTAT, OIUSER, OIDTLA, OIORD#, OICUST) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00050
LABEL ON INDEX FIORDR_INDEX_00050 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 51 for FIORDR
CREATE INDEX FIORDR_INDEX_00051 ON FIORDR (OISTAT, OIRVDT, OISIZE, OIITEM, OIORD#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00051
LABEL ON INDEX FIORDR_INDEX_00051 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 52 for FIORDR
CREATE INDEX FIORDR_INDEX_00052 ON FIORDR (OIITEM, OIITYP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00052
LABEL ON INDEX FIORDR_INDEX_00052 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 53 for FIORDR
CREATE INDEX FIORDR_INDEX_00053 ON FIORDR (OIORD#, OICUST) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FIORDR_INDEX_00053
LABEL ON INDEX FIORDR_INDEX_00053 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"

