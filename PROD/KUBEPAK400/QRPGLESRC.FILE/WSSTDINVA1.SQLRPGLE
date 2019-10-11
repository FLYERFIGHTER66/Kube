      *? Program        : WSSTDINVA1
      *?
      *? Description    : This pgm is used to load Available Inventory records
      *?                  for all Brokers based on View_Type
      *?                  View_Type will be 'Web' for all Brokers except BallSeed
      *?
      *? Created By     : Vimala
      *?
      *? Date           : 7 Nov 2018
      //--------------------------------------------------------------------
      *? Special Notes  : Generates an outfile WSSTDINVA in TGMSDATA library
      *?                  with ALL available Inventory. Data from this file
      *?                  is used to build Inventory XML for all Brokers
      *
      *? Called Program : QCMDEXC - Pgm To Call CL command in Rpg
      *?                : Submits programs for each Broker
      *
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
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration: *Entry Parameters
        Dcl-Pi WSSTDINVA1 ExtPgm;
        End-Pi;
      *
      *?Global Variable Declaration :
      *
      *?Work Variable Declaration :
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Calc Specification :
      *?                :--------------------:
      *
      *?Main Line
      *
      *?// Get data from KubePak Standard Inventory File and load to workfile
        Exsr LoadFile;

      *?// Endpgm
        *InLR = *On;
        Return;
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Load File Subroutine :
      *?                :----------------------:
      *?// Process to Create Physical file with Available Inventory
        Begsr LoadFile;

      *?// Delete data from file
           Exec SQL
              DELETE from WSSTDINVA;
              SQLSTATE = SQLSTATE;

      *?// Recreate Table WSSTDINVA SQL is moved to QDDSSRC in TGMSDATA // Info

      *?// Create Records in workfile to send data to Brokers
           Exec SQL
              INSERT INTO WSSTDINVA (
                 Select
                    trim(ITEM_NUMBER)||trim(ITEM_SIZE)
                  , year(READY_DATE)||
                    right('00'||month(READY_DATE),2)||
                    right('00'||day(READY_DATE),2)
                  , QUANTITY_AVAILABLE
                  , 'TRY'
                  from FSTDPLGINV
                 Where View_Control_Type = 'WEB'
                 and QUANTITY_AVAILABLE > 0
                 Order by trim(ITEM_NUMBER)||trim(ITEM_SIZE), READY_DATE);
              SQLSTATE = SQLSTATE;

        EndSr;
      //--------------------------------------------------------------------
