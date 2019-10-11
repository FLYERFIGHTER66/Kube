/*
Creating index TGMSDATA.FCUTORD_INDEX_00001
When creating this index the database connection should have a sort sequence of *HEX.
-- System name: Localhost
-- Database: S105r9ym         Condensed Index Advice for TGMSDATA.FCUTORD
-- Times Advised for Query Use: 44036764
-- Last Query Use: 11/15/18 4:07:14 PM
-- Estimated Index Creation Time (seconds): 00:00:01
-- Rows in Table when Advised: 14141
-- Average of Query Estimates (seconds): 1.0
-- Most Expensive Query Estimate (seconds): 1
-- Index Type Advised: Not unique
 */
CREATE INDEX TGMSDATA.FCUTORD_INDEX_00001 ON TGMSDATA.FCUTORD (COVEND ASC, COSIZE ASC, COSOWD ASC, COITEM ASC, COSTAT ASC) UNIT ANY  KEEP IN MEMORY NO ;

/* Setting label text for TGMSDATA.FCUTORD_INDEX_00001 */
LABEL ON INDEX TGMSDATA.FCUTORD_INDEX_00001 IS 'FCUTORD: VEND SIZE SOWD ITEM STAT';
