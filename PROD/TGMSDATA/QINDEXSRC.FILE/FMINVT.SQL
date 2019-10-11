-- Create Binary Radix index 1 for FMINVT
CREATE INDEX FMINVT_INDEX_00001 ON FMINVT (IMSTAT, IMSIZE, IMITEM, IMQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00001
LABEL ON INDEX FMINVT_INDEX_00001 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 2 for FMINVT
CREATE INDEX FMINVT_INDEX_00002 ON FMINVT (IMSTAT, IMQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00002
LABEL ON INDEX FMINVT_INDEX_00002 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 3 for FMINVT
CREATE INDEX FMINVT_INDEX_00003 ON FMINVT (IMSOWC, IMSTAT, IMSIZE, IMITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00003
LABEL ON INDEX FMINVT_INDEX_00003 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 4 for FMINVT
CREATE INDEX FMINVT_INDEX_00004 ON FMINVT (IMSIZE, IMITEM, IMLOOK) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00004
LABEL ON INDEX FMINVT_INDEX_00004 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 5 for FMINVT
CREATE INDEX FMINVT_INDEX_00005 ON FMINVT (IMITEM, IMSIZE, IMSOWC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00005
LABEL ON INDEX FMINVT_INDEX_00005 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 6 for FMINVT
CREATE INDEX FMINVT_INDEX_00006 ON FMINVT (IMSTAT, IMSIZE, IMQTAV) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00006
LABEL ON INDEX FMINVT_INDEX_00006 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 7 for FMINVT
CREATE INDEX FMINVT_INDEX_00007 ON FMINVT (IMFRSZ, IMSIZE, IMITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00007
LABEL ON INDEX FMINVT_INDEX_00007 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 8 for FMINVT
CREATE INDEX FMINVT_INDEX_00008 ON FMINVT (IMLOOK, IMSIZE, IMITEM, IMDES1) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00008
LABEL ON INDEX FMINVT_INDEX_00008 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 9 for FMINVT
CREATE INDEX FMINVT_INDEX_00009 ON FMINVT (IMFRSZ, IMSTAT, IMLOTC, IMLOOK, IMSIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00009
LABEL ON INDEX FMINVT_INDEX_00009 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 10 for FMINVT
CREATE INDEX FMINVT_INDEX_00010 ON FMINVT (IMFRSZ, IMSTAT, IMVITM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00010
LABEL ON INDEX FMINVT_INDEX_00010 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 11 for FMINVT
CREATE INDEX FMINVT_INDEX_00011 ON FMINVT (IMTPSW, IMSIZE, IMITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00011
LABEL ON INDEX FMINVT_INDEX_00011 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 12 for FMINVT
CREATE INDEX FMINVT_INDEX_00012 ON FMINVT (IMFRSZ, IMSTAT, IMITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00012
LABEL ON INDEX FMINVT_INDEX_00012 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 13 for FMINVT
CREATE INDEX FMINVT_INDEX_00013 ON FMINVT (IMITEM, IMSIZE, IMSOWC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00013
LABEL ON INDEX FMINVT_INDEX_00013 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 14 for FMINVT
CREATE INDEX FMINVT_INDEX_00014 ON FMINVT (IMSTAT, IMSIZE, IMSOWC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00014
LABEL ON INDEX FMINVT_INDEX_00014 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 15 for FMINVT
CREATE INDEX FMINVT_INDEX_00015 ON FMINVT (IMSTAT, IMFRSZ, IMITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00015
LABEL ON INDEX FMINVT_INDEX_00015 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 16 for FMINVT
CREATE INDEX FMINVT_INDEX_00016 ON FMINVT (IMITEM, IMSIZE, IMDES1) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00016
LABEL ON INDEX FMINVT_INDEX_00016 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 17 for FMINVT
CREATE INDEX FMINVT_INDEX_00017 ON FMINVT (IMTPSW, IMPCL1, IMSIZE, IMITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00017
LABEL ON INDEX FMINVT_INDEX_00017 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 18 for FMINVT
CREATE INDEX FMINVT_INDEX_00018 ON FMINVT (IMTRYC, IMPCL1) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00018
LABEL ON INDEX FMINVT_INDEX_00018 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 19 for FMINVT
CREATE INDEX FMINVT_INDEX_00019 ON FMINVT (IMPCL1, IMLOC, IMSIZE, IMITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00019
LABEL ON INDEX FMINVT_INDEX_00019 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 20 for FMINVT
CREATE INDEX FMINVT_INDEX_00020 ON FMINVT (IMSIZE, IMDES1) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00020
LABEL ON INDEX FMINVT_INDEX_00020 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 21 for FMINVT
CREATE INDEX FMINVT_INDEX_00021 ON FMINVT (IMSTAT, IMSOWC, IMLOTC, IMSIZE, IMITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00021
LABEL ON INDEX FMINVT_INDEX_00021 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 22 for FMINVT
CREATE INDEX FMINVT_INDEX_00022 ON FMINVT (IMITEM, IMSIZE, IMLIST) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00022
LABEL ON INDEX FMINVT_INDEX_00022 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 23 for FMINVT
CREATE INDEX FMINVT_INDEX_00023 ON FMINVT (IMFRSZ, IMSTAT, IMSIZE, IMITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00023
LABEL ON INDEX FMINVT_INDEX_00023 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 24 for FMINVT
CREATE INDEX FMINVT_INDEX_00024 ON FMINVT (IMORDD) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00024
LABEL ON INDEX FMINVT_INDEX_00024 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 25 for FMINVT
CREATE INDEX FMINVT_INDEX_00025 ON FMINVT (IMPCL1, IMSIZE, IMITEM, IMTRYC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00025
LABEL ON INDEX FMINVT_INDEX_00025 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 26 for FMINVT
CREATE INDEX FMINVT_INDEX_00026 ON FMINVT (IMLOTC, IMSTAT, IMSIZE, IMSOWC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00026
LABEL ON INDEX FMINVT_INDEX_00026 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 27 for FMINVT
CREATE INDEX FMINVT_INDEX_00027 ON FMINVT (IMPCL1, IMTRYC, IMSIZE, IMITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00027
LABEL ON INDEX FMINVT_INDEX_00027 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 28 for FMINVT
CREATE INDEX FMINVT_INDEX_00028 ON FMINVT (IMDES1) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00028
LABEL ON INDEX FMINVT_INDEX_00028 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 29 for FMINVT
CREATE INDEX FMINVT_INDEX_00029 ON FMINVT (IMSTAT, IMLOOK, IMSIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00029
LABEL ON INDEX FMINVT_INDEX_00029 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 30 for FMINVT
CREATE INDEX FMINVT_INDEX_00030 ON FMINVT (IMITEM, IMDES1) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00030
LABEL ON INDEX FMINVT_INDEX_00030 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 31 for FMINVT
CREATE INDEX FMINVT_INDEX_00031 ON FMINVT (IMLOTC, IMSTAT, IMSIZE, IMSOWC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00031
LABEL ON INDEX FMINVT_INDEX_00031 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Encoded vector (not unique) index 32 for FMINVT
CREATE ENCODED VECTOR INDEX FMINVT_INDEX_00032 ON FMINVT (IMSIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00032
LABEL ON INDEX FMINVT_INDEX_00032 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 33 for FMINVT
CREATE INDEX FMINVT_INDEX_00033 ON FMINVT (IMLBS#, IMSUOM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00033
LABEL ON INDEX FMINVT_INDEX_00033 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 34 for FMINVT
CREATE INDEX FMINVT_INDEX_00034 ON FMINVT (IMMSCX, IMALTP, IMTPSW, IMLOOK) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00034
LABEL ON INDEX FMINVT_INDEX_00034 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Encoded vector (not unique) index 35 for FMINVT
CREATE ENCODED VECTOR INDEX FMINVT_INDEX_00035 ON FMINVT (IMITEM, IMSIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00035
LABEL ON INDEX FMINVT_INDEX_00035 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 36 for FMINVT
CREATE INDEX FMINVT_INDEX_00036 ON FMINVT (IMLOTC, IMSIZE, IMSTAT, IMITEM, IMSOWC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00036
LABEL ON INDEX FMINVT_INDEX_00036 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 37 for FMINVT
CREATE INDEX FMINVT_INDEX_00037 ON FMINVT (IMPCL1, IMSIZE, IMITEM, IMLOC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00037
LABEL ON INDEX FMINVT_INDEX_00037 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 38 for FMINVT
CREATE INDEX FMINVT_INDEX_00038 ON FMINVT (IMTRYC, IMMSCX, IMTPSW, IMLOOK) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00038
LABEL ON INDEX FMINVT_INDEX_00038 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 39 for FMINVT
CREATE INDEX FMINVT_INDEX_00039 ON FMINVT (IMLOOK, IMSTAT, IMITEM, IMSIZE) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00039
LABEL ON INDEX FMINVT_INDEX_00039 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 40 for FMINVT
CREATE INDEX FMINVT_INDEX_00040 ON FMINVT (IMUCST) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00040
LABEL ON INDEX FMINVT_INDEX_00040 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 41 for FMINVT
CREATE INDEX FMINVT_INDEX_00041 ON FMINVT (IMSIZE, IMLOC, IMITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00041
LABEL ON INDEX FMINVT_INDEX_00041 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 42 for FMINVT
CREATE INDEX FMINVT_INDEX_00042 ON FMINVT (IMLOTC, IMSIZE, IMSTAT, IMFRSZ, IMLOOK) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00042
LABEL ON INDEX FMINVT_INDEX_00042 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 43 for FMINVT
CREATE INDEX FMINVT_INDEX_00043 ON FMINVT (IMSIZE, IMDES2) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00043
LABEL ON INDEX FMINVT_INDEX_00043 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 44 for FMINVT
CREATE INDEX FMINVT_INDEX_00044 ON FMINVT (IMLOTC, IMSIZE, IMITEM) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00044
LABEL ON INDEX FMINVT_INDEX_00044 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 45 for FMINVT
CREATE INDEX FMINVT_INDEX_00045 ON FMINVT (IMLOOK, IMITEM, IMSIZE, IMDES1, IMSOWC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00045
LABEL ON INDEX FMINVT_INDEX_00045 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 46 for FMINVT
CREATE INDEX FMINVT_INDEX_00046 ON FMINVT (IMDES2) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00046
LABEL ON INDEX FMINVT_INDEX_00046 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 47 for FMINVT
CREATE INDEX FMINVT_INDEX_00047 ON FMINVT (IMSTAT, IMITEM, IMSOWC, IMFRSZ) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00047
LABEL ON INDEX FMINVT_INDEX_00047 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 48 for FMINVT
CREATE INDEX FMINVT_INDEX_00048 ON FMINVT (IMITEM, IMSIZE, IMQTOH) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00048
LABEL ON INDEX FMINVT_INDEX_00048 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Encoded vector (not unique) index 49 for FMINVT
CREATE ENCODED VECTOR INDEX FMINVT_INDEX_00049 ON FMINVT (IMSOWC) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00049
LABEL ON INDEX FMINVT_INDEX_00049 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 50 for FMINVT
CREATE INDEX FMINVT_INDEX_00050 ON FMINVT (IMITEM, IMSIZE, IM#SED) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00050
LABEL ON INDEX FMINVT_INDEX_00050 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 51 for FMINVT
CREATE INDEX FMINVT_INDEX_00051 ON FMINVT (IMITEM, IMSIZE, IMTPSW) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00051
LABEL ON INDEX FMINVT_INDEX_00051 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 52 for FMINVT
CREATE INDEX FMINVT_INDEX_00052 ON FMINVT (IMMSCX, IMLOOK) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00052
LABEL ON INDEX FMINVT_INDEX_00052 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 53 for FMINVT
CREATE INDEX FMINVT_INDEX_00053 ON FMINVT (IMSTAT, IMSOWC, IMSIZE, IMFRSZ) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00053
LABEL ON INDEX FMINVT_INDEX_00053 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 54 for FMINVT
CREATE INDEX FMINVT_INDEX_00054 ON FMINVT (IMLOTC, IMFRSZ, IMSOWC, IMSTAT, IMLOOK) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00054
LABEL ON INDEX FMINVT_INDEX_00054 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 55 for FMINVT
CREATE INDEX FMINVT_INDEX_00055 ON FMINVT (IMSIZE, IMTPSW) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00055
LABEL ON INDEX FMINVT_INDEX_00055 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"
-- Create Binary Radix index 56 for FMINVT
CREATE INDEX FMINVT_INDEX_00056 ON FMINVT (IMTPSW, IMPCL1, IM#SED) UNIT ANY  KEEP IN MEMORY NO ;
-- Setting label text for FMINVT_INDEX_00056
LABEL ON INDEX FMINVT_INDEX_00056 IS 'Index generated from Index Advisor';
--  -------------------------------------------------------------------------------------------------------------"

