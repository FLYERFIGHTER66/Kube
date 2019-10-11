 CREATE or REPLACE TABLE Order_List_Detail_Line_Flag_File for SYSTEM NAME FMORLSFLAG

 ( flag_Order_List  FOR COLUMN FLLIST CHAR(6)    NOT NULL WITH DEFAULT,
   flag_item_number FOR COLUMN FLITEM CHAR(12)   NOT NULL WITH DEFAULT,
   flag_item_size   FOR COLUMN FLSIZE CHAR(3)    NOT NULL WITH DEFAULT,
   flag_hide_item   FOR COLUMN FLHIDE CHAR(1)    NOT NULL WITH DEFAULT,
    --
   created_ts TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP ,
   created_by CHAR(18) NOT NULL WITH DEFAULT USER ,
   updated_ts TIMESTAMP NOT NULL FOR EACH ROW ON UPDATE AS ROW change TIMESTAMP ,
   updated_by CHAR(18) NOT NULL WITH DEFAULT USER
 )
   RCDFMT RMORLSFLAG;

-- Add text to the Object so we know the table name
LABEL ON TABLE Order_List_Detail_Line_Flag_File IS 'Order_List_Detail_Line_Flag_File';

-- Add text to the Columns
LABEL ON COLUMN Order_List_Detail_Line_Flag_File
(   FLLIST      IS 'Order List' ,
    FLITEM      IS 'Item Number' ,
    FLSIZE      IS 'Item Size' ,
    FLHIDE      IS 'Hide Item'
) ;
LABEL ON COLUMN Order_List_Detail_Line_Flag_File
(   FLLIST TEXT IS 'Order List' ,
    FLITEM TEXT IS 'Item Number' ,
    FLSIZE TEXT IS 'Item Size' ,
    FLHIDE TEXT IS 'Hide Item'
) ;

-- Create a trigger to update the Last Update User ID
CREATE OR REPLACE TRIGGER Order_List_Detail_Line_Flag_File_TR01
    BEFORE UPDATE ON Order_List_Detail_Line_Flag_File
    REFERENCING NEW ROW AS NEWROW OLD ROW AS OLDROW
    FOR EACH ROW MODE DB2ROW
    SET NEWROW.updated_by = USER;

-- Create an Index to access data
 DROP INDEX FMORLSFLAG_BY_LIST_ITEM_SIZE;
 CREATE INDEX FMORLSFLAG_BY_LIST_ITEM_SIZE
    for SYSTEM NAME FMORLSFLG1
 ON Order_List_Detail_Line_Flag_File ( FLLIST, FLITEM, FLSIZE );
