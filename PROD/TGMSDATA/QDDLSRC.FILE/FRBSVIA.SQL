    -- Drop triggers
DROP TRIGGER RB_ShipVia_Equivalent_TR01;


    -- Create the Token Encryption File
CREATE OR REPLACE TABLE RB_ShipVia_Equivalent
FOR SYSTEM NAME FRBSVIA (
    xref_id FOR COLUMN RBKEY DEC(6, 0) NOT NULL GENERATED
                BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) ,
    originalShipViaCode FOR COLUMN RBORSVIA CHAR(2) NOT NULL WITH DEFAULT ,
    readyBayShipViaCode FOR COLUMN RBRBSVIA CHAR(2) NOT NULL WITH DEFAULT ,
    --
    created_ts FOR COLUMN RBCRTIME
      TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP ,
    created_by FOR COLUMN RBCRUSER
      CHAR(18) NOT NULL WITH DEFAULT USER ,
    updated_ts FOR COLUMN RBUDTIME
      TIMESTAMP NOT NULL FOR
      EACH ROW ON UPDATE AS ROW change TIMESTAMP ,
    updated_by FOR COLUMN RBUDUSER
      CHAR(18) NOT NULL WITH DEFAULT USER

    ) RCDFMT RRBSVIA;

-- Add text to the Object so we know the table name
LABEL ON TABLE RB_ShipVia_Equivalent  IS 'Ready Bay SVIA equivalents';

-- Create a trigger to update the Last Update User ID
CREATE OR REPLACE TRIGGER RB_ShipVia_Equivalent_TR01
    BEFORE UPDATE ON RB_ShipVia_Equivalent
    REFERENCING NEW ROW AS NEWROW OLD ROW AS OLDROW
    FOR EACH ROW MODE DB2ROW
    SET NEWROW.updated_by = USER;
