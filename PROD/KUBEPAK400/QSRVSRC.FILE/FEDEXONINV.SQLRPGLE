      *? Program        : FEDEXONINV
      *?
      *? Description    : This service program to get FEDEX Invoice Number
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 09 May 2019
      //--------------------------------------------------------------------
      *? Special Notes  : *Entry - Order / Output - Invoice
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
      *?                : FEDEXONINV Procedure :
      *?                :----------------------:
      *
      *?Logic : To Get Invoice for the Order
      *
        Dcl-Proc FEDEXONINV Export;
           Dcl-Pi *N Zoned(6:0);
              POrder#  Zoned(6:0) Const;
           End-Pi;

      *?   // Work Variable Declaration
           Dcl-S  PInvoice  Zoned(6:0);

      *?   // Get Invoice for the Order
           Exec SQL set :PInvoice = FedExBillOnInvoice(:POrder#);
           Return PInvoice;

        End-Proc;
      *?------------------- End of Procedure -------------------------------------
