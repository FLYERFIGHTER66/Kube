      *? Program        : FEDEXBILL
      *?
      *? Description    : This service program to get FEDEX Bill Amount
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 09 May 2019
      //--------------------------------------------------------------------
      *? Special Notes  : ** Entry - Order / Output - Bill Amount
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
      *?                :---------------------:
      *?                : FEDEXBILL Procedure :
      *?                :---------------------:
      *
      *?Logic : To Get Bill Amount for the FEDEX Order Number
      *
        Dcl-Proc FEDEXBILL Export;
           Dcl-Pi *N Packed(10:2);
              POrder#  Zoned(6:0) Const;
           End-Pi;

      *?   // Get Net Charge Amount
           Dcl-S PBillAmt Packed(10:2);

      *?   // Get Net Charge Amount
           Exec SQL set :PBillAmt = FedExBillAmount(:POrder#);
           Return  PBillAmt;

        End-Proc;
      *?------------------- End of Procedure -------------------------------------
