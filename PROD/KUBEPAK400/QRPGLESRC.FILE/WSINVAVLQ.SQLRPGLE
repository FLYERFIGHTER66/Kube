      *? Program        : WSINVAVLQ
      *?
      *? Description    : This pgm is used to send ALL the availability
      *?                  quantity records to the Brokers
      *?
      *? Created By     : Vimala
      *?
      *? Date           : 17 Oct 2017
      //--------------------------------------------------------------------
      *? Special Notes  : Generates an outfile WSINV_AVL in TGMSDATA library
      *?                  with ALL available Inventory. Data from this file
      *?                  is used to build Inventory XML
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      *
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
         Ctl-Opt  DftActGrp(*NO) Option(*NoDebugIO) DatFmt(*usa);
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
        Dcl-S Monday      Date;              //Monday Date
        Dcl-S Day_Of_Week Zoned(1:0);        //Day of the Week MON=0-->SUN=6
        Dcl-S ThisMonday  Char(8)     Inz('20170130');
        Dcl-S WkLib       Char(10)    Inz;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Calc Specification :
      *?                :--------------------:
      *
      *?Main Line

      *?// Process to Create Physical file with Available Inventory
        Day_Of_Week = %Rem(%Diff(%Date():d'01/01/0001':*Days):7); // *Mon=0 ...
        Monday = %Date() - %Days(Day_Of_Week);

      *?// If it's Friday or Later, add one week
        If Day_Of_Week >= 4;
           Monday += %Days(7);
        Endif;
        ThisMonday = %Char(Monday:*ISO0);

      *?// Get default library from Parameter File
        Chain ('1000' :'DATA') FBROKDFTL0;
        If %Found;
           WkLib =  %Trim(DFVARVAL);
        Endif;

      *?// Delete data from file
        Exec SQL
           DELETE from TGMSDATA/WSINV_AVL;
           SQLSTATE = SQLSTATE;

      *?// Recreate Table
        Exec SQL
           CREATE or REPLACE TABLE TGMSDATA/WSINV_AVL (
             RECORDTYPE   CHAR (02 ) NOT NULL WITH DEFAULT,
             WKITEM       CHAR (22 ) NOT NULL WITH DEFAULT,
             DATEYYYYMMDD CHAR (08 ) NOT NULL WITH DEFAULT,
             COLUMN4      CHAR (01 ) NOT NULL WITH DEFAULT,
             WKQTY        CHAR (10 ) NOT NULL WITH DEFAULT,
             WKUOM        CHAR (03 ) NOT NULL WITH DEFAULT);
             SQLSTATE = SQLSTATE;

      *?// Create Record Type '02' for Plug Inventory
        Exec SQL
        INSERT INTO TGMSDATA/WSINV_AVL (
               select '02'
               , trim(ITEM_NUMBER)||trim(ITEM_SIZE)
               , year(READY_DATE)||
                 right('00'||month(READY_DATE),2)||
                 right('00'||day(READY_DATE),2)
               , ' '
               , QUANTITY_AVAILABLE
               , 'TRY'
               from Inv_Plugs_Ready_union_Spec_w_holdback
               Order by trim(ITEM_NUMBER)||trim(ITEM_SIZE), READY_DATE);
           SQLSTATE = SQLSTATE;

      *?// Endpgm
        *InLR = *On;
        Return;
