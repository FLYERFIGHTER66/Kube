/*
Creating index TGMSDATA.FCUTORD_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA.FCUTORD
-- Times Advised for Query Use: 1468
-- Last Query Use: 11/14/18 4:01:14 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 14447
-- Average of Query Estimates (seconds): 0.0020435967
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FCUTORD_INDEX_00002 ON TGMSDATA.FCUTORD (COSTAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FCUTORD_INDEX_00002 */
LABEL ON INDEX TGMSDATA.FCUTORD_INDEX_00002 IS 'FCUTORD: STAT';
