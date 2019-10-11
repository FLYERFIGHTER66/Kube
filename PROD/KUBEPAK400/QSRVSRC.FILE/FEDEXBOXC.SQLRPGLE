      *? Program        : FEDEXBOXC
      *?
      *? Description    : This service program to get FEDEX Box Count
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 09 May 2019
      //--------------------------------------------------------------------
      *? Special Notes  : ** Entry - Order & BoxType / Output -  Box Count
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
      *?Logic : To Get Box Count for the Order and Box Size
      *
        Dcl-Proc FEDEXBOXC Export;
           Dcl-Pi *N Zoned(4:0);
              POrder# Zoned(6:0) Const;
              PSize   Char(2)    Const;
           End-Pi;

      *?   // Work Variable Declaration
           Dcl-S PCount  Zoned(4:0);

      *?   // Get Box Count
           Exec SQL set :PCount = FedExBoxCount(:POrder#, :PSize);
           Return  PCount;

        End-Proc;
      *?------------------- End of Procedure -------------------------------------
