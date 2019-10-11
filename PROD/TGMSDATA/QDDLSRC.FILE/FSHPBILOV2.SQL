CREATE or REPLACE TABLE Shipping_Bill_To_Third_Party
For system name FSHPBILOVR
 ( ship_cust            for column SBCUST DEC(06,0)
                        NOT NULL
 , ship_via             for column SBSVIA CHAR(02)
                        NOT NULL WITH DEFAULT
 , shipping_company     for column SBSHPR CHAR(40)
                        NOT NULL WITH DEFAULT
 , account_number       for column SBACCT CHAR(25)
                        NOT NULL WITH DEFAULT
 , created_ts           for column SBCRTS Timestamp
                        NOT NULL WITH DEFAULT current timestamp
 , created_by           for column SBCRUS Char(18)
                        Not null with default user
 , updated_ts           for column SBLUTS Timestamp
                        NOT NULL
                        for each row on update
                        as row change timestamp
 , updated_by           for column SBLUUS Char(18)
                        NOT NULL WITH DEFAULT user
 ) RCDFMT RSHPBILL;

LABEL ON TABLE FSHPBILOVR
      IS 'SHIPPING_BILL_TO_THIRD_PARTY';

CREATE or REPLACE TRIGGER FSHPBILOVR_TR01
  BEFORE UPDATE ON FSHPBILOVR
  REFERENCING NEW ROW AS NEWROW OLD ROW AS OLDROW
  FOR EACH ROW  MODE DB2ROW
    SET NEWROW.ship_updated_by = USER;
