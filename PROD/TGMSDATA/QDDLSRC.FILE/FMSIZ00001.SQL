/*
Creating index TGMSDATA.FMSIZC_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA.FMSIZC
-- Times Advised for Query Use: 51283614
-- Last Query Use: 9/18/17 4:15:56 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 285
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 268
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FMSIZC_INDEX_00001 ON TGMSDATA.FMSIZC (SCCATG ASC, SCSIZE ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FMSIZC_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FMSIZC_INDEX_00001 IS 'FMSIZC: CATG SIZE';

