  CREATE or REPLACE TABLE Wireless_Carriers_by_Phone for SYSTEM NAME FMWLSDFT

 ( wls_cust        DEC(6,0)     NOT NULL WITH DEFAULT,
   wls_phone       CHAR(10)       NOT NULL WITH DEFAULT,
   wls_name        CHAR(30)       NOT NULL WITH DEFAULT,
    --
   created_ts TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP ,
   created_by CHAR(18) NOT NULL WITH DEFAULT USER ,
   updated_ts TIMESTAMP NOT NULL FOR EACH ROW ON UPDATE AS ROW change TIMESTAMP ,
   updated_by CHAR(18) NOT NULL WITH DEFAULT USER
 )
   RCDFMT RMWLSDFT;

-- Add text to the Object so we know the table name
LABEL ON TABLE Wireless_Carriers_by_Phone IS 'Wireless Carriers by Phone';

-- Create a trigger to update the Last Update User ID
CREATE OR REPLACE TRIGGER Wireless_Carriers_by_Phone_TR01
    BEFORE UPDATE ON Wireless_Carriers_by_Phone
    REFERENCING NEW ROW AS NEWROW OLD ROW AS OLDROW
    FOR EACH ROW MODE DB2ROW
    SET NEWROW.updated_by = USER;
