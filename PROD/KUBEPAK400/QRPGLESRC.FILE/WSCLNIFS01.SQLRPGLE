      *? Program        : WSCLNIFS01
      *?
      *? Description    : This program to Cleanup files on IFS based on Retention File
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 30 Jul 2019
      //--------------------------------------------------------------------------
      *? Special Notes  : ** Clear IFS Folders and Files based on retention file
      *?                     Data
      *?                : ** If Type = '*DIR' ,Clear Objects and Remove Directory
      *?                : ** If Type = '*STMF',Remove Link from IFS
      *
      *? Called Program : QCMDEXC - Pgm To Call CL command in Rpg
      //--------------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      *
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*No) Option(*SrcStmt : *NoDebugIO) Debug(*Yes)
           BndDir('*LIBL/KPFUNCTION') DatFmt(*Usa);
      //--------------------------------------------------------------------
      *? Copy Httpapi_h Source
       /Copy QFunctDefn,@CopyRight
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSCLNIFS01 ExtPgm;
        End-Pi;
      *
      *?Procedure Prototype Declaration : Pgm to Call Command
        Dcl-Pr QCMDEXC    Extpgm;
           Cmd Char(2000)   Const Options(*Varsize);
           Len Packed(15:5) Const;
        End-Pr;
      *
      *?Program Status Data Structure   :
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?Global Variable Declaration     :
        Dcl-S Cmd         Char(2000) Inz;
        Dcl-S DelStatus   Char(75) Inz;
      *
      *?Work Variable Declaration       :
        Dcl-S WkDirect    Char(256)  Inz;
        Dcl-S WkDirect1   Char(256)  Inz;
        Dcl-S WkDirect2   Char(300)  Inz;
        Dcl-S WkFile      Char(400)  Inz;
        Dcl-S WkType      Char(40)   Inz;
      //--------------------------------------------------------------------
      *?                :--------------:
      *?                : Copy  Source :
      *?                :--------------:
      *
      *?Service Programs
    ? /Include QFunctDefn,$_DLTIFS
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Initialize
           Exsr InzPgm;

      *?   // End Program
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Initialise Subroutine :
      *?                :-----------------------:
      *
        Begsr InzPgm;

      *?   // Execute Process
           Exsr Process;

      *?   // Close Cursor
           Exec Sql Close A1;
           Exec Sql Close A2;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

      *?   // Return
           *InLr = *On;
           Return;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Process Subroutine :
      *?                :--------------------:
      *
        Begsr Process;

      *?   // Get Unique Records from Retention File
           Exec Sql Declare A1 Cursor For
              Select Distinct DIRECTORY from Retention
              Order By DIRECTORY;

      *?   // Open Cursor
           Exec Sql Open A1;
           If SqlCode = -502 ;
              Exec Sql Close A1;
              Exec Sql Open A1;
           Endif;
           Exec Sql Fetch A1 into :WkDirect;

      *?   // Select IFS files for Deletion
           Dow SqlCod = 0;

      *?      // Get Records
              Exec Sql Declare A2 Cursor For
                 SELECT Distinct Trim(DIRECTORY)||'/'||Trim(FILENAME) as
                 DELETE_FILES, TYPE
                 FROM TABLE(QGPL.IFSDIR(:WkDirect)) T
                 Join Webservices_Retention_Policy On Directory =
                 (:WkDirect) and File_type = TYPE
                 Where  (File_beg_with = ' '  Or FILENAME Like
                 Trim(File_beg_with)||'%'     Or File_beg_with = '*ANY' )
                    And (File_end_with = ' '  Or FILENAME Like
                 '%'||Trim(File_end_with) )
                    And (File_contains = ' '  Or FILENAME Like
                 '%'||Trim(File_contains)||'%' )
                    And MODIFY_TIME < Current Timestamp - Retention_Days days;

      *?      // Open Cursor
              Exec Sql Open A2;
              If SqlCode = -502 ;
                 Exec Sql Close A2;
                 Exec Sql Open A2;
              Endif;

      *?      // Fetch Unique record from Retention
              Exec Sql Fetch A2 into :WkDirect1, :WkType;
              Dow SqlCod = 0;
                 WkDirect2 = %Trim(WkDirect1);
                 If WkType = '*DIR';
                    WkType = 'DIR';
                 Elseif WkType = '*STMF';
                    WkType = 'FIL';
                 Endif;

      *?         // Call Delete Function to Clear File/Folder
                 DelStatus = $DLTIFSFIL(WkType:WkDirect2);
                 WkType = *Blanks;

                 Exec Sql Fetch A2 into :WkDirect1, :WkType;
              Enddo;

              Exec Sql Fetch A1 into :WkDirect;
           Enddo;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : CallCmd Subroutine :
      *?                :--------------------:
      *
        Begsr CallCmd;

      *?   // Call QCMDEXC ,Monitor if there is a error
           Monitor;
              QCmdExc(%Trim(Cmd): %Len(%Trim(Cmd)));
           On-Error;
           EndMon;

        Endsr;
      *?------------- End of Program ----------------------------------
