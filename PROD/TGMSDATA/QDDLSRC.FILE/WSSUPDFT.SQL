--drop table Supplier_Defaults;

create or replace TABLE Supplier_Defaults for system name WSSUPDFT

 ( Supplier_Name                for column SDNAME  CHAR(64) NOT NULL PRIMARY KEY
  ,Supplier_Vendor_Number       for column SDVEND  DEC(06,0) NOT NULL WITH DEFAULT
  ,Supplier_CutOff_Days         for column SDCDAY  DEC(03,0) NOT NULL WITH DEFAULT
 ) RCDFMT RSSUPDFT;

INSERT INTO Supplier_Defaults
--           Vendor Name        , Vend# , Days
    VALUES ('PSI'               , 001908, 6 ),
           ('DUMMEN ANTIGUA'    , 000023, 7 ),
           ('SYNGENTA'          , 002099, 11),
           ('INNOVAPLANT'       , 001941, 6 ),
           ('GEDIFLORA'         , 001629, 11);

