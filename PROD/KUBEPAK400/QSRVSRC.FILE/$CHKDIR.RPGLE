      *? Program        : $CHKDIR
      *?
      *? Description    : This service pgm to Check Directions for the Customer
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 10 Dec 2018
      //--------------------------------------------------------------------
      *? Special Notes  : ** Send Customer Number and Seq# To Check record
      *?                     Exsits in Directions File
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
      /Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Customer Master Directions File
      *?Key : Customer Number
        Dcl-F FDirectl0 Disk(*Ext) Keyed Usage(*Input) UsrOpn;
      //--------------------------------------------------------------------
      *? Function Prototype(s)
      /Copy QFunctDefn,$CHKDIR
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Procedure                      :
        Dcl-Proc $CHKDIR  Export;
           Dcl-Pi *N IND;
              PCust#  Zoned(6:0) Const;
              PSeq#   Zoned(3:0) Const;
           End-Pi;

      *?   // Open File
           Open FDirectl0;
           SDTEXT = *Blanks;

      *?   // Check Record Exists
           Chain (PCust#:PSeq#) FDirectl0;

      *?   // Close File
           Close FDirectl0;

      *?   // Return Value
           If SDTEXT = *Blanks;
              Return  False;
           Else;
              Return  True;
           Endif;

        End-Proc;
