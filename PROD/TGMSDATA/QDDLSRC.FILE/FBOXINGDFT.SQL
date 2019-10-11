
CREATE or REPLACE TABLE Boxing_Defaults
For system name FBOXINGDFT
 ( default_key          for column BDKEY  DEC(02,0)
                        NOT NULL PRIMARY KEY
 , dft_box_frt_SM       for column BDBXFRSM DEC(5,2)
                        NOT NULL WITH DEFAULT
 , dft_box_frt_MD       for column BDBXFRMD DEC(5,2)
                        NOT NULL WITH DEFAULT
 , dft_box_frt_LG       for column BDBXFRLG DEC(5,2)
                        NOT NULL WITH DEFAULT
 , dft_box_frt_UK       for column BDBXFRUK DEC(5,2)
                        NOT NULL WITH DEFAULT
 , dft_box_frt_05       for column BDBXFR05 DEC(5,2)
                        NOT NULL WITH DEFAULT
 , dft_box_frt_06       for column BDBXFR06 DEC(5,2)
                        NOT NULL WITH DEFAULT
 , dft_boxonly_SM       for column BDBXNGSM DEC(5,2)
                        NOT NULL WITH DEFAULT
 , dft_boxonly_MD       for column BDBXNGMD DEC(5,2)
                        NOT NULL WITH DEFAULT
 , dft_boxonly_LG       for column BDBXNGLG DEC(5,2)
                        NOT NULL WITH DEFAULT
 , dft_boxonly_UK       for column BDBXNGUK DEC(5,2)
                        NOT NULL WITH DEFAULT
 , dft_boxonly_05       for column BDBXNG05 DEC(5,2)
                        NOT NULL WITH DEFAULT
 , dft_boxonly_06       for column BDBXNG06 DEC(5,2)
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
 ) RCDFMT RBOXINGDFT;





LABEL ON TABLE FBOXINGDFT
      IS 'Boxing Defaults File';





CREATE or REPLACE TRIGGER FBOXINGDFT_TR01
  BEFORE UPDATE ON FBOXINGDFT
  REFERENCING NEW ROW AS NEWROW OLD ROW AS OLDROW
  FOR EACH ROW  MODE DB2ROW
    SET NEWROW.updated_by = USER;
