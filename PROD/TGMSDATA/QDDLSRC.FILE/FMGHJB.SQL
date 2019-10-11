  CREATE or REPLACE TABLE Greenhouse_Jobs_Master for SYSTEM NAME FMGHJOB

 ( id              DEC(10,0)      NOT NULL,
   job_class       CHAR(3)        NOT NULL WITH DEFAULT,
   job_subclass    CHAR(3)        NOT NULL WITH DEFAULT,
   job_code        CHAR(3)        NOT NULL WITH DEFAULT,
   job_description CHAR(80)       NOT NULL WITH DEFAULT,
    --
   created_ts TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP ,
   created_by CHAR(18) NOT NULL WITH DEFAULT USER ,
   updated_ts TIMESTAMP NOT NULL FOR EACH ROW ON UPDATE AS ROW change TIMESTAMP ,
   updated_by CHAR(18) NOT NULL WITH DEFAULT USER
 )
   RCDFMT RMGHJOB;

-- Add text to the Object so we know the table name
LABEL ON TABLE Greenhouse_Jobs_Master IS 'Greenhouse Jobs Master File';

-- Create a trigger to update the Last Update User ID
CREATE OR REPLACE TRIGGER Greenhouse_Jobs_Master_TR01
    BEFORE UPDATE ON Greenhouse_Jobs_Master
    REFERENCING NEW ROW AS NEWROW OLD ROW AS OLDROW
    FOR EACH ROW MODE DB2ROW
    SET NEWROW.updated_by = USER;
