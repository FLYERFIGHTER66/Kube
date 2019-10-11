
CREATE or REPLACE TABLE READY_BAY_PICK_LOG
For system name FRBPICKLOG
 ( RB_ORDER_NUMBER      for column PLORD# DEC(06,0)
                        NOT NULL
 , RB_IN_OR_OUT         for column PLINOUT CHAR(1)
                        NOT NULL
 , created_ts           for column PLCRTIME Timestamp
                        NOT NULL WITH DEFAULT current timestamp
 , created_by           for column PLCRUSER Char(18)
                        Not null with default user
 , updated_ts           for column PLUDTIME Timestamp
                        NOT NULL
                        for each row on update
                        as row change timestamp
 , updated_by           for column PLUDUSER Char(18)
                        NOT NULL WITH DEFAULT user
 ) RCDFMT RBPICKLOG;





LABEL ON TABLE READY_BAY_PICK_LOG
           IS 'READY_BAY_PICK_LOG' ;





CREATE or REPLACE TRIGGER READY_BAY_PICK_LOG_TR01
  BEFORE UPDATE ON READY_BAY_PICK_LOG
  REFERENCING NEW ROW AS NEWROW OLD ROW AS OLDROW
  FOR EACH ROW  MODE DB2ROW
    SET NEWROW.updated_by = USER;
