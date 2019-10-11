      *? Program        : FEDEXFRGHT
      *?
      *? Description    : This service program to get FEDEX Freight for
      *?                  Order and Box Size
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 20 May 2019
      //--------------------------------------------------------------------
      *? Special Notes  : ** Entry - Order & BoxSize / Output -  Freight
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
      *?                : FEDEXBOXC Procedure :
      *?                :---------------------:
      *
      *?Logic : To Get Freight for Order and Box Size
      *
        Dcl-Proc FEDEXFRGHT Export;
           Dcl-Pi *N Packed(10:2);
              POrder# Zoned(6:0) Const;
              PSize   Char(2)    Const;
           End-Pi;

      *?   // Work Variable Declaration
           Dcl-S PFreight Packed(10:2);

      *?   // Get Freight
           Exec SQL set :PFreight = FedExBoxSizeFreight(:POrder# , :PSize);
           Return PFreight;

        End-Proc;
      *?------------------- End of Procedure -------------------------------------
