      *? Program       : WSSERVICE
      *?
      *? Description   : This program to Install/Start/Stop/Uninstall
      *?                 Webservices through QSHELL commands
      *? Created By    : S.Uthayadurga
      *?
      *? Date          : 10 Jan 2018
      //--------------------------------------------------------------------
      *? Special Notes : Based on entry parameter will Install/Start/S top/
      *?                  Uninstall Services in Server
      *?
      *? Entry Parm    : Install  :Server Name , Service Name , 'DEPLOY'
      *?                 Start    :Server Name , Service Name , 'START'
      *?                 Stop     :Server Name , Service Name , 'STOP'
      *?                 Uninstall:Server Name , Service Name , 'DELETE'  **Future Use
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
        Dcl-Pi WSSERVICE;
           PServer   Char(25);
           PService  Char(25);
           PTask     Char(10);
        End-Pi;
      *
      *?Procedure Interface Declaration : Call CL Command in RPG
        Dcl-Pr QCMDEXC Extpgm;
           Cmd Char(1000)   Const Options(*Varsize);
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
        Dcl-S Command  Char(1000)   Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkCmd    Char(1000)  Inz;
        Dcl-S WkObj    Char(100)   Inz;
        Dcl-S WkLib    Char(100)   Inz;
        Dcl-S WkPcml   Char(100)   Inz;
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
              When PTask = 'DEPLOY';               // Install Service
                 Exsr DeployService;
              When PTask = 'START';                // Start Service
                 Exsr StartService;
              When PTask = 'STOP';                 // Stop Service
                 Exsr StopService;
              When PTask = 'DELETE';               // Uninstall Service
                 Exsr UninstallService;
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
           WkObj   = *Blanks;
           WkLib   = *Blanks;
           WkPcml  = *Blanks;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : DeployService Subroutine :
      *?                :--------------------------:
      *
        Begsr DeployService;

      *?   // Set Library and Object Path
           Select;
              When PSERVER = 'WSTEST';             // Dev Environment
                 WkObj = '/QSYS.LIB/TESTPAK400.LIB/WSORDER001.PGM';
                 WkLib = 'TESTPAK400:TESTDATA:KUBEPAK400:TGMSDATA:LIBHTTP';

              When PSERVER = 'WSQUAL';             // QA Environment
                 WkObj = '/QSYS.LIB/QUALPAK400.LIB/WSORDER001.PGM';
                 WkLib = 'QUALPAK400:QUALDATA:KUBEPAK400:TGMSDATA:LIBHTTP';

              When PSERVER = 'WSPROD';             // Production Environment
                 WkObj = '/QSYS.LIB/KUBEPAK400.LIB/WSORDER001.PGM';
                 WkLib = 'KUBEPAK400:TGMSDATA:LIBHTTP';

           Endsl;

      *?   // Refer Pcml Path
           If PService = 'WSPURCHASEORDER';
              WkPcml = '/home/WSUSER/PCML/WSPURCHASEORDER.pcml';
           Elseif  PService = 'WSACKNOWLEDGE';
              WkPcml = '/home/WSUSER/PCML/WSACKNOWLEDGE.pcml';
           Endif;

      *?   // Deploy Service
           Monitor;
              WkCmd = '/QIBM/ProdData/OS/WebServices/bin/' +
                      'installWebService.sh -server ' + %Trim(PServer) +
                      ' -programObject ' + %Trim(WkObj)                +
                      ' -service ' + %Trim(PService)                   +
                      ' -userid WSUSER'                                +
                      ' -serviceType *REST'                            +
                      ' -pcml ' + %Trim(WkPcml)                        +
                      ' -libraryList ' + %Trim(WkLib)                  +
                      ' -libraryListPosition *FIRST';

              Command = 'STRQSH CMD(''' + %Trim(WkCmd) + ''' )';

      *?      // Call CL Command
              QCmdExc(%Trim(Command): %Len(%Trim(Command)));
           On-Error;
           EndMon;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : StartService Subroutine :
      *?                :-------------------------:
      *
        Begsr StartService;

      *?   // Start the Service
           Monitor;
              WkCmd   = '/QIBM/ProdData/OS/WebServices/bin/'          +
                        'startWebService.sh -server ' + %Trim(PServer)+
                        ' -service ' + %Trim(PService);

              Command = 'STRQSH CMD(''' + %Trim(WkCmd) + ''')';

      *?      // Call CL Command
              QCmdExc(%Trim(Command): %Len(%Trim(Command)));
           On-Error;
           EndMon;

        EndSr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : StopService Subroutine :
      *?                :------------------------:
      *
        Begsr StopService;

      *?   // Stop the Server
           Monitor;
              WkCmd   = '/QIBM/ProdData/OS/WebServices/bin/'          +
                        'stopWebService.sh -server ' + %Trim(PServer) +
                        ' -service ' + %Trim(PService);

              Command = 'STRQSH CMD(''' + %Trim(WkCmd) + ''')';

      *?      // Call CL Command
              QCmdExc(%Trim(Command): %Len(%Trim(Command)));
           On-Error;
           EndMon;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-----------------------------:
      *?                : UninstallService Subroutine :
      *?                :-----------------------------:
      *
        Begsr UninstallService;

      *?   // Uninstall the Service
           Monitor;
              WkCmd   = '/QIBM/ProdData/OS/WebServices/bin/'          +
                        'uninstallWebService.sh -server ' + %Trim(PServer) +
                        ' -service ' + %Trim(PService);

              Command = 'STRQSH CMD(''' + %Trim(WkCmd) + ''')';

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
