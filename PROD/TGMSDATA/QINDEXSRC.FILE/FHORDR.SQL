-- Create Binary Radix index 1 for FHORDR
CREATE INDEX FHORDR_INDEX_00001 ON FHORDR (OHCUST, OHORD#, OHSHCT, OHSHPC, OHSHST, OHSHZP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00001
LABEL ON INDEX FHORDR_INDEX_00001 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 2 for FHORDR
CREATE INDEX FHORDR_INDEX_00002 ON FHORDR (OHORD#, OHSHPC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00002
LABEL ON INDEX FHORDR_INDEX_00002 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 3 for FHORDR
CREATE INDEX FHORDR_INDEX_00003 ON FHORDR (OHSTAT, OHORD#, OHSHPC, OHCUST, OHSHCT, OHSHST, OHSHZP, OHORDY, OHDTRY, OHNAME) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00003
LABEL ON INDEX FHORDR_INDEX_00003 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 4 for FHORDR
CREATE INDEX FHORDR_INDEX_00004 ON FHORDR (OHCUST, OHCOMP, OHSTAT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00004
LABEL ON INDEX FHORDR_INDEX_00004 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 5 for FHORDR
CREATE INDEX FHORDR_INDEX_00005 ON FHORDR (OHORD#, OHCUST, OHSHP2, OHSHP3, OHSHP4, OHSHPC, OHSHST, OHSHZP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00005
LABEL ON INDEX FHORDR_INDEX_00005 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 6 for FHORDR
CREATE INDEX FHORDR_INDEX_00006 ON FHORDR (OHSTAT, OHARCU, OHROUT, OHSTOP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00006
LABEL ON INDEX FHORDR_INDEX_00006 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 7 for FHORDR
CREATE INDEX FHORDR_INDEX_00007 ON FHORDR (OHSTAT, OHARCU, OHDTRY) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00007
LABEL ON INDEX FHORDR_INDEX_00007 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 8 for FHORDR
CREATE INDEX FHORDR_INDEX_00008 ON FHORDR (OHSTAT, OHDTRY, OHORD#, OHCUST, OHBLCU, OHNAME, OHSHPC, OHDTOR, OHSHCT, OHSHST) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00008
LABEL ON INDEX FHORDR_INDEX_00008 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 9 for FHORDR
CREATE INDEX FHORDR_INDEX_00009 ON FHORDR (OHSTAT, OHBLCU, OHDTRY, OHPONO) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00009
LABEL ON INDEX FHORDR_INDEX_00009 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Encoded vector (not unique) index 10 for FHORDR
CREATE ENCODED VECTOR INDEX FHORDR_INDEX_00010 ON FHORDR (OHCUST) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00010
LABEL ON INDEX FHORDR_INDEX_00010 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 11 for FHORDR
CREATE INDEX FHORDR_INDEX_00011 ON FHORDR (OHROUT, OHSTOP, OHORD#, OHCUST, OHNAME) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00011
LABEL ON INDEX FHORDR_INDEX_00011 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 12 for FHORDR
CREATE INDEX FHORDR_INDEX_00012 ON FHORDR (OHSTAT, OHCUST, OHNAME, OHORD#, OHDTRY, OHDTOR) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00012
LABEL ON INDEX FHORDR_INDEX_00012 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 13 for FHORDR
CREATE INDEX FHORDR_INDEX_00013 ON FHORDR (OHSHPC, OHLOC, OHALPH) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00013
LABEL ON INDEX FHORDR_INDEX_00013 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 14 for FHORDR
CREATE INDEX FHORDR_INDEX_00014 ON FHORDR (OHORD#, OHLOC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00014
LABEL ON INDEX FHORDR_INDEX_00014 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 15 for FHORDR
CREATE INDEX FHORDR_INDEX_00015 ON FHORDR (OHDTOR, OHBLCU) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00015
LABEL ON INDEX FHORDR_INDEX_00015 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 16 for FHORDR
CREATE INDEX FHORDR_INDEX_00016 ON FHORDR (OHDTCN, OHNAME, OHSHZP) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00016
LABEL ON INDEX FHORDR_INDEX_00016 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 17 for FHORDR
CREATE INDEX FHORDR_INDEX_00017 ON FHORDR (OHLOTC, OHSTAT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00017
LABEL ON INDEX FHORDR_INDEX_00017 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 18 for FHORDR
CREATE INDEX FHORDR_INDEX_00018 ON FHORDR (OHPONO, OHSTAT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00018
LABEL ON INDEX FHORDR_INDEX_00018 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 19 for FHORDR
CREATE INDEX FHORDR_INDEX_00019 ON FHORDR (OHALPH, OHBLCU) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00019
LABEL ON INDEX FHORDR_INDEX_00019 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 20 for FHORDR
CREATE INDEX FHORDR_INDEX_00020 ON FHORDR (OHSTAT, OHDTRY, OHSHPC, OHDTOR, OHORD#, OHCUST, OHBLCU, OHNAME, OHSHCT, OHSHST) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00020
LABEL ON INDEX FHORDR_INDEX_00020 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 21 for FHORDR
CREATE INDEX FHORDR_INDEX_00021 ON FHORDR (OHORD#, OHSTA) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00021
LABEL ON INDEX FHORDR_INDEX_00021 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 22 for FHORDR
CREATE INDEX FHORDR_INDEX_00022 ON FHORDR (OHSTA) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00022
LABEL ON INDEX FHORDR_INDEX_00022 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Encoded vector (not unique) index 23 for FHORDR
CREATE ENCODED VECTOR INDEX FHORDR_INDEX_00023 ON FHORDR (OHBLCU) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00023
LABEL ON INDEX FHORDR_INDEX_00023 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 24 for FHORDR
CREATE INDEX FHORDR_INDEX_00024 ON FHORDR (OHORD#, OHLOTC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00024
LABEL ON INDEX FHORDR_INDEX_00024 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 25 for FHORDR
CREATE INDEX FHORDR_INDEX_00025 ON FHORDR (OHSTAT, OHCUST, OHDTRY) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00025
LABEL ON INDEX FHORDR_INDEX_00025 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 26 for FHORDR
CREATE INDEX FHORDR_INDEX_00026 ON FHORDR (OHPRCD, OHORD#) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00026
LABEL ON INDEX FHORDR_INDEX_00026 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 27 for FHORDR
CREATE INDEX FHORDR_INDEX_00027 ON FHORDR (OHSHPC, OHSTAT) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00027
LABEL ON INDEX FHORDR_INDEX_00027 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 28 for FHORDR
CREATE INDEX FHORDR_INDEX_00028 ON FHORDR (OHDTCN, OHORD#, OHCUST, OHNAME, OHPRCD, OHSPIN, OHSHPC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00028
LABEL ON INDEX FHORDR_INDEX_00028 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 29 for FHORDR
CREATE INDEX FHORDR_INDEX_00029 ON FHORDR (OHSTAT, OHSHPC, OHSHZP, OHNAME) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FHORDR_INDEX_00029
LABEL ON INDEX FHORDR_INDEX_00029 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"

