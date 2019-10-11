  CREATE or REPLACE TABLE Wireless_Carriers_Master for SYSTEM NAME FMWLSCAR

 ( wls_name        CHAR(30)       NOT NULL WITH DEFAULT,
   wls_country     CHAR(15)       NOT NULL WITH DEFAULT,
   wls_gateway     CHAR(80)       NOT NULL WITH DEFAULT,
    --
   created_ts TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP ,
   created_by CHAR(18) NOT NULL WITH DEFAULT USER ,
   updated_ts TIMESTAMP NOT NULL FOR EACH ROW ON UPDATE AS ROW change TIMESTAMP ,
   updated_by CHAR(18) NOT NULL WITH DEFAULT USER
 )
   RCDFMT RMWLSCAR;

-- Add text to the Object so we know the table name
LABEL ON TABLE Wireless_Carriers_Master IS 'Wireless Carriers Master File';

-- Create a trigger to update the Last Update User ID
CREATE OR REPLACE TRIGGER Wireless_Carriers_Master_TR01
    BEFORE UPDATE ON Wireless_Carriers_Master
    REFERENCING NEW ROW AS NEWROW OLD ROW AS OLDROW
    FOR EACH ROW MODE DB2ROW
    SET NEWROW.updated_by = USER;
