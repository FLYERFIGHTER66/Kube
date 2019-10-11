      *? Program        : FEDEXBOXCH
      *?
      *? Description    : This service program to get FEDEX Boxing Charging
      *?                  Charges
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 20 May 2019
      //-----------------------------------------------------------------------
      *? Special Notes  : ** Entry - Order & BoxSize / Output -  Boxing Charges
      //-----------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ---------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ---------------------------------------
      *
      //-----------------------------------------------------------------------
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
      *?                :---------------------:
      *?                : FEDEXBOXC Procedure :
      *?                :---------------------:
      *
      *?Logic : To Get Boxing Charges for Order and Box Size
      *
        Dcl-Proc FEDEXBOXCH Export;
           Dcl-Pi *N Char(15);
              POrder# Zoned(6:0) Const;
              PSize   Char(2)    Const;
           End-Pi;

      *?   // Work Variable Declaration
           Dcl-S PBoxing Char(15);

      *?   // Get Boxing Charge for Order and Box Size
           Exec SQL set :PBoxing = FedExBoxingCharges(:POrder# , :PSize);
           Return PBoxing;

        End-Proc;
      *?------------------- End of Procedure -------------------------------------
