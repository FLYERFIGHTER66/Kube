      *? Program        : WSSTDINV01
      *?
      *? Description    : This pgm is used to load Available Inventory records
      *?                  for all Brokers based on Ready_Bay date
      *?
      *? Created By     : Vimala
      *?
      *? Date           : 13 Nov 2018
      //--------------------------------------------------------------------
      *? Special Notes  : Generates xml and calls programs to send Inventory
      *?                  xml to each Broker
      *
      *? Called Program : WSGRFINV01 - Griffin
      *?                : WSGLKINV01 - Gloeckner
      *?                : WSEHRINV01 - Eason
      *?                : WSMCHINV01 - Michell
      *?                : WSMHNINV01 - McHutchison
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
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration: *Entry Parameters
        Dcl-Pi WSSTDINV01 ExtPgm;
        End-Pi;
      *
      *?Procedure Prototype Declaration: WSSTDINVA1
        Dcl-Pr WSSTDINVA1 Extpgm End-Pr;
      *
      *?Procedure Prototype Declaration: WSGRFINV01 - for direct call Griffin
        Dcl-Pr WSGRFINV01 Extpgm;
          WkBroker Char(6) const;
          WkStDTc  char(8) const;
          WkEnddtc char(8) const;
        End-Pr;

      *?Procedure Prototype Declaration: WSMCHINV01 - for direct call Michell
        Dcl-Pr WSMCHINV01 Extpgm;
          WkBroker Char(6) const;
          WkStDTc  char(8) const;
          WkEnddtc char(8) const;
        End-Pr;

      *?Procedure Prototype Declaration: WSMHNINV01 - for direct call McHutchison
        Dcl-Pr WSMHNINV01 Extpgm;
          WkBroker Char(6) const;
          WkStDTc  char(8) const;
          WkEnddtc char(8) const;
        End-Pr;

      *?Procedure Prototype Declaration: WSGLKINV02 - for direct call Gloeckner
        Dcl-Pr WSGLKINV02 Extpgm;
          WkBroker Char(6) const;
        End-Pr;
      *
      *?Procedure Prototype Declaration: WSEHRINV01 - for direct call Eason
        Dcl-Pr WSEHRINV01 Extpgm;
          WkBroker Char(6) const;
          WkStDTc  char(8) const;
          WkEnddtc char(8) const;
        End-Pr;
      *
      *?Work Variable Declaration :
        Dcl-S BegDate    Date;
        Dcl-S EndDate    Date;
        Dcl-S LastDate   Date;


      //--------------------------------------------------------------------


        Refresh_Data();  // Refresh the data here

        // Send all one-shot transmissions
        WSGLKINV02('234');  // Gloeckner sends all at once

        // Send all every five weeks transmissions
        Exec SQL Set :BegDate = Ready_Bay_Week;
        LastDate = BegDate + %Days(365);
        Dow BegDate < LastDate;
          EndDate = BegDate + %Days(28);
          SbmPgm(%Char(BegDate:*ISO0):%Char(EndDate:*ISO0));
          BegDate = BegDate + %Days(35);
        ENDDO;

        *InLR = *On;
        Return;

      //--------------------------------------------------------------------
      // Submit the programs to generate xml and send to respective Brokers
      //--------------------------------------------------------------------
         DCL-PROC Refresh_Data;

           Exec SQL DELETE from WSSTDINVA;
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
         END-PROC;
      //--------------------------------------------------------------------
      // Submit the programs to generate xml and send to respective Brokers
      //--------------------------------------------------------------------
         DCL-PROC SbmPgm;
         dcl-pi *n;
            BegDateC char(8) const;
            EndDateC char(8) const;
         END-PI;

           WSGRFINV01('2386':BegDateC:EndDateC);     // Griffin
           WSMHNINV01('1947':BegDateC:EndDateC);     // McHutison
           //WSEHRINV01('3953':BegDateC:EndDateC);   // EHR
           WSMCHINV01('3975':BegDateC:EndDateC);     // Michells

         END-PROC;
