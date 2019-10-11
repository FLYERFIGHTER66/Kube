      *? Program        : WSINVCHGQ
      *?
      *? Description    : This pgm is used to send all the CHANGED Inventory
      *?                  to the Brokers
      *?                  To be scheduled as and when required
      *?
      *? Created By     : Vimala
      *?
      *? Date           : 05 May 2018
      //--------------------------------------------------------------------
      *? Special Notes  : Generates an outfile WSINV_CHG in TGMSDATA
      *?                  library to send CHANGED Availability. Data from
      *?                  this file is used to build Inventory XML
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ----------------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      *
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
         Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) DatFmt(*usa);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: WS - Broker Default Parameter File
      *?Key : Broker Number : Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Global Variable Declaration :
        Dcl-S Monday        Date;              //Monday Date
        Dcl-S Day_Of_Week   Zoned(1:0);        //Day of the Week MON=0-->SUN=6
        Dcl-S Command       Varchar(1000);
        Dcl-S ThisMonday    Char(8);
        Dcl-S WeHaveChanges Ind;
        Dcl-S WeHaveZeros   Ind;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Calc Specification :
      *?                :--------------------:
      *
      *?Main Line

      *?// Process to Create Physical file with Changed Inventory
        Day_Of_Week = %Rem(%Diff(%Date():d'01/01/0001':*Days):7); // *Mon=0 ...
        Monday = %Date() - %Days(Day_Of_Week);

      *?// If it's Friday or Later, add one week
        If Day_Of_Week >= 4;
           Monday += %Days(7);
        Endif;
        ThisMonday = %Char(Monday:*ISO0);

      *?// Recreate Table
        Exec SQL
           CREATE OR REPLACE TABLE TESTDATA/WSINV_CHG (
             RECORDTYPE   CHAR (02 ) NOT NULL WITH DEFAULT,
             WKITEM       CHAR (22 ) NOT NULL WITH DEFAULT,
             DATEYYYYMMDD CHAR (08 ) NOT NULL WITH DEFAULT,
             COLUMN4      CHAR (01 ) NOT NULL WITH DEFAULT,
             WKQTY        CHAR (10 ) NOT NULL WITH DEFAULT,
             WKUOM        CHAR (03 ) NOT NULL WITH DEFAULT);
           SQLSTATE = SQLSTATE;

      *?// Clear Change file
        Exec SQL
           Delete From TESTDATA/WSINV_CHG;
           SQLSTATE = SQLSTATE;

      *?// Find Changed records in Inventory compared to Reference WSINV_AVL
      *?// Create Record Type '02' for Plug Inventory
        Exec SQL
           INSERT INTO
             TESTDATA/WSINV_AVL (
               select '02'  as RECORDTYPE
               , trim(ITEM_NUMBER)||trim(ITEM_SIZE) as WKITEM
               , year(READY_DATE)||
                 right('00'||month(READY_DATE),2)||
                 right('00'||day(READY_DATE),2)  as DATEYYYYMMDD
               , ' ' as COLUMN4
               , QUANTITY_AVAILABLE as WKQTY
               , 'TRY' as WKUOM
               from Inv_Plugs_Ready_union_Spec_w_holdback
             WHERE
               char(READY_DATE)||'-'||
               trim(ITEM_NUMBER)||
               trim(ITEM_SIZE)||'-'||
               QUANTITY_AVAILABLE not in
            (  SELECT  substr(DATEYYYYMMDD,5,2)||'/'||
                       substr(DATEYYYYMMDD,7,2)||'/'||
                       substr(DATEYYYYMMDD,3,2)
                   ||'-'||trim(WKITEM)||'-'||WKQTY
               FROM WSINV_AVL WHERE RECORDTYPE = '02'     )
               Order by trim(ITEM_NUMBER)||trim(ITEM_SIZE), READY_DATE);
         If SQLSTATE = '00000';
           WeHaveChanges = *On;
         EndIf;

      *?// Create Record Type '02' for Plug Inventory Zero Records
        Exec SQL
           INSERT INTO
             TESTDATA/WSINV_CHG (
               select RECORDTYPE,WKITEM, DATEYYYYMMDD, COLUMN4, 0, WKUOM
               from   WSINV_AVL
               where  RECORDTYPE = '02'
                 and (substr(DATEYYYYMMDD,5,2)||'/'||
                      substr(DATEYYYYMMDD,7,2)||'/'||
                      substr(DATEYYYYMMDD,3,2)
                      ||'-'||trim(WKITEM)) not in

                  ( Select char(READY_DATE)||'-'||
                           trim(ITEM_NUMBER)||
                           trim(ITEM_SIZE)
                    from Inv_Plugs_Ready_union_Spec_w_holdback ) );
         If SQLSTATE = '00000';
           WeHaveZeros = *On;
         EndIf;

      *?// Only Continue if we have data
      *?// Update the Reference Inventory
        If WeHaveChanges or WeHaveZeros;
           Exec SQL
             UPDATE TESTDATA/WSINV_AVL a
             SET    a.WKQTY =
                  ( Select b.WKQTY
                    from   TESTDATA/WSINV_CHG b
                    Where  b.RECORDTYPE   = '02'
                      and  b.WKITEM       = a.WKITEM
                      and  b.DATEYYYYMMDD = a.DATEYYYYMMDD )
             WHERE  a.RECORDTYPE = '02'
               and  EXISTS(Select *
                           from   TESTDATA/WSINV_CHG c
                           Where  c.RECORDTYPE   = '02'
                             and  c.WKITEM       = a.WKITEM
                             and  c.DATEYYYYMMDD = a.DATEYYYYMMDD );
        Endif;

      *?// Endpgm
        *InLR = *On;
        Return;
