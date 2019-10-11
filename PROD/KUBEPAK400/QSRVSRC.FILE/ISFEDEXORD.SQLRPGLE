      *? Program        : ISFEDEXORD
      *?
      *? Description    : This service program to get FEDEX information
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 09 May 2019
      //--------------------------------------------------------------------
      *? Special Notes  : ** Entry - Order / Output - Status 1/0
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
        Ctl-Opt DatFmt(*USA) Nomain;
      /Copy QFunctDefn,@CopyRight
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Prototype Definition :
      *?                :----------------------:
      *
      *? Function Prototype(s)
      /Copy QFunctDefn,$_FEDEX
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : ISFEDEXORD Procedure :
      *?                :----------------------:
      *
      *?Logic : To check Order is FEDEX Order Or Not
      *
        Dcl-Proc ISFEDEXORD Export;
           Dcl-Pi *N Char(1);
              POrder# Zoned(6:0) Const;
           End-Pi;

      *?   // Work Variable Declaration
           Dcl-S PStatus Char(1) Inz('0');

      *?   // Check Record Existance
           Exec SQL set :PStatus = isFedExOrder(:POrder#);
           Return PStatus;

        End-Proc;
      *?------------------- End of Procedure -------------------------------------
