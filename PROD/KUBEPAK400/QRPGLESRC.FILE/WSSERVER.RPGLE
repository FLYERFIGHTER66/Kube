      *? Program        : WSSERVER
      *?
      *? Description    : This program to Create/Start/Stop/Delete
      *?                  WebservicesServer through QSHELL commands
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 10 Jan 2018
      //--------------------------------------------------------------------
      *? Special Notes  : Based on entry parameter will Create/Start/Stop/
      *?                  Delete Webserver Services
      *?
      *? Entry Parm     : Create : Server Name , 'CREATE' , Port(Should be Opened)
      *?                  Start  : Server Name , 'START'
      *?                  Stop   : Server Name , 'STOP'
      *?                  Delete : Server Name , 'DELETE' ** Future Use
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
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO);
      *
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry (From WSM020 Menu)
        Dcl-Pi WSSERVER;
           PServer   Char(25);
           PTask     Char(10);
           PPort     Char(5);
        End-Pi;
      *
      *?Procedure Interface Declaration : Call CL Command in RPG
        Dcl-Pr QCMDEXC Extpgm;
           Cmd Char(500)    Const Options(*Varsize);
           Len Packed(15:5) Const;
        End-Pr;
      *
      *?Program Satus Data Strucure : Future Use
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?Global Variable Declaration :
        Dcl-S Command  Char(500)    Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkCmd    Char(100)    Inz;
      *
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Initialise Program
           Exsr InzPgm;

      *?   // Call subroutine based on task
           Select;
              When PTask = 'CREATE';               // Create Server
                 Exsr CreateServer;
              When PTask = 'START';                // Start Server
                 Exsr StartServer;
              When PTask = 'STOP';                 // Stop Server
                 Exsr StopServer;
              When PTask = 'DELETE';               // Delete Server
                 Exsr DeleteServer;
           Endsl;

      *?   // End Program
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Initialise Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Initialise Variables
      *?
        Begsr InzPgm;

      *?   // Clear Variables
           Command = *Blanks;
           WkCmd   = *Blanks;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : CreateServer Subroutine :
      *?                :-------------------------:
      *
        Begsr CreateServer;

      *?   // Create Server
           Monitor;
              WkCmd   = '/QIBM/ProdData/OS/WebServices/bin/' +
                        'createWebServicesServer.sh -server ' ;

              Command = 'STRQSH CMD(''' + %Trim(WkCmd) + ' ' + %Trim(PServer)+
                        ' -startingPort ' + %Trim(PPort) + ' -userid WSUSER'+
                        ' -locationDirectory /www -version *CURRENT'        +
                        ' -printErrorDetails' + ''')';

      *?      // Call CL Command
              QCmdExc(%Trim(Command): %Len(%Trim(Command)));
           On-Error;
           EndMon;

        EndSr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : StartServer Subroutine :
      *?                :------------------------:
      *
        Begsr StartServer;

      *?   // Start the Server
           Monitor;
              WkCmd   = '/QIBM/ProdData/OS/WebServices/bin/' +
                        'startWebServicesServer.sh -server ';

              Command = 'STRQSH CMD(''' + %Trim(WkCmd) + ' ' +
                                      %Trim(PServer) + ''')';

      *?      // Call CL Command
              QCmdExc(%Trim(Command): %Len(%Trim(Command)));
           On-Error;
           EndMon;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : StopServer Subroutine :
      *?                :-----------------------:
      *
        Begsr StopServer;

      *?   // Stop the Server
           Monitor;
              WkCmd   = '/QIBM/ProdData/OS/WebServices/bin/' +
                        'stopWebServicesServer.sh -server ';

              Command = 'STRQSH CMD(''' + %Trim(WkCmd) + ' ' +
                                      %Trim(PServer) + ''')';

      *?      // Call CL Command
              QCmdExc(%Trim(Command): %Len(%Trim(Command)));
           On-Error;
           EndMon;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : DeleteServer Subroutine :
      *?                :-------------------------:
      *
        Begsr DeleteServer;

      *?   // Delete the Server
           Monitor;
              WkCmd   = '/QIBM/ProdData/OS/WebServices/bin/' +
                        'deleteWebServicesServer.sh -server ';

              Command = 'STRQSH CMD(''' + %Trim(WkCmd) + ' ' +
                                      %Trim(PServer) + ''')';

      *?      // Call CL Command
              QCmdExc(%Trim(Command): %Len(%Trim(Command)));
           On-Error;
           EndMon;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

      *?   // End the Program
           *InLr = *On;
           Return;

        EndSr;
      *?---------------- End Of Subroutines --------------------------------
