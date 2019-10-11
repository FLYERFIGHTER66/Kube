CREATE OR REPLACE PROCEDURE create_missing_INV020_Run_LOG for system name INV020
      LANGUAGE SQL
      BEGIN

    DECLARE object_not_found  CONDITION FOR '38501';
    DECLARE CONTINUE HANDLER FOR object_not_found
         SET v_build_table = 'Y';
    -- Check that the table actually exists
    -- (if the object doesn't exist, the CONTINUE above handler will be called)
    CALL QCMDEXC('CHKOBJ *LIBL/INV020_LOG *FILE');

    IF v_build_table = 'Y' THEN
        CREATE TABLE INV020_Run_LOG FOR SYSTEM NAME INV020_LOG (
        	DESCRIPTION FOR COLUMN DESCR00001 VARCHAR(256) CCSID 37 DEFAULT NULL ,
        	CREATED_TS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
        	CREATED_BY CHAR(18) CCSID 37 NOT NULL DEFAULT USER ) RCDFMT INV020RCD ;
    END IF;

END;

--drop PROCEDURE kubepak400.create_missing_INV020_Run_LOG
