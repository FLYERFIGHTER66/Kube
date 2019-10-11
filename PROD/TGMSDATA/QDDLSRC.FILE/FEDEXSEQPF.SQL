
CREATE or REPLACE TABLE FedEx_Next_Sequence_Number
For system name FEDEXSEQPF
 ( FedEx_Ship_Date7     for column FXDATE DEC(07,0)
                        NOT NULL PRIMARY KEY
 , FedEx_Next_Seq#      for column FXNEXT DEC(3,0)
                        NOT NULL WITH DEFAULT
 , created_ts           for column BDCRTIME Timestamp
                        NOT NULL WITH DEFAULT current timestamp
 , created_by           for column BDCRUSER Char(18)
                        Not null with default user
 , updated_ts           for column BDUDTIME Timestamp
                        NOT NULL
                        for each row on update
                        as row change timestamp
 , updated_by           for column BDUDUSER Char(18)
                        NOT NULL WITH DEFAULT user
 ) RCDFMT FEDEXSEQR;





LABEL ON TABLE FEDEXSEQPF
      IS 'FEDEX SEQUENCE NUMBER FILES';





CREATE or REPLACE TRIGGER FEDEXSEQPF_TR01
  BEFORE UPDATE ON FEDEXSEQPF
  REFERENCING NEW ROW AS NEWROW OLD ROW AS OLDROW
  FOR EACH ROW  MODE DB2ROW
    SET NEWROW.updated_by = USER;
