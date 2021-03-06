--  Generate SQL 
--  Version:                   	V7R1M0 100423 
--  Generated on:              	10/24/16 12:27:34 
--  Relational Database:       	S105R9YM 
--  Standards Option:          	ISO 
CREATE TABLE TGMSDATA.FMINVT(
--  SQL150B   10   REUSEDLT(*NO) in table FMINVT in TGMSDATA ignored.
--  SQL1509   10   Format name RMINVT for FMINVT in TGMSDATA ignored.
    IMSTAT CHAR(1) NOT NULL DEFAULT '' , IMITEM CHAR(12) NOT NULL DEFAULT '' , IMSIZE CHAR(3) NOT
        NULL DEFAULT '' , IMWHSE CHAR(3) NOT NULL DEFAULT '' , IMCOMP NUMERIC(2, 0) NOT NULL
        DEFAULT 0 , IMBIN# CHAR(6) NOT NULL DEFAULT '' , IMDES1 CHAR(30) NOT NULL DEFAULT '' ,
        IMDES2 CHAR(30) NOT NULL DEFAULT '' , IMPUOM CHAR(2) NOT NULL DEFAULT '' , IMSUOM CHAR(2)
        NOT NULL DEFAULT '' , IM3UOM CHAR(2) NOT NULL DEFAULT '' , IMBPUM CHAR(2) NOT NULL
        DEFAULT '' , IMMULT DECIMAL(7, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMMULT ignored.
    IMMUL2 DECIMAL(7, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMMUL2 ignored.
    IMUWGT DECIMAL(11, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMUWGT ignored.
    IMUCST DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMUCST ignored.
    IMLCST DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMLCST ignored.
    IMSEL1 DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMSEL1 ignored.
    IMSEL2 DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMSEL2 ignored.
    IMSEL3 DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMSEL3 ignored.
    IMSEL4 DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMSEL4 ignored.
    IMSEL5 DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMSEL5 ignored.
    IMBCS1 DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMBCS1 ignored.
    IMBCS2 DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMBCS2 ignored.
    IMBCS3 DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMBCS3 ignored.
    IMBCS4 DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMBCS4 ignored.
    IMBCS5 DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMBCS5 ignored.
    IMQLB1 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQLB1 ignored.
    IMQLB2 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQLB2 ignored.
    IMQLB3 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQLB3 ignored.
    IMQLB4 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQLB4 ignored.
    IMQLB5 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQLB5 ignored.
    IMDIS1 NUMERIC(4, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMDIS1 ignored.
    IMDIS2 NUMERIC(4, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMDIS2 ignored.
    IMDIS3 NUMERIC(4, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMDIS3 ignored.
    IMDIS4 NUMERIC(4, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMDIS4 ignored.
    IMDIS5 NUMERIC(4, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMDIS5 ignored.
    IMTXBL CHAR(1) NOT NULL DEFAULT '' , IMTCD1 CHAR(1) NOT NULL DEFAULT '' , IMTCD2 CHAR(1) NOT
        NULL DEFAULT '' , IMTCD3 CHAR(1) NOT NULL DEFAULT '' , IMFET$ DECIMAL(7, 2) NOT NULL
        DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMFET$ ignored.
    IMVEND NUMERIC(6, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMVEND ignored.
    IMSDST DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMSDST ignored.
    IMPTYP CHAR(1) NOT NULL DEFAULT '' , IMBMFL CHAR(1) NOT NULL DEFAULT '' , IMQTSO DECIMAL(11,
        2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQTSO ignored.
    IMPPFG CHAR(1) NOT NULL DEFAULT '' , IMLOTC CHAR(1) NOT NULL DEFAULT '' , IMPCL1 CHAR(2) NOT
        NULL DEFAULT '' , IMPCL2 CHAR(2) NOT NULL DEFAULT '' , IMPCL3 CHAR(2) NOT NULL DEFAULT ''
        , IM#ORD DECIMAL(5, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM#ORD ignored.
    IMDTLO NUMERIC(6, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMDTLO ignored.
    IMQEOQ DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQEOQ ignored.
    IMQREO DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQREO ignored.
    IMLEAD DECIMAL(3, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMLEAD ignored.
    IMCOMM NUMERIC(4, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCOMM ignored.
    IMQTOH DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQTOH ignored.
    IMQ2OH DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQ2OH ignored.
    IMQ3OH DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQ3OH ignored.
    IMQTOO DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQTOO ignored.
    IMQTAL DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQTAL ignored.
    IMALC2 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMALC2 ignored.
    IMALC3 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMALC3 ignored.
    IMQTAV DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQTAV ignored.
    IMQTA2 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQTA2 ignored.
    IMQTA3 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQTA3 ignored.
    IMQTBO DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQTBO ignored.
    IMQMTD DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQMTD ignored.
    IMQM01 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQM01 ignored.
    IMQM02 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQM02 ignored.
    IMQM03 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQM03 ignored.
    IMQM04 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQM04 ignored.
    IMQM05 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQM05 ignored.
    IMQM06 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQM06 ignored.
    IMQM07 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQM07 ignored.
    IMQM08 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQM08 ignored.
    IMQM09 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQM09 ignored.
    IMQM10 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQM10 ignored.
    IMQM11 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQM11 ignored.
    IMQM12 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQM12 ignored.
    IMQM13 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQM13 ignored.
    IM$MTD DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM$MTD ignored.
    IM$M01 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM$M01 ignored.
    IM$M02 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM$M02 ignored.
    IM$M03 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM$M03 ignored.
    IM$M04 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM$M04 ignored.
    IM$M05 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM$M05 ignored.
    IM$M06 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM$M06 ignored.
    IM$M07 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM$M07 ignored.
    IM$M08 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM$M08 ignored.
    IM$M09 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM$M09 ignored.
    IM$M10 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM$M10 ignored.
    IM$M11 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM$M11 ignored.
    IM$M12 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM$M12 ignored.
    IM$M13 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM$M13 ignored.
    IMCMTD DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCMTD ignored.
    IMCM01 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCM01 ignored.
    IMCM02 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCM02 ignored.
    IMCM03 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCM03 ignored.
    IMCM04 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCM04 ignored.
    IMCM05 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCM05 ignored.
    IMCM06 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCM06 ignored.
    IMCM07 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCM07 ignored.
    IMCM08 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCM08 ignored.
    IMCM09 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCM09 ignored.
    IMCM10 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCM10 ignored.
    IMCM11 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCM11 ignored.
    IMCM12 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCM12 ignored.
    IMCM13 DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCM13 ignored.
    IMDTLS NUMERIC(6, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMDTLS ignored.
    IMMREC DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMMREC ignored.
    IMMADJ DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMMADJ ignored.
    IMISSU DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMISSU ignored.
    IMQPHY DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQPHY ignored.
    IMQPH2 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQPH2 ignored.
    IMQPH3 DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQPH3 ignored.
    IMBPOH DECIMAL(11, 1) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMBPOH ignored.
    IMCSOH DECIMAL(9, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCSOH ignored.
    IMCYCD CHAR(2) NOT NULL DEFAULT '' , IMLIST CHAR(4) NOT NULL DEFAULT '' , IMDTLA NUMERIC(6,
        0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMDTLA ignored.
    IMTIME NUMERIC(6, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTWRD in column IMTIME ignored.
    IMUSER CHAR(10) NOT NULL DEFAULT '' , IMCDFL CHAR(1) NOT NULL DEFAULT '' , IMBOOK CHAR(1) NOT
        NULL DEFAULT '' , IMVITM CHAR(30) NOT NULL DEFAULT '' , IMMERC NUMERIC(8, 0) NOT NULL
        DEFAULT 0 ,
--  SQL150D   10   EDTWRD in column IMMERC ignored.
    IMCOGS NUMERIC(8, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTWRD in column IMCOGS ignored.
    IMINVN NUMERIC(8, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTWRD in column IMINVN ignored.
    IMLOOK CHAR(15) NOT NULL DEFAULT '' , IMCWTF CHAR(1) NOT NULL DEFAULT '' , IMPRPL CHAR(1) NOT
        NULL DEFAULT '' , IMCUBE DECIMAL(5, 2) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMCUBE ignored.
    IMFCST DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMFCST ignored.
    IMLBS# DECIMAL(11, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMLBS# ignored.
    IMDSHF CHAR(1) NOT NULL DEFAULT '' , IMLHST CHAR(1) NOT NULL DEFAULT '' , IMQPH# DECIMAL(11,
        4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMQPH# ignored.
    IM3CS1 DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM3CS1 ignored.
    IM3CS2 DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM3CS2 ignored.
    IM3CS3 DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM3CS3 ignored.
    IM3CS4 DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM3CS4 ignored.
    IM3CS5 DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM3CS5 ignored.
    IMCNSF CHAR(1) NOT NULL DEFAULT '' , IMBD1 NUMERIC(4, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTWRD in column IMBD1 ignored.
    IMBD2 NUMERIC(4, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTWRD in column IMBD2 ignored.
    IMBD3 NUMERIC(4, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTWRD in column IMBD3 ignored.
    IMBD4 NUMERIC(4, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTWRD in column IMBD4 ignored.
    IMED1 NUMERIC(4, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTWRD in column IMED1 ignored.
    IMED2 NUMERIC(4, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTWRD in column IMED2 ignored.
    IMED3 NUMERIC(4, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTWRD in column IMED3 ignored.
    IMED4 NUMERIC(4, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTWRD in column IMED4 ignored.
    IMWG1 NUMERIC(2, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMWG1 ignored.
    IMWG2 NUMERIC(2, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMWG2 ignored.
    IMWG3 NUMERIC(2, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMWG3 ignored.
    IMWG4 NUMERIC(2, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMWG4 ignored.
    IMSOWC CHAR(1) NOT NULL DEFAULT '' , IMTRYC CHAR(1) NOT NULL DEFAULT '' , IMLOC CHAR(2) NOT
        NULL DEFAULT '' , IM#SED NUMERIC(2, 0) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IM#SED ignored.
    IMTPSW CHAR(1) NOT NULL DEFAULT '' , IMMSCX CHAR(2) NOT NULL DEFAULT '' , IMDES3 CHAR(30) NOT
        NULL DEFAULT '' , IMDES4 CHAR(30) NOT NULL DEFAULT '' , IMROYL DECIMAL(7, 4) NOT NULL
        DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMROYL ignored.
    IMFTAB CHAR(2) NOT NULL DEFAULT '' , IMWKAV NUMERIC(2, 0) NOT NULL DEFAULT 0 , IMFRSZ CHAR(3)
        NOT NULL DEFAULT '' , IMALTP CHAR(1) NOT NULL DEFAULT '' , IMORDD CHAR(1) NOT NULL
        DEFAULT '' , IMSOPR DECIMAL(9, 4) NOT NULL DEFAULT 0 ,
--  SQL150D   10   EDTCDE in column IMSOPR ignored.
    PRIMARY KEY(IMITEM , IMSIZE , IMWHSE));

GRANT ALTER , DELETE , INDEX , INSERT , REFERENCES , SELECT , UPDATE ON TGMSDATA.FMINVT TO EFDTST
    WITH GRANT OPTION;

GRANT DELETE , INSERT , SELECT , UPDATE ON TGMSDATA.FMINVT TO PUBLIC;