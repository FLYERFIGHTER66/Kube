--  Generate SQL 
--  Version:                   	V7R1M0 100423 
--  Generated on:              	10/24/16 12:30:55 
--  Relational Database:       	S105R9YM 
--  Standards Option:          	ISO 
CREATE TABLE TGMSDATA.FDLOTRD(
--  SQL150B   10   REUSEDLT(*NO) in table FDLOTRD in TGMSDATA ignored.
--  SQL1509   10   Format name RDLOTRD for FDLOTRD in TGMSDATA ignored.
    LRSTAT CHAR(1) NOT NULL DEFAULT '' , LRITEM CHAR(12) NOT NULL DEFAULT '' , LRSIZE CHAR(3) NOT
        NULL DEFAULT '' , LRWHSE CHAR(3) NOT NULL DEFAULT '' , LRSOWD NUMERIC(7, 0) NOT NULL
        DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column LRSOWD ignored.
    LRGLOC CHAR(3) NOT NULL DEFAULT '' , LRPHYT CHAR(1) NOT NULL DEFAULT '' , LRCRDY NUMERIC(7,
        0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column LRCRDY ignored.
    LRCPHY CHAR(1) NOT NULL DEFAULT '' , LRCLOC CHAR(3) NOT NULL DEFAULT '' , LRCODE CHAR(1) NOT
        NULL DEFAULT '' , LRCUST NUMERIC(6, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column LRCUST ignored.
    LRAREA CHAR(6) NOT NULL DEFAULT '' , LRCOMP NUMERIC(2, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column LRCOMP ignored.
    LRQTOH DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column LRQTOH ignored.
    LRDTLA NUMERIC(6, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column LRDTLA ignored.
    LRTIME NUMERIC(6, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTWRD in column LRTIME ignored.
    LRUSER CHAR(10) NOT NULL DEFAULT '' , LRALPH CHAR(15) NOT NULL DEFAULT '' , LRPRCL CHAR(2)
        NOT NULL DEFAULT '' , LRQTAL DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column LRQTAL ignored.
    LRDESC CHAR(30) NOT NULL DEFAULT '' , LRQTCM DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column LRQTCM ignored.
    LRQTSL DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column LRQTSL ignored.
    LRQADJ DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column LRQADJ ignored.
    LRQTAV DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column LRQTAV ignored.
    PRIMARY KEY(LRITEM , LRSIZE , LRSOWD , LRCRDY , LRGLOC , LRCLOC , LRCODE , LRCUST));

GRANT ALTER , DELETE , INDEX , INSERT , REFERENCES , SELECT , UPDATE ON TGMSDATA.FDLOTRD TO EFD
    WITH GRANT OPTION;

GRANT DELETE , INSERT , SELECT , UPDATE ON TGMSDATA.FDLOTRD TO PUBLIC;

GRANT ALTER , DELETE , INDEX , INSERT , REFERENCES , SELECT , UPDATE ON TGMSDATA.FDLOTRD TO QDFTOWN
    WITH GRANT OPTION;