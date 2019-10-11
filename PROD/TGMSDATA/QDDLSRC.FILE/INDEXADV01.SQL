/*
Creating index TGMSDATA.FSOHST_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 30499423
-- Last Query Use: 9/18/17 7:03:52 AM
-- Estimated Index Creation Time (seconds): 00:00:34
-- Rows in Table when Advised: 1786986
-- Average of Query Estimates (seconds): 1.0000006
-- Most Expensive Query Estimate (seconds): 11
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FSOHST_INDEX_00001 ON TGMSDATA.FSOHST (SOCUST ASC, SOSIZE ASC, SOSHDT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FSOHST_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FSOHST_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 15250874
-- Last Query Use: 9/18/17 7:03:52 AM
-- Estimated Index Creation Time (seconds): 00:00:55
-- Rows in Table when Advised: 2068393
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 24
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00001 ON TGMSDATA.FIORDR (OISTAT ASC, OISIZE ASC, OIITYP ASC, OIRVDT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINSER_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 13972164
-- Last Query Use: 11/14/18 7:20:17 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 10221
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINSER_INDEX_00001 ON TGMSDATA.FMINSER (ISITEM ASC, ISCODE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINSER_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMINSER_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 13603122
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:01:12
-- Rows in Table when Advised: 2429292
-- Average of Query Estimates (seconds): 0.3933694
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00002 ON TGMSDATA.FIORDR (OISTAT ASC, OIRVDT ASC, OIORD# ASC, OISIZE ASC, OIITYP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FCALEN_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 8363482
-- Last Query Use: 11/15/18 4:27:30 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 15341
-- Average of Query Estimates (seconds): 0.21394068
-- Most Expensive Query Estimate (seconds): 11
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FCALEN_INDEX_00001 ON TGMSDATA.FCALEN (CL#Y ASC, CLCYMD ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FCALEN_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FCALEN_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 7625265
-- Last Query Use: 9/18/17 7:03:52 AM
-- Estimated Index Creation Time (seconds): 00:00:52
-- Rows in Table when Advised: 2068393
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 31
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00003 ON TGMSDATA.FIORDR (OISTAT ASC, OIITYP ASC, OIORD# ASC, OIRVDT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 7624278
-- Last Query Use: 9/18/17 7:03:52 AM
-- Estimated Index Creation Time (seconds): 00:01:01
-- Rows in Table when Advised: 2068393
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00004 ON TGMSDATA.FIORDR (OISTAT ASC, OISIZE ASC, OIITYP ASC, OIORD# ASC, OIRVDT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMSIZE_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5370347
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 289
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMSIZE_INDEX_00001 ON TGMSDATA.FMSIZE (SZSHLV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMSIZE_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMSIZE_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00005
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5351052
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:01:03
-- Rows in Table when Advised: 2429292
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00005 ON TGMSDATA.FIORDR (OISTAT ASC, OIRVDT ASC, OIORD# ASC, OIITYP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00005 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00005 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.NPUTSCN_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3110010
-- Last Query Use: 10/4/18 2:26:55 PM
-- Estimated Index Creation Time (seconds): 00:00:05
-- Rows in Table when Advised: 286266
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.NPUTSCN_INDEX_00001 ON TGMSDATA.NPUTSCN (PSMSTR ASC, PSORD# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.NPUTSCN_INDEX_00001 */
LABEL ON INDEX TGMSDATA.NPUTSCN_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00006
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2896722
-- Last Query Use: 11/14/18 5:06:52 PM
-- Estimated Index Creation Time (seconds): 00:01:27
-- Rows in Table when Advised: 2428675
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 11
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00006 ON TGMSDATA.FIORDR (OISTAT ASC, OISIZE ASC, OIITYP ASC, OIORD# ASC, OIITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00006 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00006 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00007
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2756844
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:01:00
-- Rows in Table when Advised: 2429225
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00007 ON TGMSDATA.FIORDR (OISTAT ASC, OIORD# ASC, OIRVDT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00007 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00007 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.NPUTORD_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2471166
-- Last Query Use: 5/19/17 4:52:05 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 340299
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.NPUTORD_INDEX_00001 ON TGMSDATA.NPUTORD (PDMSTR ASC, PDSHPD ASC, PDORD# ASC, PDLOC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.NPUTORD_INDEX_00001 */
LABEL ON INDEX TGMSDATA.NPUTORD_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00008
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 1907500
-- Last Query Use: 2/5/18 3:22:53 PM
-- Estimated Index Creation Time (seconds): 00:01:05
-- Rows in Table when Advised: 2134527
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00008 ON TGMSDATA.FIORDR (OISTAT ASC, OIORD# ASC, OISIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00008 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00008 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FALITEM_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 1458990
-- Last Query Use: 11/15/18 3:50:31 PM
-- Estimated Index Creation Time (seconds): 00:00:08
-- Rows in Table when Advised: 704641
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FALITEM_INDEX_00001 ON TGMSDATA.FALITEM (AIOSEQ ASC, AIORD# ASC, AIQTOA ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FALITEM_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FALITEM_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FALITEM_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 1458989
-- Last Query Use: 11/15/18 3:50:31 PM
-- Estimated Index Creation Time (seconds): 00:00:22
-- Rows in Table when Advised: 704641
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FALITEM_INDEX_00002 ON TGMSDATA.FALITEM
(AISIZE ASC, AIORD# ASC, AISOWD ASC, AICRDY ASC, AIOSEQ ASC, AIITEM ASC, AIQTOA ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FALITEM_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FALITEM_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00009
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 1389695
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:55
-- Rows in Table when Advised: 2429205
-- Average of Query Estimates (seconds): 9.9302364E-5
-- Most Expensive Query Estimate (seconds): 11
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00009 ON TGMSDATA.FIORDR (OISTAT ASC, OIORD# ASC, OIITYP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00009 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00009 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00010
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 1383538
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:01:05
-- Rows in Table when Advised: 2429205
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00010 ON TGMSDATA.FIORDR (OISTAT ASC, OISIZE ASC, OIORD# ASC, OIITYP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00010 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00010 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FAROPN_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 1094111
-- Last Query Use: 11/14/18 8:31:03 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1611
-- Average of Query Estimates (seconds): 2.7419521E-6
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FAROPN_INDEX_00001 ON TGMSDATA.FAROPN (ARSEQ# ASC, ARCUST ASC, ARINV# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FAROPN_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FAROPN_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FAROPN_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 1074261
-- Last Query Use: 11/14/18 8:31:03 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1611
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FAROPN_INDEX_00002 ON TGMSDATA.FAROPN (ARSEQ# ASC, ARCUST ASC, ARTTYP ASC, ARDUE$ ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FAROPN_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FAROPN_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FHORDW_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 1017996
-- Last Query Use: 9/12/16 6:39:49 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 120318
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FHORDW_INDEX_00001 ON TGMSDATA.FHORDW (WHINV# ASC, WHTMCD ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FHORDW_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FHORDW_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00011
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 982829
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:53
-- Rows in Table when Advised: 2429225
-- Average of Query Estimates (seconds): 2.034942E-6
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00011 ON TGMSDATA.FIORDR
(OISTAT ASC, OIRVDT ASC, OISOW ASC, OIITEM ASC, OISIZE ASC, OIDES1 ASC, OIALPH ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00011 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00011 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00012
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 893978
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:01:30
-- Rows in Table when Advised: 2429225
-- Average of Query Estimates (seconds): 0.021097835
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00012 ON TGMSDATA.FIORDR (OISTAT ASC, OISIZE ASC, OIORD# ASC, OIITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00012 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00012 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.NPUTORD_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 892045
-- Last Query Use: 11/14/18 3:40:26 PM
-- Estimated Index Creation Time (seconds): 00:00:06
-- Rows in Table when Advised: 463179
-- Average of Query Estimates (seconds): 0.99839246
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.NPUTORD_INDEX_00002 ON TGMSDATA.NPUTORD (PDMSTR ASC, PDORD# ASC, PDSHPD ASC, PDSIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.NPUTORD_INDEX_00002 */
LABEL ON INDEX TGMSDATA.NPUTORD_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 856489
-- Last Query Use: 12/19/17 4:09:34 PM
-- Estimated Index Creation Time (seconds): 00:00:10
-- Rows in Table when Advised: 14158
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00001 ON TGMSDATA.FDLOTRD
(LRCUST ASC, LRSIZE ASC, LRCRDY ASC, LRSOWD ASC, LRITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 802783
-- Last Query Use: 11/15/18 5:01:00 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 44996
-- Average of Query Estimates (seconds): 0.19766238
-- Most Expensive Query Estimate (seconds): 47
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00001 ON TGMSDATA.FMINVT (IMSTAT ASC, IMSIZE ASC, IMITEM ASC, IMQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINLOC_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 731502
-- Last Query Use: 11/14/18 3:56:58 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 265
-- Average of Query Estimates (seconds): 0.0046944506
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINLOC_INDEX_00001 ON TGMSDATA.FFINLOC
(FLITEM ASC, FLCUST ASC, FLSIZE ASC, FLDATE ASC, FLPLTG ASC, FLSHIP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINLOC_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FFINLOC_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 657097
-- Last Query Use: 11/14/18 3:56:58 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 23033
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00001 ON TGMSDATA.FFINPPDTAG (FPINVT ASC, FPPPD# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FCUSTCOM_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 656552
-- Last Query Use: 11/15/18 4:50:17 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 13065
-- Average of Query Estimates (seconds): 4.569326E-6
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FCUSTCOM_INDEX_00001 ON TGMSDATA.FCUSTCOM (CCSEQ ASC, CCST3 ASC, CCUST ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FCUSTCOM_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FCUSTCOM_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMCUST_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 655090
-- Last Query Use: 11/15/18 4:50:17 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 13065
-- Average of Query Estimates (seconds): 4.5795236E-6
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMCUST_INDEX_00001 ON TGMSDATA.FMCUST (CMTXST ASC, CMCUST ASC, CMSTST ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMCUST_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMCUST_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 586364
-- Last Query Use: 11/15/18 5:01:10 PM
-- Estimated Index Creation Time (seconds): 00:00:06
-- Rows in Table when Advised: 7424
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 47
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00002 ON TGMSDATA.FDLOTRD (LRGLOC ASC, LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMORLSEAS_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 556090
-- Last Query Use: 11/15/18 5:01:51 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 68
-- Average of Query Estimates (seconds): 8.99135E-6
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMORLSEAS_INDEX_00001 ON TGMSDATA.FMORLSEAS (HSSEAS ASC, HSLIST ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMORLSEAS_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMORLSEAS_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FAROPN_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 547206
-- Last Query Use: 11/14/18 8:31:03 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1611
-- Average of Query Estimates (seconds): 1.8274653E-6
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FAROPN_INDEX_00003 ON TGMSDATA.FAROPN (ARTTYP ASC, ARCUST ASC, ARDUE$ ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FAROPN_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FAROPN_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FAROPN_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 545488
-- Last Query Use: 11/14/18 8:31:03 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1611
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FAROPN_INDEX_00004 ON TGMSDATA.FAROPN (ARTTYP ASC, ARDUE$ ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FAROPN_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FAROPN_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 497419
-- Last Query Use: 11/15/18 5:01:00 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 44996
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 47
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00002 ON TGMSDATA.FMINVT (IMSTAT ASC, IMQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FCALEN_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 488136
-- Last Query Use: 8/22/18 4:08:04 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 15341
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 25
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FCALEN_INDEX_00002 ON TGMSDATA.FCALEN (CLCENT ASC, CLCYMD ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FCALEN_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FCALEN_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FLOSSD_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 484729
-- Last Query Use: 11/15/18 3:46:35 PM
-- Estimated Index Creation Time (seconds): 00:00:15
-- Rows in Table when Advised: 566417
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FLOSSD_INDEX_00001 ON TGMSDATA.FLOSSD (LDSIZE ASC, LDCODE ASC, LDITEM ASC, LDREDY ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FLOSSD_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FLOSSD_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00013
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 455920
-- Last Query Use: 11/15/18 1:36:16 PM
-- Estimated Index Creation Time (seconds): 00:01:22
-- Rows in Table when Advised: 2429211
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00013 ON TGMSDATA.FIORDR (OISTAT ASC, OISIZE ASC, OIITYP ASC, OIITEM ASC, OISOW ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00013 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00013 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTINVT_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 434973
-- Last Query Use: 11/14/18 3:56:58 PM
-- Estimated Index Creation Time (seconds): 00:00:08
-- Rows in Table when Advised: 152583
-- Average of Query Estimates (seconds): 4.3680873E-5
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTINVT_INDEX_00001 ON TGMSDATA.FTINVT (ITTYPE ASC, ITITEM ASC, ITSIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTINVT_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FTINVT_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 407975
-- Last Query Use: 3/21/18 2:32:17 PM
-- Estimated Index Creation Time (seconds): 00:00:28
-- Rows in Table when Advised: 173239
-- Average of Query Estimates (seconds): 1.2255653E-5
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00003 ON TGMSDATA.FDLOTRD (LRGLOC ASC, LRALPH ASC, LRSIZE ASC, LRITEM ASC, LRDESC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.NPUTSCN_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 386625
-- Last Query Use: 11/14/18 5:06:42 PM
-- Estimated Index Creation Time (seconds): 00:00:04
-- Rows in Table when Advised: 286923
-- Average of Query Estimates (seconds): 0.028164241
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.NPUTSCN_INDEX_00002 ON TGMSDATA.NPUTSCN (PSORD# ASC, PSMSTR ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.NPUTSCN_INDEX_00002 */
LABEL ON INDEX TGMSDATA.NPUTSCN_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.NPUTSCN_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 379892
-- Last Query Use: 11/8/18 7:40:27 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 286879
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.NPUTSCN_INDEX_00003 ON TGMSDATA.NPUTSCN (PSORD# ASC, PSUPC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.NPUTSCN_INDEX_00003 */
LABEL ON INDEX TGMSDATA.NPUTSCN_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 371601
-- Last Query Use: 11/15/18 5:01:10 PM
-- Estimated Index Creation Time (seconds): 00:00:07
-- Rows in Table when Advised: 7424
-- Average of Query Estimates (seconds): 5.5435806E-4
-- Most Expensive Query Estimate (seconds): 47
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00004 ON TGMSDATA.FDLOTRD (LRGLOC ASC, LRCUST ASC, LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00005
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 369467
-- Last Query Use: 9/10/18 4:32:00 PM
-- Estimated Index Creation Time (seconds): 00:00:06
-- Rows in Table when Advised: 272044
-- Average of Query Estimates (seconds): 5.4132033E-6
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00005 ON TGMSDATA.FDLOTRD (LRGLOC ASC, LRCRDY ASC, LRITEM ASC, LRUSER ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00005 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00005 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINLOC_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 365632
-- Last Query Use: 11/15/18 2:51:49 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 280
-- Average of Query Estimates (seconds): 0.9884802
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINLOC_INDEX_00002 ON TGMSDATA.FFINLOC (FLPPD# ASC, FLCUST ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINLOC_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FFINLOC_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMORLS_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 352485
-- Last Query Use: 12/21/17 1:39:59 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1378
-- Average of Query Estimates (seconds): 0.69054854
-- Most Expensive Query Estimate (seconds): 327
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMORLS_INDEX_00001 ON TGMSDATA.FMORLS (OLSIZE ASC, OLITEM ASC, OLLIST ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMORLS_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMORLS_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00006
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 349968
-- Last Query Use: 11/15/18 4:27:30 PM
-- Estimated Index Creation Time (seconds): 00:00:07
-- Rows in Table when Advised: 274371
-- Average of Query Estimates (seconds): 0.054922163
-- Most Expensive Query Estimate (seconds): 14
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00006 ON TGMSDATA.FDLOTRD
(LRCUST ASC, LRGLOC ASC, LRCRDY ASC, LRSIZE ASC, LRSOWD ASC, LRITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00006 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00006 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FLOSSLOT_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 312703
-- Last Query Use: 9/18/17 12:46:45 PM
-- Estimated Index Creation Time (seconds): 00:00:11
-- Rows in Table when Advised: 339053
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FLOSSLOT_INDEX_00001 ON TGMSDATA.FLOSSLOT (LDSIZE ASC, LDSOWD ASC, LDREDY ASC, LDITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FLOSSLOT_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FLOSSLOT_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00007
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 301796
-- Last Query Use: 11/15/18 5:01:10 PM
-- Estimated Index Creation Time (seconds): 00:00:12
-- Rows in Table when Advised: 7424
-- Average of Query Estimates (seconds): 0.8162202
-- Most Expensive Query Estimate (seconds): 47
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00007 ON TGMSDATA.FDLOTRD (LRGLOC ASC, LRSIZE ASC, LRITEM ASC, LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00007 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00007 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 286993
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 44996
-- Average of Query Estimates (seconds): 1.8118908E-4
-- Most Expensive Query Estimate (seconds): 36
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00003 ON TGMSDATA.FMINVT (IMSOWC ASC, IMSTAT ASC, IMSIZE ASC, IMITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00008
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 282057
-- Last Query Use: 12/22/17 6:32:48 PM
-- Estimated Index Creation Time (seconds): 00:00:11
-- Rows in Table when Advised: 15445
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00008 ON TGMSDATA.FDLOTRD (LRSOWD ASC, LRSIZE ASC, LRCRDY ASC, LRITEM ASC, LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00008 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00008 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTINVT_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 281368
-- Last Query Use: 7/18/17 5:14:10 PM
-- Estimated Index Creation Time (seconds): 00:00:15
-- Rows in Table when Advised: 221701
-- Average of Query Estimates (seconds): 1.0199134
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTINVT_INDEX_00002 ON TGMSDATA.FTINVT (ITTYPE ASC, ITSIZE ASC, ITITEM ASC, ITORD# ASC, ITDESC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTINVT_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FTINVT_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FSOWSCH_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 280312
-- Last Query Use: 11/15/18 1:36:16 PM
-- Estimated Index Creation Time (seconds): 00:00:19
-- Rows in Table when Advised: 716463
-- Average of Query Estimates (seconds): 7.848397E-5
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FSOWSCH_INDEX_00001 ON TGMSDATA.FSOWSCH (SOSIZE ASC, SOSOWD ASC, SOITEM ASC, SOSTAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FSOWSCH_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FSOWSCH_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMORLS_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 279773
-- Last Query Use: 11/13/18 7:07:01 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1395
-- Average of Query Estimates (seconds): 0.29670483
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMORLS_INDEX_00002 ON TGMSDATA.FMORLS (OLSTAT ASC, OLLIST ASC, OLITEM ASC, OLSIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMORLS_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FMORLS_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMUPC_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 265586
-- Last Query Use: 11/1/18 4:36:11 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 46227
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMUPC_INDEX_00001 ON TGMSDATA.FMUPC (UPCSTAT ASC, UPCCODE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMUPC_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMUPC_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 260970
-- Last Query Use: 11/15/18 4:37:44 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 44996
-- Average of Query Estimates (seconds): 0.07267502
-- Most Expensive Query Estimate (seconds): 17
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00004 ON TGMSDATA.FMINVT (IMSIZE ASC, IMITEM ASC, IMLOOK ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00005
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 251951
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 44996
-- Average of Query Estimates (seconds): 1.5876103E-5
-- Most Expensive Query Estimate (seconds): 33
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00005 ON TGMSDATA.FMINVT (IMITEM ASC, IMSIZE ASC, IMSOWC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00005 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00005 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00009
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 197099
-- Last Query Use: 9/19/17 4:03:14 PM
-- Estimated Index Creation Time (seconds): 00:00:10
-- Rows in Table when Advised: 277073
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00009 ON TGMSDATA.FDLOTRD (LRSOWD ASC, LRCUST ASC, LRSIZE ASC, LRCRDY ASC, LRITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00009 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00009 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00006
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 193120
-- Last Query Use: 11/15/18 9:16:01 AM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 44976
-- Average of Query Estimates (seconds): 0.93219244
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00006 ON TGMSDATA.FMINVT (IMSTAT ASC, IMSIZE ASC, IMQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00006 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00006 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00010
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 186378
-- Last Query Use: 11/15/18 4:56:02 PM
-- Estimated Index Creation Time (seconds): 00:00:15
-- Rows in Table when Advised: 276006
-- Average of Query Estimates (seconds): 0.0032460913
-- Most Expensive Query Estimate (seconds): 25
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00010 ON TGMSDATA.FDLOTRD
(LRSIZE ASC, LRGLOC ASC, LRCUST ASC, LRCRDY ASC, LRSOWD ASC, LRITEM ASC, LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00010 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00010 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMORLSEAS_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 184564
-- Last Query Use: 10/24/18 5:34:12 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 68
-- Average of Query Estimates (seconds): 6.8269E-4
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMORLSEAS_INDEX_00002 ON TGMSDATA.FMORLSEAS (HSSTAT ASC, HSSNCD ASC, HSSEAS ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMORLSEAS_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FMORLSEAS_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 181775
-- Last Query Use: 5/6/16 4:10:51 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 8172
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00002 ON TGMSDATA.FFINPPDTAG (FPINVT ASC, FPPRTD ASC, FPWEEK ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMATTEND_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 176720
-- Last Query Use: 11/15/18 4:01:49 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 119136
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMATTEND_INDEX_00001 ON TGMSDATA.FMATTEND (ATCARD ASC, ATDATE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMATTEND_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMATTEND_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMATTEND_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 176060
-- Last Query Use: 11/15/18 4:01:49 PM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 119136
-- Average of Query Estimates (seconds): 0.026632966
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMATTEND_INDEX_00002 ON TGMSDATA.FMATTEND (ATTYPE ASC, ATDATE ASC, ATCARD ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMATTEND_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FMATTEND_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00011
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 170770
-- Last Query Use: 10/26/18 4:06:08 AM
-- Estimated Index Creation Time (seconds): 00:00:04
-- Rows in Table when Advised: 274534
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 25
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00011 ON TGMSDATA.FDLOTRD (LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00011 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00011 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00012
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 169514
-- Last Query Use: 11/15/18 5:01:10 PM
-- Estimated Index Creation Time (seconds): 00:00:10
-- Rows in Table when Advised: 7424
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 47
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00012 ON TGMSDATA.FDLOTRD (LRSIZE ASC, LRGLOC ASC, LRCUST ASC, LRITEM ASC, LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00012 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00012 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTINVT_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 158720
-- Last Query Use: 7/27/16 5:00:31 PM
-- Estimated Index Creation Time (seconds): 00:00:14
-- Rows in Table when Advised: 231349
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTINVT_INDEX_00003 ON TGMSDATA.FTINVT (ITTYPE ASC, ITSIZE ASC, ITITEM ASC, ITDESC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTINVT_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FTINVT_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAY_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 155973
-- Last Query Use: 11/12/18 10:02:18 AM
-- Estimated Index Creation Time (seconds): 00:00:07
-- Rows in Table when Advised: 320486
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRAY_INDEX_00001 ON TGMSDATA.FTRAY (TRTAG# ASC, TRSTAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAY_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FTRAY_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00007
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 154828
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 44557
-- Average of Query Estimates (seconds): 0.009358772
-- Most Expensive Query Estimate (seconds): 42
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00007 ON TGMSDATA.FMINVT (IMFRSZ ASC, IMSIZE ASC, IMITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00007 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00007 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00014
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 153242
-- Last Query Use: 11/15/18 3:46:35 PM
-- Estimated Index Creation Time (seconds): 00:01:25
-- Rows in Table when Advised: 2430756
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00014 ON TGMSDATA.FIORDR (OISTAT ASC, OIRVDT ASC, OISIZE ASC, OIITEM ASC, OICUST ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00014 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00014 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAY_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 153189
-- Last Query Use: 11/15/18 3:46:35 PM
-- Estimated Index Creation Time (seconds): 00:00:14
-- Rows in Table when Advised: 317749
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRAY_INDEX_00002 ON TGMSDATA.FTRAY (TRSIZE ASC, TRCRDT ASC, TRITEM ASC, TRSTAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAY_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FTRAY_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FSOWSCH_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 153181
-- Last Query Use: 11/15/18 3:46:35 PM
-- Estimated Index Creation Time (seconds): 00:00:18
-- Rows in Table when Advised: 716811
-- Average of Query Estimates (seconds): 2.6112899E-5
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FSOWSCH_INDEX_00002 ON TGMSDATA.FSOWSCH (SOSIZE ASC, SOITEM ASC, SORDYD ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FSOWSCH_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FSOWSCH_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAYFIXED_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 153055
-- Last Query Use: 11/15/18 3:46:35 PM
-- Estimated Index Creation Time (seconds): 00:00:04
-- Rows in Table when Advised: 301068
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Encoded vector (not unique)
-- EVI Distinct Values:
 */
CREATE ENCODED VECTOR INDEX TGMSDATA.FTRAYFIXED_INDEX_00001 ON TGMSDATA.FTRAYFIXED (TFTAG# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAYFIXED_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FTRAYFIXED_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00013
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 152132
-- Last Query Use: 11/15/18 5:01:10 PM
-- Estimated Index Creation Time (seconds): 00:00:06
-- Rows in Table when Advised: 7424
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 47
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00013 ON TGMSDATA.FDLOTRD (LRGLOC ASC, LRCRDY ASC, LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00013 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00013 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 151966
-- Last Query Use: 11/14/18 4:00:22 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 23033
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00003 ON TGMSDATA.FFINPPDTAG (FPWEEK ASC, FPPRTD ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00014
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 151591
-- Last Query Use: 11/15/18 5:01:10 PM
-- Estimated Index Creation Time (seconds): 00:00:07
-- Rows in Table when Advised: 7424
-- Average of Query Estimates (seconds): 1.3193396E-5
-- Most Expensive Query Estimate (seconds): 47
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00014 ON TGMSDATA.FDLOTRD (LRGLOC ASC, LRCRDY ASC, LRCUST ASC, LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00014 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00014 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FHORDRCSTM_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 147839
-- Last Query Use: 9/17/18 4:02:12 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 7472
-- Average of Query Estimates (seconds): 0.107285626
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FHORDRCSTM_INDEX_00001 ON TGMSDATA.FHORDRCSTM (COPROJ ASC, COORD# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FHORDRCSTM_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FHORDRCSTM_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMEMAIL_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 146085
-- Last Query Use: 11/15/18 4:31:06 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 11382
-- Average of Query Estimates (seconds): 0.22404079
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMEMAIL_INDEX_00001 ON TGMSDATA.FMEMAIL (EMACTT ASC, EMAIL ASC, EMNAME ASC, EMACCT ASC, EMCODE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMEMAIL_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMEMAIL_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FAROPN_INDEX_00005
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 145639
-- Last Query Use: 11/14/18 8:31:03 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1611
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FAROPN_INDEX_00005 ON TGMSDATA.FAROPN (ARSUFF ASC, ARCUST ASC, ARTTYP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FAROPN_INDEX_00005 */
LABEL ON INDEX TGMSDATA.FAROPN_INDEX_00005 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 141262
-- Last Query Use: 11/14/18 3:56:58 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 23033
-- Average of Query Estimates (seconds): 0.0032351234
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00004 ON TGMSDATA.FFINPPDTAG (FPINVT ASC, FPPRTD ASC, FPWEEK ASC, FPPPD# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FCUTCTL_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 139613
-- Last Query Use: 11/15/18 1:36:26 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 35
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FCUTCTL_INDEX_00001 ON TGMSDATA.FCUTCTL (CCVEND ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FCUTCTL_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FCUTCTL_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00008
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 129582
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:04
-- Rows in Table when Advised: 44875
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 10
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00008 ON TGMSDATA.FMINVT (IMLOOK ASC, IMSIZE ASC, IMITEM ASC, IMDES1 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00008 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00008 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FSOHST_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 126882
-- Last Query Use: 8/6/16 7:04:44 AM
-- Estimated Index Creation Time (seconds): 00:00:25
-- Rows in Table when Advised: 1553670
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 122
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FSOHST_INDEX_00002 ON TGMSDATA.FSOHST (SOCUST ASC, SOBLCU ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FSOHST_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FSOHST_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00005
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 115734
-- Last Query Use: 11/14/18 11:46:13 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 23033
-- Average of Query Estimates (seconds): 7.7764525E-5
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00005 ON TGMSDATA.FFINPPDTAG (FPWEEK ASC, FPINVT ASC, FPPRTD ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00005 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00005 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.NPUTERR_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 106732
-- Last Query Use: 11/13/18 3:02:19 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 22139
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.NPUTERR_INDEX_00001 ON TGMSDATA.NPUTERR (PEUPC ASC, PEORD# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.NPUTERR_INDEX_00001 */
LABEL ON INDEX TGMSDATA.NPUTERR_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAY_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 106003
-- Last Query Use: 12/22/17 1:58:39 PM
-- Estimated Index Creation Time (seconds): 00:00:16
-- Rows in Table when Advised: 314494
-- Average of Query Estimates (seconds): 9.433696E-6
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRAY_INDEX_00003 ON TGMSDATA.FTRAY (TRSIZE ASC, TRCRDT ASC, TRITEM ASC, TRTAG# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAY_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FTRAY_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00015
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 105761
-- Last Query Use: 11/14/18 5:06:52 PM
-- Estimated Index Creation Time (seconds): 00:02:38
-- Rows in Table when Advised: 2428874
-- Average of Query Estimates (seconds): 0.7607814
-- Most Expensive Query Estimate (seconds): 44
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00015 ON TGMSDATA.FIORDR (OISTAT ASC, OIITYP ASC, OIORD# ASC, OIITEM ASC, OIDES1 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00015 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00015 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00009
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 103759
-- Last Query Use: 11/15/18 4:27:40 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 44996
-- Average of Query Estimates (seconds): 2.698561E-4
-- Most Expensive Query Estimate (seconds): 47
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00009 ON TGMSDATA.FMINVT (IMFRSZ ASC, IMSTAT ASC, IMLOTC ASC, IMLOOK ASC, IMSIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00009 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00009 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.NPUTERR_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 102660
-- Last Query Use: 11/13/18 3:02:19 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 22139
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.NPUTERR_INDEX_00002 ON TGMSDATA.NPUTERR (PEORD# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.NPUTERR_INDEX_00002 */
LABEL ON INDEX TGMSDATA.NPUTERR_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00006
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 102422
-- Last Query Use: 11/14/18 4:00:22 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 23033
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00006 ON TGMSDATA.FFINPPDTAG (FPBAT# ASC, FPPPD# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00006 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00006 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.CURSEASONS_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 96588
-- Last Query Use: 11/15/18 4:54:31 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.CURSEASONS_INDEX_00001 ON TGMSDATA.CURSEASONS (SEASON ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.CURSEASONS_INDEX_00001 */
LABEL ON INDEX TGMSDATA.CURSEASONS_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00010
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 87399
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 44495
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 42
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00010 ON TGMSDATA.FMINVT (IMFRSZ ASC, IMSTAT ASC, IMVITM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00010 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00010 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMEMAIL_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 84886
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 11382
-- Average of Query Estimates (seconds): 2.3561011E-5
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMEMAIL_INDEX_00002 ON TGMSDATA.FMEMAIL
(EMACTT ASC, EMSTAT ASC, EMCODE ASC, EMACCT ASC, EMNAME ASC, EMAIL ASC, EMTMST ASC, EMUSER ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMEMAIL_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FMEMAIL_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00011
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 80344
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 44479
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00011 ON TGMSDATA.FMINVT (IMTPSW ASC, IMSIZE ASC, IMITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00011 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00011 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00007
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 79718
-- Last Query Use: 11/14/18 4:00:22 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 23033
-- Average of Query Estimates (seconds): 8.780954E-5
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00007 ON TGMSDATA.FFINPPDTAG (FPWEEK ASC, FPBAT# ASC, FPCUST ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00007 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00007 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00015
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 77254
-- Last Query Use: 3/21/18 2:32:17 PM
-- Estimated Index Creation Time (seconds): 00:00:29
-- Rows in Table when Advised: 174392
-- Average of Query Estimates (seconds): 3.883294E-5
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00015 ON TGMSDATA.FDLOTRD
(LRALPH ASC, LRGLOC ASC, LRCUST ASC, LRSIZE ASC, LRITEM ASC, LRDESC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00015 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00015 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.ITEM_WITH_MISSING_PIC_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 76663
-- Last Query Use: 11/15/18 4:54:31 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 43
-- Average of Query Estimates (seconds): 0.8289266
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.ITEM_WITH_MISSING_PIC_INDEX_00001 ON TGMSDATA.ITEM_WITH_MISSING_PIC (SIZE_CODE ASC, ITEM_NUMBER ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.ITEM_WITH_MISSING_PIC_INDEX_00001 */
LABEL ON INDEX TGMSDATA.ITEM_WITH_MISSING_PIC_INDEX_00001 IS 'Index generated from Index Advisor';


/*
Creating index TGMSDATA.FTRSCHD_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 76457
-- Last Query Use: 11/15/18 1:02:49 PM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 108266
-- Average of Query Estimates (seconds): 0.35014454
-- Most Expensive Query Estimate (seconds): 327
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRSCHD_INDEX_00001 ON TGMSDATA.FTRSCHD (TRORD# ASC, TRSHDT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRSCHD_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FTRSCHD_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FAV_02386_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 76208
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 97
-- Average of Query Estimates (seconds): 2.2307369E-4
-- Most Expensive Query Estimate (seconds): 32
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FAV_02386_INDEX_00001 ON TGMSDATA.FAV_02386 (RECORDTYPE ASC, DATEYYYYMMDD ASC, COLUMN2 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FAV_02386_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FAV_02386_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FAV_01533_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 74754
-- Last Query Use: 11/15/18 5:01:10 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 378201
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 33
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FAV_01533_INDEX_00001 ON TGMSDATA.FAV_01533 (RECORDTYPE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FAV_01533_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FAV_01533_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.XATABL_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 74573
-- Last Query Use: 11/15/18 4:31:06 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 677
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.XATABL_INDEX_00001 ON TGMSDATA.XATABL (TBRCDE ASC, TBTBCD ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.XATABL_INDEX_00001 */
LABEL ON INDEX TGMSDATA.XATABL_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WSORCHCPF_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 73383
-- Last Query Use: 11/15/18 3:21:55 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 31647
-- Average of Query Estimates (seconds): 1.7715275E-4
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WSORCHCPF_INDEX_00001 ON TGMSDATA.WSORCHCPF
(OCFRORID ASC, OCBRKLNE ASC, OCBRKORID ASC, OCORDNO ASC, OCBRKMAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WSORCHCPF_INDEX_00001 */
LABEL ON INDEX TGMSDATA.WSORCHCPF_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WRITE_SHP_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 72433
-- Last Query Use: 4/4/18 8:53:49 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 9307
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WRITE_SHP_INDEX_00001 ON TGMSDATA.WRITE_SHP (TRACKING# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WRITE_SHP_INDEX_00001 */
LABEL ON INDEX TGMSDATA.WRITE_SHP_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FSOHST_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 72251
-- Last Query Use: 1/12/18 1:06:28 PM
-- Estimated Index Creation Time (seconds): 00:01:00
-- Rows in Table when Advised: 1803363
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FSOHST_INDEX_00001 ON TGMSDATA.FSOHST (SOSIZE ASC, SOCUST ASC, SOITEM ASC, SOORD# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FSOHST_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FSOHST_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FHORDRCSTM_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 71273
-- Last Query Use: 2/7/17 4:57:48 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 6071
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FHORDRCSTM_INDEX_00001 ON TGMSDATA.FHORDRCSTM (COORD# ASC, COPROJ ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FHORDRCSTM_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FHORDRCSTM_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 67766
-- Last Query Use: 11/15/18 2:51:38 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 23033
-- Average of Query Estimates (seconds): 0.30153763
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00001 ON TGMSDATA.FFINPPDTAG (FPPRTD ASC, FPPPD# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 66011
-- Last Query Use: 4/7/16 11:42:10 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 6137
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00002 ON TGMSDATA.FFINPPDTAG (FPWEEK ASC, FPITEM ASC, FPSIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.RB_SHIPVIA_EQUIVALENT_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 61275
-- Last Query Use: 11/15/18 5:03:14 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 7
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.RB_SHIPVIA_EQUIVALENT_INDEX_00001 ON TGMSDATA.RB_SHIPVIA_EQUIVALENT (READYBAYSHIPVIACODE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.RB_SHIPVIA_EQUIVALENT_INDEX_00001 */
LABEL ON INDEX TGMSDATA.RB_SHIPVIA_EQUIVALENT_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMORLS_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 58833
-- Last Query Use: 11/15/18 4:51:29 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1395
-- Average of Query Estimates (seconds): 0.6074822
-- Most Expensive Query Estimate (seconds): 4
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMORLS_INDEX_00001 ON TGMSDATA.FMORLS (OLLIST ASC, OLSIZE ASC, OLITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMORLS_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMORLS_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FHORDW_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 58695
-- Last Query Use: 11/15/18 6:04:27 AM
-- Estimated Index Creation Time (seconds): 00:00:04
-- Rows in Table when Advised: 139459
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FHORDW_INDEX_00001 ON TGMSDATA.FHORDW (WHTRAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FHORDW_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FHORDW_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 58640
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 44495
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 42
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00001 ON TGMSDATA.FMINVT (IMFRSZ ASC, IMSTAT ASC, IMITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMSIZC_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 57723
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 287
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 9
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMSIZC_INDEX_00001 ON TGMSDATA.FMSIZC (SCSIZE ASC, SCCATG ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMSIZC_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMSIZC_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 56116
-- Last Query Use: 12/22/17 6:31:05 PM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 42702
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 36
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00002 ON TGMSDATA.FMINVT (IMITEM ASC, IMSIZE ASC, IMSOWC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINCRT_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 54728
-- Last Query Use: 11/14/18 8:45:40 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 61785
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINCRT_INDEX_00001 ON TGMSDATA.FFINCRT (FOSTAT ASC, FOTIME ASC, FOLOOK ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINCRT_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FFINCRT_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINCRT_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 52421
-- Last Query Use: 11/14/18 8:45:40 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 61785
-- Average of Query Estimates (seconds): 0.031266097
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINCRT_INDEX_00002 ON TGMSDATA.FFINCRT (FOUPC ASC, FOTIME ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINCRT_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FFINCRT_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.READYFW_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 52315
-- Last Query Use: 11/15/18 5:01:00 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 32
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.READYFW_INDEX_00001 ON TGMSDATA.READYFW (QTAVW5 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.READYFW_INDEX_00001 */
LABEL ON INDEX TGMSDATA.READYFW_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.READYFW_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 52315
-- Last Query Use: 11/15/18 5:01:00 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 32
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.READYFW_INDEX_00002 ON TGMSDATA.READYFW (QTAVW1 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.READYFW_INDEX_00002 */
LABEL ON INDEX TGMSDATA.READYFW_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.READYFW_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 52315
-- Last Query Use: 11/15/18 5:01:00 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 32
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.READYFW_INDEX_00003 ON TGMSDATA.READYFW (QTAVW4 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.READYFW_INDEX_00003 */
LABEL ON INDEX TGMSDATA.READYFW_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.READYFW_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 52315
-- Last Query Use: 11/15/18 5:01:00 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 32
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.READYFW_INDEX_00004 ON TGMSDATA.READYFW (QTAVW2 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.READYFW_INDEX_00004 */
LABEL ON INDEX TGMSDATA.READYFW_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.READYFW_INDEX_00005
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 52315
-- Last Query Use: 11/15/18 5:01:00 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 32
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.READYFW_INDEX_00005 ON TGMSDATA.READYFW (QTAVW3 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.READYFW_INDEX_00005 */
LABEL ON INDEX TGMSDATA.READYFW_INDEX_00005 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WSORCHCPF_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 49727
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 31577
-- Average of Query Estimates (seconds): 0.96726125
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WSORCHCPF_INDEX_00002 ON TGMSDATA.WSORCHCPF (OCORDNO ASC, OCPOSEQ ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WSORCHCPF_INDEX_00002 */
LABEL ON INDEX TGMSDATA.WSORCHCPF_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMEMAIL_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 47353
-- Last Query Use: 11/15/18 4:31:06 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 11382
-- Average of Query Estimates (seconds): 4.2235974E-5
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMEMAIL_INDEX_00001 ON TGMSDATA.FMEMAIL (EMACTT ASC, EMNAME ASC, EMACCT ASC, EMAIL ASC, EMSTAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMEMAIL_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMEMAIL_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FCUTLOT_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 47130
-- Last Query Use: 11/15/18 3:29:00 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 5334
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FCUTLOT_INDEX_00001 ON TGMSDATA.FCUTLOT (CLSOWD ASC, CLITEM ASC, CLQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FCUTLOT_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FCUTLOT_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FHORDR_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 46825
-- Last Query Use: 11/4/17 7:01:16 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 121341
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FHORDR_INDEX_00001 ON TGMSDATA.FHORDR
(OHCUST ASC, OHORD# ASC, OHSHCT ASC, OHSHPC ASC, OHSHST ASC, OHSHZP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FHORDR_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FHORDR_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FHORDW_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 44608
-- Last Query Use: 11/14/18 8:41:08 PM
-- Estimated Index Creation Time (seconds): 00:00:04
-- Rows in Table when Advised: 139459
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FHORDW_INDEX_00002 ON TGMSDATA.FHORDW (WHINDT ASC, WHBLCU ASC, WHINV# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FHORDW_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FHORDW_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMEMAIL_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 41924
-- Last Query Use: 11/15/18 4:31:06 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 11382
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMEMAIL_INDEX_00002 ON TGMSDATA.FMEMAIL (EMACTT ASC, EMNAME ASC, EMAIL ASC, EMACCT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMEMAIL_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FMEMAIL_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAY_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 41832
-- Last Query Use: 10/19/18 9:43:14 AM
-- Estimated Index Creation Time (seconds): 00:00:15
-- Rows in Table when Advised: 328537
-- Average of Query Estimates (seconds): 0.5031555
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRAY_INDEX_00001 ON TGMSDATA.FTRAY (TRSIZE ASC, TRSCYM ASC, TRCRDT ASC, TRITEM ASC, TRCNTD ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAY_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FTRAY_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMUPC_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 40578
-- Last Query Use: 5/31/18 2:36:26 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 45225
-- Average of Query Estimates (seconds): 7.393169E-5
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMUPC_INDEX_00001 ON TGMSDATA.FMUPC (UPCSTAT ASC, UPCSIZE ASC, UPCITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMUPC_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMUPC_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 40060
-- Last Query Use: 11/15/18 5:01:10 PM
-- Estimated Index Creation Time (seconds): 00:00:09
-- Rows in Table when Advised: 7424
-- Average of Query Estimates (seconds): 1.2481278E-4
-- Most Expensive Query Estimate (seconds): 47
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00001 ON TGMSDATA.FDLOTRD
(LRSIZE ASC, LRGLOC ASC, LRITEM ASC, LRCUST ASC, LRCRDY ASC, LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMORLHCFG_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 39714
-- Last Query Use: 11/14/18 5:06:52 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 40
-- Average of Query Estimates (seconds): 0.010374175
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMORLHCFG_INDEX_00001 ON TGMSDATA.FMORLHCFG (HCACTV ASC, HCLIST ASC, HCGRUP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMORLHCFG_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMORLHCFG_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WRITE_UPS_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 38526
-- Last Query Use: 11/9/16 2:55:26 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 2401
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WRITE_UPS_INDEX_00001 ON TGMSDATA.WRITE_UPS (TRACKING# ASC, MASTER# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WRITE_UPS_INDEX_00001 */
LABEL ON INDEX TGMSDATA.WRITE_UPS_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 37431
-- Last Query Use: 9/21/17 6:31:42 PM
-- Estimated Index Creation Time (seconds): 00:00:10
-- Rows in Table when Advised: 277099
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00002 ON TGMSDATA.FDLOTRD (LRSOWD ASC, LRSIZE ASC, LRCRDY ASC, LRITEM ASC, LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 37413
-- Last Query Use: 3/21/18 2:33:19 PM
-- Estimated Index Creation Time (seconds): 00:00:04
-- Rows in Table when Advised: 173239
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00003 ON TGMSDATA.FDLOTRD (LRSOWD ASC, LRCRDY ASC, LRITEM ASC, LRSIZE ASC, LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FAV_01533C_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 37366
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 14
-- Average of Query Estimates (seconds): 0.009848526
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FAV_01533C_INDEX_00001 ON TGMSDATA.FAV_01533C (RECORDTYPE ASC, DATEYYYYMMDD ASC, COLUMN2 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FAV_01533C_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FAV_01533C_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 37309
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:01:42
-- Rows in Table when Advised: 2430802
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00001 ON TGMSDATA.FIORDR (OISTAT ASC, OISIZE ASC, OIITYP ASC, OIORD# ASC, OIITMA ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 37168
-- Last Query Use: 11/15/18 4:01:06 AM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 44976
-- Average of Query Estimates (seconds): 0.031102024
-- Most Expensive Query Estimate (seconds): 6
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00003 ON TGMSDATA.FMINVT (IMSTAT ASC, IMSIZE ASC, IMSOWC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 37161
-- Last Query Use: 11/14/18 11:46:23 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 23033
-- Average of Query Estimates (seconds): 1.0763973E-4
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00003 ON TGMSDATA.FFINPPDTAG
(FPBAT# ASC, FPINVT ASC, FPWEEK ASC, FPSIZE ASC, FPCUST ASC, FPITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WSORCHCPF_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 35141
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 19113
-- Average of Query Estimates (seconds): 2.8456789E-5
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WSORCHCPF_INDEX_00003 ON TGMSDATA.WSORCHCPF (OCPOSEQ ASC, OCORDNO ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WSORCHCPF_INDEX_00003 */
LABEL ON INDEX TGMSDATA.WSORCHCPF_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FCSECT_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 35056
-- Last Query Use: 11/15/18 11:28:32 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1704
-- Average of Query Estimates (seconds): 8.557736E-5
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FCSECT_INDEX_00001 ON TGMSDATA.FCSECT (GHOUSE ASC, GHSECT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FCSECT_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FCSECT_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FCSECT_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 35036
-- Last Query Use: 11/15/18 11:28:32 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1704
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FCSECT_INDEX_00002 ON TGMSDATA.FCSECT (GHOUSE ASC, GHUSED ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FCSECT_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FCSECT_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 34514
-- Last Query Use: 3/15/16 5:00:54 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 2875
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00004 ON TGMSDATA.FFINPPDTAG (FPINVT ASC, FPPRTD ASC, FPPPD# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAYFIXED_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 31570
-- Last Query Use: 11/15/18 3:46:35 PM
-- Estimated Index Creation Time (seconds): 00:00:07
-- Rows in Table when Advised: 301077
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRAYFIXED_INDEX_00001 ON TGMSDATA.FTRAYFIXED (TFSTAT ASC, TFCART ASC, TFTIME ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAYFIXED_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FTRAYFIXED_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMEMAIL_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 31318
-- Last Query Use: 11/15/18 4:31:06 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 11382
-- Average of Query Estimates (seconds): 4.7895778E-4
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMEMAIL_INDEX_00003 ON TGMSDATA.FMEMAIL (EMACTT ASC, EMCODE ASC, EMACCT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMEMAIL_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FMEMAIL_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMEMPLOY_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 30630
-- Last Query Use: 11/15/18 3:55:12 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 246
-- Average of Query Estimates (seconds): 3.264773E-5
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMEMPLOY_INDEX_00001 ON TGMSDATA.FMEMPLOY (EMLAST ASC, EMFIRS ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMEMPLOY_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMEMPLOY_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 30582
-- Last Query Use: 11/15/18 4:27:30 PM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 44557
-- Average of Query Estimates (seconds): 0.9971552
-- Most Expensive Query Estimate (seconds): 24
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00004 ON TGMSDATA.FMINVT (IMSTAT ASC, IMFRSZ ASC, IMITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FCUTLOT_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 30059
-- Last Query Use: 11/15/18 3:29:00 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 5334
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FCUTLOT_INDEX_00002 ON TGMSDATA.FCUTLOT (CLQTOO ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FCUTLOT_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FCUTLOT_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FCUTLOT_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 30056
-- Last Query Use: 11/15/18 3:29:00 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 5334
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FCUTLOT_INDEX_00003 ON TGMSDATA.FCUTLOT (CLSOWD ASC, CLITEM ASC, CLQTOO ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FCUTLOT_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FCUTLOT_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00005
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 30002
-- Last Query Use: 11/15/18 4:54:41 PM
-- Estimated Index Creation Time (seconds): 00:00:04
-- Rows in Table when Advised: 44996
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00005 ON TGMSDATA.FMINVT (IMITEM ASC, IMSIZE ASC, IMDES1 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00005 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00005 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 29445
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:05
-- Rows in Table when Advised: 7424
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 33
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00004 ON TGMSDATA.FDLOTRD (LRITEM ASC, LRSIZE ASC, LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00005
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 29299
-- Last Query Use: 7/21/17 2:18:50 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 16193
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00005 ON TGMSDATA.FFINPPDTAG
(FPSIZE ASC, FPITEM ASC, FPPLTG ASC, FPCUST ASC, FPTIMESTAMP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00005 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00005 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAYFIXED_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 29089
-- Last Query Use: 11/15/18 3:46:35 PM
-- Estimated Index Creation Time (seconds): 00:00:07
-- Rows in Table when Advised: 301077
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRAYFIXED_INDEX_00002 ON TGMSDATA.FTRAYFIXED (TFCART ASC, TFTIME ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAYFIXED_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FTRAYFIXED_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAYR_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 28906
-- Last Query Use: 11/13/18 3:59:33 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 8538
-- Average of Query Estimates (seconds): 6.918979E-5
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRAYR_INDEX_00001 ON TGMSDATA.FTRAYR (TRUSER ASC, TRDTLA ASC, TRTIME ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAYR_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FTRAYR_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMATTEND_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 28498
-- Last Query Use: 11/15/18 7:39:33 AM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 119147
-- Average of Query Estimates (seconds): 0.14643133
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMATTEND_INDEX_00001 ON TGMSDATA.FMATTEND (ATDATE ASC, ATTYPE ASC, ATFILE ASC, ATCARD ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMATTEND_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMATTEND_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00005
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 25560
-- Last Query Use: 11/15/18 4:27:40 PM
-- Estimated Index Creation Time (seconds): 00:00:04
-- Rows in Table when Advised: 277225
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 19
-- Index Type Advised: Encoded vector (not unique)
-- EVI Distinct Values:
 */
CREATE ENCODED VECTOR INDEX TGMSDATA.FDLOTRD_INDEX_00005 ON TGMSDATA.FDLOTRD (LRCRDY ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00005 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00005 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00006
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 25464
-- Last Query Use: 12/22/17 6:31:05 PM
-- Estimated Index Creation Time (seconds): 00:00:11
-- Rows in Table when Advised: 15856
-- Average of Query Estimates (seconds): 7.854225E-5
-- Most Expensive Query Estimate (seconds): 32
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00006 ON TGMSDATA.FDLOTRD (LRSIZE ASC, LRITEM ASC, LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00006 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00006 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMORLHCFG_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 25299
-- Last Query Use: 11/14/18 5:06:52 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 40
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMORLHCFG_INDEX_00002 ON TGMSDATA.FMORLHCFG (HCLIST ASC, HCACTV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMORLHCFG_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FMORLHCFG_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WSSUPINVPF_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 25252
-- Last Query Use: 11/15/18 4:15:59 PM
-- Estimated Index Creation Time (seconds): 00:04:05
-- Rows in Table when Advised: 88017
-- Average of Query Estimates (seconds): 0.9004039
-- Most Expensive Query Estimate (seconds): 47
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WSSUPINVPF_INDEX_00001 ON TGMSDATA.WSSUPINVPF (SIVENNAM ASC, SIAVLDAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WSSUPINVPF_INDEX_00001 */
LABEL ON INDEX TGMSDATA.WSSUPINVPF_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00007
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 24323
-- Last Query Use: 11/12/18 5:20:18 PM
-- Estimated Index Creation Time (seconds): 00:00:12
-- Rows in Table when Advised: 273232
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00007 ON TGMSDATA.FDLOTRD (LRALPH ASC, LRSIZE ASC, LRITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00007 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00007 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FHORDR_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 23983
-- Last Query Use: 11/14/18 5:02:53 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 139243
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 4
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FHORDR_INDEX_00002 ON TGMSDATA.FHORDR (OHORD# ASC, OHSHPC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FHORDR_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FHORDR_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FHORDW_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 23747
-- Last Query Use: 11/14/18 8:41:08 PM
-- Estimated Index Creation Time (seconds): 00:00:05
-- Rows in Table when Advised: 139459
-- Average of Query Estimates (seconds): 0.5088643
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FHORDW_INDEX_00003 ON TGMSDATA.FHORDW (WHINDT ASC, WHBLCU ASC, WHCUST ASC, WHINV# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FHORDW_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FHORDW_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FALITEM_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 23613
-- Last Query Use: 11/14/18 2:15:07 PM
-- Estimated Index Creation Time (seconds): 00:00:08
-- Rows in Table when Advised: 704476
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FALITEM_INDEX_00001 ON TGMSDATA.FALITEM (AICRDY ASC, AIQTOA ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FALITEM_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FALITEM_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WSPOHDRPF_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 21061
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 3040
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WSPOHDRPF_INDEX_00001 ON TGMSDATA.WSPOHDRPF (PHORDNO ASC, PHFLAG ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WSPOHDRPF_INDEX_00001 */
LABEL ON INDEX TGMSDATA.WSPOHDRPF_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 20714
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:51
-- Rows in Table when Advised: 2430802
-- Average of Query Estimates (seconds): 0.34585306
-- Most Expensive Query Estimate (seconds): 24
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00002 ON TGMSDATA.FIORDR (OIITYP ASC, OIORD# ASC, OISIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WSCOHDRPF_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 20564
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 2140
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WSCOHDRPF_INDEX_00001 ON TGMSDATA.WSCOHDRPF (CHORDNO ASC, CHFLAG ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WSCOHDRPF_INDEX_00001 */
LABEL ON INDEX TGMSDATA.WSCOHDRPF_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00006
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 20434
-- Last Query Use: 3/8/16 11:58:04 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1581
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00006 ON TGMSDATA.FFINPPDTAG (FPPRTD ASC, FPINVT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00006 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00006 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FAROPN_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 19848
-- Last Query Use: 8/2/18 8:31:11 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 2119
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FAROPN_INDEX_00001 ON TGMSDATA.FAROPN (ARSEQ# ASC, ARCUST ASC, ARTTYP ASC, ARINV# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FAROPN_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FAROPN_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00008
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 19224
-- Last Query Use: 11/15/18 4:27:30 PM
-- Estimated Index Creation Time (seconds): 00:00:10
-- Rows in Table when Advised: 274371
-- Average of Query Estimates (seconds): 4.1614647E-4
-- Most Expensive Query Estimate (seconds): 14
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00008 ON TGMSDATA.FDLOTRD (LRGLOC ASC, LRCRDY ASC, LRSIZE ASC, LRALPH ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00008 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00008 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FAV_02386C_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 18871
-- Last Query Use: 11/15/18 5:01:31 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 14
-- Average of Query Estimates (seconds): 0.62545705
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FAV_02386C_INDEX_00001 ON TGMSDATA.FAV_02386C (RECORDTYPE ASC, DATEYYYYMMDD ASC, COLUMN2 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FAV_02386C_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FAV_02386C_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FCUTLOT_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 18677
-- Last Query Use: 11/15/18 3:50:21 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 9424
-- Average of Query Estimates (seconds): 2.1416716E-4
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FCUTLOT_INDEX_00004 ON TGMSDATA.FCUTLOT (CLSOWD ASC, CLVEND ASC, CLSIZE ASC, CLITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FCUTLOT_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FCUTLOT_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMORLS_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 18388
-- Last Query Use: 11/13/18 7:07:01 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1395
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMORLS_INDEX_00002 ON TGMSDATA.FMORLS (OLSTAT ASC, OLSIZE ASC, OLITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMORLS_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FMORLS_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FAROPN_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 18113
-- Last Query Use: 11/15/18 6:04:27 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1612
-- Average of Query Estimates (seconds): 0.08441451
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FAROPN_INDEX_00002 ON TGMSDATA.FAROPN (ARSUFF ASC, ARTTYP ASC, ARCUST ASC, ARINV# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FAROPN_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FAROPN_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTINVT_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 17386
-- Last Query Use: 3/8/18 9:41:16 AM
-- Estimated Index Creation Time (seconds): 00:00:07
-- Rows in Table when Advised: 26770
-- Average of Query Estimates (seconds): 3.4510525E-4
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTINVT_INDEX_00001 ON TGMSDATA.FTINVT (ITSIZE ASC, ITITEM ASC, ITDESC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTINVT_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FTINVT_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAYR_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 17252
-- Last Query Use: 11/14/18 1:39:04 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 8484
-- Average of Query Estimates (seconds): 0.5198238
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRAYR_INDEX_00002 ON TGMSDATA.FTRAYR
(TRSIZE ASC, TRITEM ASC, TRCRDT ASC, TRALPH ASC, TRSCYM ASC, TRTAG# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAYR_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FTRAYR_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FSOWNBY_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 16849
-- Last Query Use: 8/22/18 7:38:55 AM
-- Estimated Index Creation Time (seconds): 00:00:39
-- Rows in Table when Advised: 2976940
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 8
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FSOWNBY_INDEX_00001 ON TGMSDATA.FSOWNBY (SBSOWT ASC, SBTIME ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FSOWNBY_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FSOWNBY_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDRWORK_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 16692
-- Last Query Use: 11/14/18 2:45:57 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 31
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDRWORK_INDEX_00001 ON TGMSDATA.FIORDRWORK (OISTAT ASC, OIRVDT ASC, OIORD# ASC, OIITYP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDRWORK_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FIORDRWORK_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDRWORK_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 16688
-- Last Query Use: 11/14/18 2:45:57 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 31
-- Average of Query Estimates (seconds): 0.17251918
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDRWORK_INDEX_00002 ON TGMSDATA.FIORDRWORK (OISTAT ASC, OIRVDT ASC, OIORD# ASC, OISIZE ASC, OIITYP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDRWORK_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FIORDRWORK_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FRBBATCH_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 16616
-- Last Query Use: 11/12/18 9:19:52 AM
-- Estimated Index Creation Time (seconds): 00:00:04
-- Rows in Table when Advised: 241802
-- Average of Query Estimates (seconds): 0.22099182
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FRBBATCH_INDEX_00001 ON TGMSDATA.FRBBATCH (BATCHNUMBER ASC, CART# ASC, BATCHDATE ASC, MSGCODE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FRBBATCH_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FRBBATCH_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FALITEM_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 15916
-- Last Query Use: 11/14/18 2:15:07 PM
-- Estimated Index Creation Time (seconds): 00:00:10
-- Rows in Table when Advised: 704476
-- Average of Query Estimates (seconds): 0.98812515
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FALITEM_INDEX_00002 ON TGMSDATA.FALITEM (AICRDY ASC, AISHPD ASC, AIQTOA ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FALITEM_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FALITEM_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00009
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 15547
-- Last Query Use: 10/3/18 8:32:12 AM
-- Estimated Index Creation Time (seconds): 00:00:08
-- Rows in Table when Advised: 273322
-- Average of Query Estimates (seconds): 2.764392
-- Most Expensive Query Estimate (seconds): 8
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00009 ON TGMSDATA.FDLOTRD (LRCLOC ASC, LRPRCL ASC, LRQTAV ASC, LRCUST ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00009 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00009 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00006
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 15332
-- Last Query Use: 11/15/18 4:02:40 PM
-- Estimated Index Creation Time (seconds): 00:00:06
-- Rows in Table when Advised: 44996
-- Average of Query Estimates (seconds): 0.08915993
-- Most Expensive Query Estimate (seconds): 6
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00006 ON TGMSDATA.FMINVT (IMTPSW ASC, IMPCL1 ASC, IMSIZE ASC, IMITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00006 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00006 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WSPODTLPF_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 15259
-- Last Query Use: 7/31/18 5:29:14 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 4731
-- Average of Query Estimates (seconds): 0.0045874566
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WSPODTLPF_INDEX_00001 ON TGMSDATA.WSPODTLPF
(PDFRORID ASC, PDBRKLNE ASC, PDBRKORID ASC, PDORDNO ASC, PDBRKMAT ASC, PDFLAG ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WSPODTLPF_INDEX_00001 */
LABEL ON INDEX TGMSDATA.WSPODTLPF_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WSSUPINVPF_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 15079
-- Last Query Use: 11/15/18 4:01:07 PM
-- Estimated Index Creation Time (seconds): 00:05:06
-- Rows in Table when Advised: 87434
-- Average of Query Estimates (seconds): 0.0070959614
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WSSUPINVPF_INDEX_00002 ON TGMSDATA.WSSUPINVPF (SIFRORID ASC, SIIDATE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WSSUPINVPF_INDEX_00002 */
LABEL ON INDEX TGMSDATA.WSSUPINVPF_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FRBBATCH_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 14946
-- Last Query Use: 11/12/18 9:19:52 AM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 241802
-- Average of Query Estimates (seconds): 0.8117891
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FRBBATCH_INDEX_00002 ON TGMSDATA.FRBBATCH (BATCHDATE ASC, BATCHNUMBER ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FRBBATCH_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FRBBATCH_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00007
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 14848
-- Last Query Use: 6/27/18 12:47:38 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 43580
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00007 ON TGMSDATA.FMINVT (IMTRYC ASC, IMPCL1 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00007 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00007 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00010
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 13941
-- Last Query Use: 3/24/18 12:23:16 PM
-- Estimated Index Creation Time (seconds): 00:00:09
-- Rows in Table when Advised: 183080
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00010 ON TGMSDATA.FDLOTRD (LRITEM ASC, LRSIZE ASC, LRCRDY ASC, LRGLOC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00010 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00010 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMEMAIL_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 13938
-- Last Query Use: 11/15/18 4:31:06 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 11382
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMEMAIL_INDEX_00004 ON TGMSDATA.FMEMAIL (EMCODE ASC, EMSTAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMEMAIL_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FMEMAIL_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINLOC_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 13821
-- Last Query Use: 8/28/17 4:03:50 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1490
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINLOC_INDEX_00001 ON TGMSDATA.FFINLOC (FLSIZE ASC, FLITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINLOC_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FFINLOC_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMEMPLOY_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 13648
-- Last Query Use: 11/15/18 7:39:23 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 246
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 5
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMEMPLOY_INDEX_00002 ON TGMSDATA.FMEMPLOY (EMCARD ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMEMPLOY_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FMEMPLOY_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 13573
-- Last Query Use: 11/15/18 5:00:08 PM
-- Estimated Index Creation Time (seconds): 00:00:59
-- Rows in Table when Advised: 2431006
-- Average of Query Estimates (seconds): 0.002947027
-- Most Expensive Query Estimate (seconds): 327
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00003 ON TGMSDATA.FIORDR (OISIZE ASC, OIITEM ASC, OISOW ASC, OIPOST ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.NPUTORD_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 13573
-- Last Query Use: 11/14/18 3:40:26 PM
-- Estimated Index Creation Time (seconds): 00:00:08
-- Rows in Table when Advised: 463179
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.NPUTORD_INDEX_00001 ON TGMSDATA.NPUTORD (PDMSTR ASC, PDORD# ASC, PDSHPD ASC, PDLOC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.NPUTORD_INDEX_00001 */
LABEL ON INDEX TGMSDATA.NPUTORD_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FHORDR_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 13037
-- Last Query Use: 11/12/18 4:05:15 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 139014
-- Average of Query Estimates (seconds): 7.670476E-5
-- Most Expensive Query Estimate (seconds): 11
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FHORDR_INDEX_00003 ON TGMSDATA.FHORDR
(OHSTAT ASC, OHORD# ASC, OHSHPC ASC, OHCUST ASC, OHSHCT ASC, OHSHST ASC, OHSHZP ASC, OHORDY ASC, OHDTRY ASC, OHNAME ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FHORDR_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FHORDR_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 12963
-- Last Query Use: 12/21/17 6:29:12 PM
-- Estimated Index Creation Time (seconds): 00:00:59
-- Rows in Table when Advised: 2154952
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00004 ON TGMSDATA.FIORDR (OISTAT ASC, OIITYP ASC, OIORD# ASC, OISIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00005
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 12901
-- Last Query Use: 12/21/17 5:04:26 PM
-- Estimated Index Creation Time (seconds): 00:01:35
-- Rows in Table when Advised: 2154952
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00005 ON TGMSDATA.FIORDR (OISTAT ASC, OISIZE ASC, OIITYP ASC, OIORD# ASC, OIITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00005 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00005 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FSOWNBY_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 12776
-- Last Query Use: 11/15/18 7:39:44 AM
-- Estimated Index Creation Time (seconds): 00:00:46
-- Rows in Table when Advised: 2989461
-- Average of Query Estimates (seconds): 0.9985911
-- Most Expensive Query Estimate (seconds): 8
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FSOWNBY_INDEX_00002 ON TGMSDATA.FSOWNBY (SBCARD ASC, SBTIME ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FSOWNBY_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FSOWNBY_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00008
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 12533
-- Last Query Use: 11/15/18 8:02:18 AM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 44976
-- Average of Query Estimates (seconds): 0.10244954
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00008 ON TGMSDATA.FMINVT (IMPCL1 ASC, IMLOC ASC, IMSIZE ASC, IMITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00008 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00008 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00009
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 12193
-- Last Query Use: 11/15/18 4:54:41 PM
-- Estimated Index Creation Time (seconds): 00:00:04
-- Rows in Table when Advised: 44996
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00009 ON TGMSDATA.FMINVT (IMSIZE ASC, IMDES1 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00009 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00009 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMORLSEAS_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 12192
-- Last Query Use: 10/23/18 4:52:44 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 68
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMORLSEAS_INDEX_00001 ON TGMSDATA.FMORLSEAS (HSSTAT ASC, HSSNCD ASC, HSLIST ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMORLSEAS_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMORLSEAS_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 12176
-- Last Query Use: 5/31/18 4:34:17 PM
-- Estimated Index Creation Time (seconds): 00:01:16
-- Rows in Table when Advised: 2313416
-- Average of Query Estimates (seconds): 3.285151E-4
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00001 ON TGMSDATA.FIORDR (OISIZE ASC, OIORD# ASC, OIITEM ASC, OIRVDT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 12085
-- Last Query Use: 4/5/16 5:22:07 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 6135
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00001 ON TGMSDATA.FFINPPDTAG
(FPSIZE ASC, FPINVT ASC, FPITEM ASC, FPPLTG ASC, FPCUST ASC, FPTIMESTAMP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 11984
-- Last Query Use: 3/23/16 5:22:15 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 3272
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00002 ON TGMSDATA.FFINPPDTAG
(FPSIZE ASC, FPINVT ASC, FPITEM ASC, FPPLTG ASC, FPTIMESTAMP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMORLS_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 11546
-- Last Query Use: 11/13/18 7:07:11 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1395
-- Average of Query Estimates (seconds): 0.9961892
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMORLS_INDEX_00001 ON TGMSDATA.FMORLS (OLSTAT ASC, OLLIST ASC, OLSEQ# ASC, OLLOOK ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMORLS_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMORLS_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRSCHD_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 11095
-- Last Query Use: 12/21/17 3:21:17 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 99403
-- Average of Query Estimates (seconds): 0.004055881
-- Most Expensive Query Estimate (seconds): 9
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRSCHD_INDEX_00001 ON TGMSDATA.FTRSCHD (TRSHDT ASC, TRORD# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRSCHD_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FTRSCHD_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WSPODTLPF_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 10718
-- Last Query Use: 11/15/18 4:06:23 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 32902
-- Average of Query Estimates (seconds): 0.18650867
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WSPODTLPF_INDEX_00001 ON TGMSDATA.WSPODTLPF (PDBRKORID ASC, PDFRORID ASC, PDHDRSEQ ASC, PDCRTDAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WSPODTLPF_INDEX_00001 */
LABEL ON INDEX TGMSDATA.WSPODTLPF_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 10149
-- Last Query Use: 11/15/18 5:00:08 PM
-- Estimated Index Creation Time (seconds): 00:00:42
-- Rows in Table when Advised: 2431006
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 327
-- Index Type Advised: Encoded vector (not unique)
-- EVI Distinct Values:
 */
CREATE ENCODED VECTOR INDEX TGMSDATA.FIORDR_INDEX_00002 ON TGMSDATA.FIORDR (OISIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 10142
-- Last Query Use: 11/15/18 7:01:32 AM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 44976
-- Average of Query Estimates (seconds): 0.0044369944
-- Most Expensive Query Estimate (seconds): 6
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00001 ON TGMSDATA.FMINVT (IMSTAT ASC, IMSOWC ASC, IMLOTC ASC, IMSIZE ASC, IMITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WSPODTLPF_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 9880
-- Last Query Use: 7/10/18 3:40:41 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 4459
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WSPODTLPF_INDEX_00002 ON TGMSDATA.WSPODTLPF (PDORDNO ASC, PDORDLIN ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WSPODTLPF_INDEX_00002 */
LABEL ON INDEX TGMSDATA.WSPODTLPF_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FCARTDT_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 9155
-- Last Query Use: 6/28/18 2:13:48 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 84403
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FCARTDT_INDEX_00001 ON TGMSDATA.FCARTDT (CDCART ASC, CDTIME ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FCARTDT_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FCARTDT_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FLABL_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 9153
-- Last Query Use: 11/15/18 8:02:18 AM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 347
-- Average of Query Estimates (seconds): 0.70599806
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FLABL_INDEX_00001 ON TGMSDATA.FLABL (LASIZE ASC, LAITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FLABL_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FLABL_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMEMAIL_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 8750
-- Last Query Use: 11/14/18 8:41:08 PM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 11382
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMEMAIL_INDEX_00001 ON TGMSDATA.FMEMAIL (EMACCT ASC, EMCODE ASC, EMAIL ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMEMAIL_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMEMAIL_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WSSUPINVPF_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 8416
-- Last Query Use: 11/14/18 3:31:38 AM
-- Estimated Index Creation Time (seconds): 00:05:05
-- Rows in Table when Advised: 50498
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WSSUPINVPF_INDEX_00001 ON TGMSDATA.WSSUPINVPF (SIIDATE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WSSUPINVPF_INDEX_00001 */
LABEL ON INDEX TGMSDATA.WSSUPINVPF_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FSOWNBY_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 8256
-- Last Query Use: 11/15/18 7:39:44 AM
-- Estimated Index Creation Time (seconds): 00:00:45
-- Rows in Table when Advised: 2989461
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 8
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FSOWNBY_INDEX_00001 ON TGMSDATA.FSOWNBY (SBTAG# ASC, SBTIME ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FSOWNBY_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FSOWNBY_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRSCHD_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 8118
-- Last Query Use: 11/14/18 3:40:26 PM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 108265
-- Average of Query Estimates (seconds): 0.039418574
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRSCHD_INDEX_00002 ON TGMSDATA.FTRSCHD (TRTRK# ASC, TRSHDT ASC, TRORD# ASC, TRCODC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRSCHD_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FTRSCHD_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAYFIXED_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 7991
-- Last Query Use: 11/15/18 7:38:32 AM
-- Estimated Index Creation Time (seconds): 00:00:08
-- Rows in Table when Advised: 301043
-- Average of Query Estimates (seconds): 0.1371543
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRAYFIXED_INDEX_00001 ON TGMSDATA.FTRAYFIXED (TFCARD ASC, TFTAG# ASC, TFCART ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAYFIXED_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FTRAYFIXED_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 7767
-- Last Query Use: 11/13/18 7:07:01 AM
-- Estimated Index Creation Time (seconds): 00:00:04
-- Rows in Table when Advised: 44952
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00002 ON TGMSDATA.FMINVT (IMITEM ASC, IMSIZE ASC, IMLIST ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVTDESC_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 7762
-- Last Query Use: 11/13/18 7:07:01 AM
-- Estimated Index Creation Time (seconds): 00:00:19
-- Rows in Table when Advised: 46348
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVTDESC_INDEX_00001 ON TGMSDATA.FMINVTDESC (IDNARA ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVTDESC_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMINVTDESC_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINLOC_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 7588
-- Last Query Use: 11/15/18 11:28:32 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 280
-- Average of Query Estimates (seconds): 0.99617815
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINLOC_INDEX_00001 ON TGMSDATA.FFINLOC
(FLNORS ASC, FLSECT ASC, FLEORW ASC, FLBAY ASC, FLGHSE ASC, FLSRTP ASC, FLENDP ASC, FLTAG# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINLOC_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FFINLOC_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAYR_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 7529
-- Last Query Use: 11/13/18 3:59:33 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 8539
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRAYR_INDEX_00001 ON TGMSDATA.FTRAYR (TRSTAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAYR_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FTRAYR_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAYR_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 7455
-- Last Query Use: 11/13/18 3:59:33 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 8539
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRAYR_INDEX_00002 ON TGMSDATA.FTRAYR (TRSIZE ASC, TRITEM ASC, TRSTAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAYR_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FTRAYR_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAYR_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 7455
-- Last Query Use: 11/13/18 3:59:33 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 8539
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRAYR_INDEX_00003 ON TGMSDATA.FTRAYR (TRSIZE ASC, TRSTAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAYR_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FTRAYR_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FSOWNBY_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 7407
-- Last Query Use: 11/15/18 7:39:23 AM
-- Estimated Index Creation Time (seconds): 00:00:52
-- Rows in Table when Advised: 2989461
-- Average of Query Estimates (seconds): 0.9426218
-- Most Expensive Query Estimate (seconds): 6
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FSOWNBY_INDEX_00002 ON TGMSDATA.FSOWNBY (SBSOWT ASC, SBCARD ASC, SBTIME ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FSOWNBY_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FSOWNBY_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAY_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 7364
-- Last Query Use: 12/22/17 7:39:09 AM
-- Estimated Index Creation Time (seconds): 00:00:12
-- Rows in Table when Advised: 313752
-- Average of Query Estimates (seconds): 2.7159153E-4
-- Most Expensive Query Estimate (seconds): 8
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRAY_INDEX_00001 ON TGMSDATA.FTRAY (TRSIZE ASC, TRITEM ASC, TRCRDT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAY_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FTRAY_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMORLH_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 7149
-- Last Query Use: 6/1/18 3:29:21 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 36
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMORLH_INDEX_00001 ON TGMSDATA.FMORLH (HLDESC ASC, HLLIST ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMORLH_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMORLH_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVTDESC_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 6940
-- Last Query Use: 11/6/18 7:01:34 AM
-- Estimated Index Creation Time (seconds): 00:00:20
-- Rows in Table when Advised: 46292
-- Average of Query Estimates (seconds): 0.037463978
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVTDESC_INDEX_00002 ON TGMSDATA.FMINVTDESC (IDSIZE ASC, IDITEM ASC, IDNARA ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVTDESC_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FMINVTDESC_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FFINPPDTAG_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 6686
-- Last Query Use: 3/23/16 5:22:15 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 3272
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FFINPPDTAG_INDEX_00003 ON TGMSDATA.FFINPPDTAG
(FPSIZE ASC, FPINVT ASC, FPWEEK ASC, FPITEM ASC, FPPLTG ASC, FPCUST ASC, FPTIMESTAMP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FFINPPDTAG_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FFINPPDTAG_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 6648
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 44836
-- Average of Query Estimates (seconds): 0.0013537906
-- Most Expensive Query Estimate (seconds): 47
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00003 ON TGMSDATA.FMINVT (IMFRSZ ASC, IMSTAT ASC, IMSIZE ASC, IMITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WSCODTLPF_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 6544
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 86995
-- Average of Query Estimates (seconds): 0.99816626
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WSCODTLPF_INDEX_00001 ON TGMSDATA.WSCODTLPF (CDORDNO ASC, CDORDLIN ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WSCODTLPF_INDEX_00001 */
LABEL ON INDEX TGMSDATA.WSCODTLPF_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FSOWNBY_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 6448
-- Last Query Use: 11/15/18 7:39:23 AM
-- Estimated Index Creation Time (seconds): 00:00:51
-- Rows in Table when Advised: 2989461
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 8
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FSOWNBY_INDEX_00003 ON TGMSDATA.FSOWNBY (SBSOWT ASC, SBTAG# ASC, SBTIME ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FSOWNBY_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FSOWNBY_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 6431
-- Last Query Use: 5/9/16 4:06:50 PM
-- Estimated Index Creation Time (seconds): 00:01:54
-- Rows in Table when Advised: 1725319
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00003 ON TGMSDATA.FIORDR (OIITYP ASC, OIITEM ASC, OIORD# ASC, OIDES1 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 6431
-- Last Query Use: 5/9/16 4:06:50 PM
-- Estimated Index Creation Time (seconds): 00:01:07
-- Rows in Table when Advised: 1725319
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00004 ON TGMSDATA.FIORDR (OIITYP ASC, OISIZE ASC, OIORD# ASC, OIITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDW_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 6423
-- Last Query Use: 11/15/18 5:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:30
-- Rows in Table when Advised: 2316825
-- Average of Query Estimates (seconds): 0.0018682858
-- Most Expensive Query Estimate (seconds): 20
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDW_INDEX_00001 ON TGMSDATA.FIORDW (WIORD# ASC, WISEQP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDW_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FIORDW_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FHORDR_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 6031
-- Last Query Use: 11/13/18 10:13:48 AM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 139042
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FHORDR_INDEX_00001 ON TGMSDATA.FHORDR (OHCUST ASC, OHCOMP ASC, OHSTAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FHORDR_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FHORDR_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WRITE_SHP_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 6001
-- Last Query Use: 11/14/18 8:06:10 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 11559
-- Average of Query Estimates (seconds): 0.2926179
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WRITE_SHP_INDEX_00001 ON TGMSDATA.WRITE_SHP (ORDER_4 ASC, MASTER# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WRITE_SHP_INDEX_00001 */
LABEL ON INDEX TGMSDATA.WRITE_SHP_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00005
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5865
-- Last Query Use: 11/15/18 1:02:49 PM
-- Estimated Index Creation Time (seconds): 00:01:28
-- Rows in Table when Advised: 2430694
-- Average of Query Estimates (seconds): 0.24825235
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00005 ON TGMSDATA.FIORDR
(OISTAT ASC, OISEQ# ASC, OIITYP ASC, OISIZE ASC, OIORD# ASC, OIITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00005 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00005 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FCUSTCOM_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5845
-- Last Query Use: 6/28/18 10:45:06 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 12771
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FCUSTCOM_INDEX_00001 ON TGMSDATA.FCUSTCOM (CCSEQ ASC, CCUST ASC, CCCRED ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FCUSTCOM_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FCUSTCOM_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5824
-- Last Query Use: 2/23/17 4:28:39 PM
-- Estimated Index Creation Time (seconds): 00:00:11
-- Rows in Table when Advised: 111714
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00001 ON TGMSDATA.FDLOTRD (LRSIZE ASC, LRGLOC ASC, LRCUST ASC, LRCRDY ASC, LRITEM ASC, LRSOWD ASC, LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FAROPN_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5787
-- Last Query Use: 11/10/18 8:16:05 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1523
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FAROPN_INDEX_00001 ON TGMSDATA.FAROPN (ARSUFF ASC, ARSEQ# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FAROPN_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FAROPN_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WRITE_SHP_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5764
-- Last Query Use: 11/14/18 8:06:10 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 11765
-- Average of Query Estimates (seconds): 0.30655795
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WRITE_SHP_INDEX_00002 ON TGMSDATA.WRITE_SHP (ORDER_5 ASC, MASTER# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WRITE_SHP_INDEX_00002 */
LABEL ON INDEX TGMSDATA.WRITE_SHP_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMORLSEAS_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5756
-- Last Query Use: 10/23/18 4:52:44 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 68
-- Average of Query Estimates (seconds): 0.28578874
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMORLSEAS_INDEX_00001 ON TGMSDATA.FMORLSEAS (HSSTAT ASC, HSLIST ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMORLSEAS_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMORLSEAS_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMORLS_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5720
-- Last Query Use: 10/22/18 7:06:47 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1424
-- Average of Query Estimates (seconds): 0.095104896
-- Most Expensive Query Estimate (seconds): 327
-- Index Type Advised: Encoded vector (not unique)
-- EVI Distinct Values:
 */
CREATE ENCODED VECTOR INDEX TGMSDATA.FMORLS_INDEX_00002 ON TGMSDATA.FMORLS (OLLIST ASC, OLITEM ASC, OLSIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMORLS_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FMORLS_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WRITE_SHP_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5558
-- Last Query Use: 11/14/18 8:06:10 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 11765
-- Average of Query Estimates (seconds): 0.3098237
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WRITE_SHP_INDEX_00003 ON TGMSDATA.WRITE_SHP (ORDER_3 ASC, MASTER# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WRITE_SHP_INDEX_00003 */
LABEL ON INDEX TGMSDATA.WRITE_SHP_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRSCHD_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5538
-- Last Query Use: 11/15/18 1:02:49 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 108266
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRSCHD_INDEX_00003 ON TGMSDATA.FTRSCHD (TRTRK# ASC, TRSHDT ASC, TRSTOP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRSCHD_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FTRSCHD_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00006
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5458
-- Last Query Use: 7/31/18 9:14:59 AM
-- Estimated Index Creation Time (seconds): 00:00:54
-- Rows in Table when Advised: 2336880
-- Average of Query Estimates (seconds): 3.664346E-4
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00006 ON TGMSDATA.FIORDR (OIORD# ASC, OIITEM ASC, OISEQ# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00006 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00006 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5423
-- Last Query Use: 11/15/18 2:26:37 PM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 44996
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00004 ON TGMSDATA.FMINVT (IMORDD ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00005
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5239
-- Last Query Use: 11/15/18 8:02:18 AM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 44976
-- Average of Query Estimates (seconds): 0.9034167
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00005 ON TGMSDATA.FMINVT (IMPCL1 ASC, IMSIZE ASC, IMITEM ASC, IMTRYC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00005 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00005 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FHORDR_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5172
-- Last Query Use: 11/9/18 12:01:21 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 138890
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 26
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FHORDR_INDEX_00002 ON TGMSDATA.FHORDR
(OHORD# ASC, OHCUST ASC, OHSHP2 ASC, OHSHP3 ASC, OHSHP4 ASC, OHSHPC ASC, OHSHST ASC, OHSHZP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FHORDR_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FHORDR_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMORLH_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5024
-- Last Query Use: 6/1/18 3:29:21 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 36
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMORLH_INDEX_00002 ON TGMSDATA.FMORLH (HLLIST ASC, HLDESC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMORLH_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FMORLH_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WRITE_SHP_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 5015
-- Last Query Use: 11/14/18 8:06:10 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 11765
-- Average of Query Estimates (seconds): 0.3332004
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WRITE_SHP_INDEX_00004 ON TGMSDATA.WRITE_SHP (ORDER_2 ASC, MASTER# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WRITE_SHP_INDEX_00004 */
LABEL ON INDEX TGMSDATA.WRITE_SHP_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRSCHD_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 4940
-- Last Query Use: 11/15/18 1:02:49 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 108266
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRSCHD_INDEX_00004 ON TGMSDATA.FTRSCHD (TRROUT ASC, TRSHDT ASC, TRSTOP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRSCHD_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FTRSCHD_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WRITE_SHP_INDEX_00005
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 4802
-- Last Query Use: 11/14/18 8:06:10 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 11765
-- Average of Query Estimates (seconds): 0.36109954
-- Most Expensive Query Estimate (seconds): 4
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WRITE_SHP_INDEX_00005 ON TGMSDATA.WRITE_SHP (ORDER_1 ASC, MASTER# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WRITE_SHP_INDEX_00005 */
LABEL ON INDEX TGMSDATA.WRITE_SHP_INDEX_00005 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00006
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 4578
-- Last Query Use: 8/12/18 9:22:38 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 44310
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 12
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00006 ON TGMSDATA.FMINVT (IMLOTC ASC, IMSTAT ASC, IMSIZE ASC, IMSOWC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00006 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00006 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00007
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 4545
-- Last Query Use: 11/14/18 3:54:12 PM
-- Estimated Index Creation Time (seconds): 00:00:40
-- Rows in Table when Advised: 2429155
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 327
-- Index Type Advised: Encoded vector (not unique)
-- EVI Distinct Values:
 */
CREATE ENCODED VECTOR INDEX TGMSDATA.FIORDR_INDEX_00007 ON TGMSDATA.FIORDR (OIORD# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00007 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00007 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00008
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 4495
-- Last Query Use: 11/13/18 3:02:19 PM
-- Estimated Index Creation Time (seconds): 00:00:53
-- Rows in Table when Advised: 2425994
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00008 ON TGMSDATA.FIORDR (OISTAT ASC, OIITYP ASC, OIORD# ASC, OIRQTY ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00008 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00008 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAYFIXED_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 4424
-- Last Query Use: 11/15/18 7:38:32 AM
-- Estimated Index Creation Time (seconds): 00:00:06
-- Rows in Table when Advised: 301043
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRAYFIXED_INDEX_00002 ON TGMSDATA.FTRAYFIXED (TFTAG# ASC, TFCARD ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAYFIXED_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FTRAYFIXED_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOT_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 4236
-- Last Query Use: 8/22/18 2:07:58 PM
-- Estimated Index Creation Time (seconds): 00:00:09
-- Rows in Table when Advised: 316229
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOT_INDEX_00001 ON TGMSDATA.FDLOT (LDSIZE ASC, LDCRDY ASC, LDITEM ASC, LDSOWD ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOT_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FDLOT_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FCUTNEED_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 4211
-- Last Query Use: 11/15/18 4:58:46 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 13609
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FCUTNEED_INDEX_00001 ON TGMSDATA.FCUTNEED (CNITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FCUTNEED_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FCUTNEED_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00007
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 4176
-- Last Query Use: 11/15/18 8:02:18 AM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 44976
-- Average of Query Estimates (seconds): 0.631705
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00007 ON TGMSDATA.FMINVT (IMPCL1 ASC, IMTRYC ASC, IMSIZE ASC, IMITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00007 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00007 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FARLCD_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 4087
-- Last Query Use: 11/14/18 8:31:03 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 46234
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FARLCD_INDEX_00001 ON TGMSDATA.FARLCD (ARCUST ASC, ARINV# ASC, ARLMLC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FARLCD_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FARLCD_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FSOWNBY_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 4051
-- Last Query Use: 11/15/18 7:39:33 AM
-- Estimated Index Creation Time (seconds): 00:00:33
-- Rows in Table when Advised: 2989461
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 8
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FSOWNBY_INDEX_00004 ON TGMSDATA.FSOWNBY (SBTIME ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FSOWNBY_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FSOWNBY_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FAROPN_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 4050
-- Last Query Use: 11/14/18 8:16:07 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1611
-- Average of Query Estimates (seconds): 0.0054320986
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FAROPN_INDEX_00002 ON TGMSDATA.FAROPN (ARSEQ# ASC, ARSUFF ASC, ARCUST ASC, ARINV# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FAROPN_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FAROPN_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.NPUTSCN_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 4032
-- Last Query Use: 11/14/18 3:41:56 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 286952
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.NPUTSCN_INDEX_00001 ON TGMSDATA.NPUTSCN (PSORD# ASC, PSCSCN ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.NPUTSCN_INDEX_00001 */
LABEL ON INDEX TGMSDATA.NPUTSCN_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.NPUTSCN_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 4030
-- Last Query Use: 11/14/18 3:41:56 PM
-- Estimated Index Creation Time (seconds): 00:00:06
-- Rows in Table when Advised: 286952
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.NPUTSCN_INDEX_00002 ON TGMSDATA.NPUTSCN (PSSIZE ASC, PSORD# ASC, PSITEM ASC, PSCSCN ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.NPUTSCN_INDEX_00002 */
LABEL ON INDEX TGMSDATA.NPUTSCN_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMCUST_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3983
-- Last Query Use: 11/15/18 11:51:11 AM
-- Estimated Index Creation Time (seconds): 00:00:14
-- Rows in Table when Advised: 13063
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 30
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMCUST_INDEX_00001 ON TGMSDATA.FMCUST (CMNAME ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMCUST_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMCUST_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDWTM_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3952
-- Last Query Use: 11/15/18 4:39:59 PM
-- Estimated Index Creation Time (seconds): 00:00:06
-- Rows in Table when Advised: 332793
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDWTM_INDEX_00001 ON TGMSDATA.FIORDWTM (WIITEM ASC, WIINV# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDWTM_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FIORDWTM_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FAROPN_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3924
-- Last Query Use: 11/14/18 8:31:03 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1611
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FAROPN_INDEX_00003 ON TGMSDATA.FAROPN (ARINV# ASC, ARCUST ASC, ARTDAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FAROPN_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FAROPN_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3887
-- Last Query Use: 9/20/17 6:30:59 PM
-- Estimated Index Creation Time (seconds): 00:00:12
-- Rows in Table when Advised: 277086
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00002 ON TGMSDATA.FDLOTRD (LRSOWD ASC, LRGLOC ASC, LRCUST ASC, LRSIZE ASC, LRCRDY ASC, LRITEM ASC, LRQTAV ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMANUALD_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3871
-- Last Query Use: 5/24/17 4:19:14 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 1767
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 9
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMANUALD_INDEX_00001 ON TGMSDATA.FMANUALD (MNDATE ASC, MNORD# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMANUALD_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMANUALD_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00009
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3746
-- Last Query Use: 5/6/18 11:24:12 AM
-- Estimated Index Creation Time (seconds): 00:00:38
-- Rows in Table when Advised: 2269754
-- Average of Query Estimates (seconds): 0.027229045
-- Most Expensive Query Estimate (seconds): 25
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00009 ON TGMSDATA.FIORDR (OIITYP ASC, OIITEM ASC, OIORD# ASC, OISIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00009 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00009 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00008
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3712
-- Last Query Use: 11/14/18 7:20:17 PM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 44974
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00008 ON TGMSDATA.FMINVT (IMDES1 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00008 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00008 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMORLS_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3703
-- Last Query Use: 6/18/18 4:55:08 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 2069
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Encoded vector (not unique)
-- EVI Distinct Values:
 */
CREATE ENCODED VECTOR INDEX TGMSDATA.FMORLS_INDEX_00003 ON TGMSDATA.FMORLS (OLLIST ASC, OLSIZE ASC, OLITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMORLS_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FMORLS_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00009
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3691
-- Last Query Use: 11/15/18 4:27:40 PM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 44838
-- Average of Query Estimates (seconds): 0.99756163
-- Most Expensive Query Estimate (seconds): 12
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00009 ON TGMSDATA.FMINVT (IMSTAT ASC, IMLOOK ASC, IMSIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00009 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00009 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMTRAN_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3580
-- Last Query Use: 11/15/18 4:46:01 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 38133
-- Average of Query Estimates (seconds): 0.0025139665
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMTRAN_INDEX_00001 ON TGMSDATA.FMTRAN (MTGLAC ASC, MTSTAT ASC, MTTDAT ASC, MTTTYP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMTRAN_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMTRAN_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WRITE_SHPX_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3546
-- Last Query Use: 11/14/18 8:06:10 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 2886
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 4
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WRITE_SHPX_INDEX_00001 ON TGMSDATA.WRITE_SHPX (MASTER# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WRITE_SHPX_INDEX_00001 */
LABEL ON INDEX TGMSDATA.WRITE_SHPX_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDW_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3528
-- Last Query Use: 11/14/18 1:39:14 PM
-- Estimated Index Creation Time (seconds): 00:01:30
-- Rows in Table when Advised: 2316715
-- Average of Query Estimates (seconds): 1.0510204
-- Most Expensive Query Estimate (seconds): 26
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDW_INDEX_00002 ON TGMSDATA.FIORDW (WISIZE ASC, WIITEM ASC, WIDTRQ ASC, WIINV# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDW_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FIORDW_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDRWORK_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3525
-- Last Query Use: 9/15/17 3:57:08 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 7
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDRWORK_INDEX_00001 ON TGMSDATA.FIORDRWORK (OISTAT ASC, OIORD# ASC, OIRVDT ASC, OIITYP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDRWORK_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FIORDRWORK_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FALITEM_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3446
-- Last Query Use: 11/14/18 2:15:07 PM
-- Estimated Index Creation Time (seconds): 00:00:05
-- Rows in Table when Advised: 704476
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FALITEM_INDEX_00001 ON TGMSDATA.FALITEM (AIQTOA ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FALITEM_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FALITEM_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FSOHST_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3378
-- Last Query Use: 11/14/18 12:33:14 PM
-- Estimated Index Creation Time (seconds): 00:01:29
-- Rows in Table when Advised: 2024570
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 5
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FSOHST_INDEX_00001 ON TGMSDATA.FSOHST (SOSHDT ASC, SOCUST ASC, SOORD# ASC, SODES1 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FSOHST_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FSOHST_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00010
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3114
-- Last Query Use: 11/14/18 7:20:17 PM
-- Estimated Index Creation Time (seconds): 00:00:03
-- Rows in Table when Advised: 44974
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00010 ON TGMSDATA.FMINVT (IMITEM ASC, IMDES1 ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00010 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00010 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WSPOHDRPF_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 3050
-- Last Query Use: 11/15/18 3:21:55 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 3094
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WSPOHDRPF_INDEX_00001 ON TGMSDATA.WSPOHDRPF (PHFRORID ASC, PHBRKORID ASC, PHFLAG ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WSPOHDRPF_INDEX_00001 */
LABEL ON INDEX TGMSDATA.WSPOHDRPF_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTCOST_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2900
-- Last Query Use: 8/3/18 5:11:37 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 97
-- Average of Query Estimates (seconds): 0.7237931
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTCOST_INDEX_00001 ON TGMSDATA.FTCOST (TCSIZE ASC, TCSTYP ASC, TCSEQ# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTCOST_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FTCOST_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FHORDR_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2878
-- Last Query Use: 12/22/17 8:40:58 AM
-- Estimated Index Creation Time (seconds): 00:00:04
-- Rows in Table when Advised: 124581
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FHORDR_INDEX_00003 ON TGMSDATA.FHORDR (OHSTAT ASC, OHARCU ASC, OHROUT ASC, OHSTOP ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FHORDR_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FHORDR_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FHORDR_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2878
-- Last Query Use: 12/22/17 8:40:58 AM
-- Estimated Index Creation Time (seconds): 00:00:04
-- Rows in Table when Advised: 124581
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FHORDR_INDEX_00004 ON TGMSDATA.FHORDR (OHSTAT ASC, OHARCU ASC, OHDTRY ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FHORDR_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FHORDR_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FALITEM_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2858
-- Last Query Use: 11/15/18 5:03:14 PM
-- Estimated Index Creation Time (seconds): 00:00:07
-- Rows in Table when Advised: 704644
-- Average of Query Estimates (seconds): 3.4989504E-4
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FALITEM_INDEX_00002 ON TGMSDATA.FALITEM (AIGLOC ASC, AIORD# ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FALITEM_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FALITEM_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00011
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2846
-- Last Query Use: 8/3/18 5:11:36 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 44358
-- Average of Query Estimates (seconds): 0.01054111
-- Most Expensive Query Estimate (seconds): 3
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00011 ON TGMSDATA.FMINVT (IMLOTC ASC, IMSTAT ASC, IMSIZE ASC, IMSOWC ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00011 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00011 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2806
-- Last Query Use: 10/26/18 4:06:08 AM
-- Estimated Index Creation Time (seconds): 00:00:10
-- Rows in Table when Advised: 274534
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00003 ON TGMSDATA.FDLOTRD (LRGLOC ASC, LRITEM ASC, LRSIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00012
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2775
-- Last Query Use: 11/15/18 4:27:30 PM
-- Estimated Index Creation Time (seconds): 00:00:02
-- Rows in Table when Advised: 44996
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 47
-- Index Type Advised: Encoded vector (not unique)
-- EVI Distinct Values:
 */
CREATE ENCODED VECTOR INDEX TGMSDATA.FMINVT_INDEX_00012 ON TGMSDATA.FMINVT (IMSIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00012 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00012 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WSPOHDRPF_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2735
-- Last Query Use: 11/15/18 4:06:33 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 3095
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WSPOHDRPF_INDEX_00002 ON TGMSDATA.WSPOHDRPF (PHIDATE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WSPOHDRPF_INDEX_00002 */
LABEL ON INDEX TGMSDATA.WSPOHDRPF_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.WSCODTLPF_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2704
-- Last Query Use: 11/15/18 4:06:23 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 87031
-- Average of Query Estimates (seconds): 0.09689349
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.WSCODTLPF_INDEX_00002 ON TGMSDATA.WSCODTLPF (CDBRKORID ASC, CDREFID ASC, CDCRTDAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.WSCODTLPF_INDEX_00002 */
LABEL ON INDEX TGMSDATA.WSCODTLPF_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMINVT_INDEX_00013
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2611
-- Last Query Use: 11/15/18 7:01:01 AM
-- Estimated Index Creation Time (seconds): 00:00:06
-- Rows in Table when Advised: 44976
-- Average of Query Estimates (seconds): 0.5672156
-- Most Expensive Query Estimate (seconds): 6
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMINVT_INDEX_00013 ON TGMSDATA.FMINVT (IMLBS# ASC, IMSUOM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMINVT_INDEX_00013 */
LABEL ON INDEX TGMSDATA.FMINVT_INDEX_00013 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FDLOTRD_INDEX_00004
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2607
-- Last Query Use: 10/26/18 4:06:08 AM
-- Estimated Index Creation Time (seconds): 00:00:11
-- Rows in Table when Advised: 274534
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 4
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FDLOTRD_INDEX_00004 ON TGMSDATA.FDLOTRD (LRITEM ASC, LRGLOC ASC, LRSIZE ASC, LRCRDY ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FDLOTRD_INDEX_00004 */
LABEL ON INDEX TGMSDATA.FDLOTRD_INDEX_00004 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FHORDR_INDEX_00005
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2599
-- Last Query Use: 11/15/18 4:06:33 PM
-- Estimated Index Creation Time (seconds): 00:00:10
-- Rows in Table when Advised: 139369
-- Average of Query Estimates (seconds): 0.049634475
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FHORDR_INDEX_00005 ON TGMSDATA.FHORDR
(OHSTAT ASC, OHDTRY ASC, OHORD# ASC, OHCUST ASC, OHBLCU ASC, OHNAME ASC, OHSHPC ASC, OHDTOR ASC, OHSHCT ASC, OHSHST ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FHORDR_INDEX_00005 */
LABEL ON INDEX TGMSDATA.FHORDR_INDEX_00005 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRHDRH_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2597
-- Last Query Use: 10/18/18 9:20:28 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 17505
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRHDRH_INDEX_00001 ON TGMSDATA.FTRHDRH (THDRIV ASC, THSHDT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRHDRH_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FTRHDRH_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.RB_SHIPVIA_EQUIVALENT_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2536
-- Last Query Use: 10/1/18 1:15:11 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 7
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.RB_SHIPVIA_EQUIVALENT_INDEX_00001 ON TGMSDATA.RB_SHIPVIA_EQUIVALENT (ORIGINALSHIPVIACODE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.RB_SHIPVIA_EQUIVALENT_INDEX_00001 */
LABEL ON INDEX TGMSDATA.RB_SHIPVIA_EQUIVALENT_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FTRAYFIXED_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2472
-- Last Query Use: 11/15/18 7:39:33 AM
-- Estimated Index Creation Time (seconds): 00:00:06
-- Rows in Table when Advised: 301043
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 2
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FTRAYFIXED_INDEX_00003 ON TGMSDATA.FTRAYFIXED (TFCARD ASC, TFCART ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FTRAYFIXED_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FTRAYFIXED_INDEX_00003 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FMEMAIL_INDEX_00002
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2426
-- Last Query Use: 7/13/17 11:52:06 AM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 8194
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMEMAIL_INDEX_00002 ON TGMSDATA.FMEMAIL (EMCODE ASC, EMACCT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMEMAIL_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FMEMAIL_INDEX_00002 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDR_INDEX_00010
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2419
-- Last Query Use: 11/14/18 5:02:53 PM
-- Estimated Index Creation Time (seconds): 00:01:42
-- Rows in Table when Advised: 2429185
-- Average of Query Estimates (seconds): 4.1339395E-4
-- Most Expensive Query Estimate (seconds): 24
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDR_INDEX_00010 ON TGMSDATA.FIORDR (OISTAT ASC, OISIZE ASC, OIITEM ASC, OISOW ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDR_INDEX_00010 */
LABEL ON INDEX TGMSDATA.FIORDR_INDEX_00010 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.XREF_FMINVT_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2417
-- Last Query Use: 11/15/18 4:27:40 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 74218
-- Average of Query Estimates (seconds): 0.31071576
-- Most Expensive Query Estimate (seconds): 47
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.XREF_FMINVT_INDEX_00001 ON TGMSDATA.XREF_FMINVT (PROVIDEDBYID ASC, LOCALITEMSIZE ASC, LOCALITEMNUMBER ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.XREF_FMINVT_INDEX_00001 */
LABEL ON INDEX TGMSDATA.XREF_FMINVT_INDEX_00001 IS 'Index generated from Index Advisor';

/*
Creating index TGMSDATA.FIORDW_INDEX_00003
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA
-- Times Advised for Query Use: 2253
-- Last Query Use: 11/14/18 8:41:08 PM
-- Estimated Index Creation Time (seconds): 00:00:31
-- Rows in Table when Advised: 2316825
-- Average of Query Estimates (seconds): 0.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FIORDW_INDEX_00003 ON TGMSDATA.FIORDW (WIINV# ASC, WIITEM ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FIORDW_INDEX_00003 */
LABEL ON INDEX TGMSDATA.FIORDW_INDEX_00003 IS 'Index generated from Index Advisor';


