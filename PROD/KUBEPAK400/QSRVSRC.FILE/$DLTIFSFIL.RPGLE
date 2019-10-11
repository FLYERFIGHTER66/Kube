      *? Program        : $DLTIFSFIL
      *?
      *? Description    : This service program to Delete IFS File/Directory
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 06 Jun 2019
      //--------------------------------------------------------------------
      *?Special Notes   : ** Entry - Ifs Path
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
      /Copy QFunctDefn,$_DLTIFS
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : $DLTIFSFIL Procedure :
      *?                :----------------------:
      *
      *?Logic : To Delete IFS file from the IFS Folder
      *
        Dcl-Proc $DLTIFSFIL Export;
           Dcl-Pi *N Char(75);
              Type  Char(3)   Const;
              Path  Char(300) Const Options(*Varsize);
           End-Pi;

      *?   Procedure Prototype Declaration : Pgm to Call Command
           Dcl-Pr QCMDEXC Extpgm;
              Cmd Char(500)    Const Options(*Varsize);
              Len Packed(15:5) Const;
           End-Pr;

      *?   Global Variable Declaration     :
           Dcl-S Cmd    Char(500) Inz;
           Dcl-S Status Char(75)  Inz;

      *?   // Move Command based on Type
           If Type = 'DIR';
              Cmd = 'RMVDIR DIR(''' + %Trim(Path) + ''') SUBTREE(*ALL)';
              Status = 'IFS Directory deleted';
           ElseIf Type = 'FIL';
              Cmd = 'RMVLNK OBJLNK(''' + %Trim(Path) + ''')';
              Status = 'IFS Link deleted';
           Endif;

      *?   // Delete IFS Path Link/Directory
           Monitor;
              QCmdExc(%Trim(Cmd): %Len(%Trim(Cmd)));
           On-Error;
              Status = 'Error in IFS Command';
           EndMon;

           Return Status;

        End-Proc;
      *?------------------- End of Procedure -------------------------------------
