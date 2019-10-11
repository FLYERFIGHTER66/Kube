      *? Program        : WSRPSXML01
      *?
      *? Description    : This program to read IFS and get the file name
      *?                  for the further PO/CO Process (From Reprocess Folder)
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 04 Feb 2019
      //--------------------------------------------------------------------
      *? Special Notes  : 1. Read directory get XML name
      *?                  2. Get data from XML
      *?                  3. Remove XML from temp folder
      *?                  4. Pass XML as a string to WSORDER001 Program
      *
      *? Called Program : WSORDER001 - B2B WS Pgm to Rcv PO&CO Xml
      *?                  QCMDEXC    - Pgm To Call CL command in Rpg
      *
      *? Response       : XML Acknowledgement
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      *
      *
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*NO) Actgrp(*NEW) Bnddir('QC2LE')
          Option(*SrcStmt : *NoDebugIO);
      //--------------------------------------------------------------------
      *? Copy Httpapi_h Source
      /Copy QRpglesrc,IFSIO_H
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: WS - Broker Defaults and Control Logical File
      *?Key : Broker Number:Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSRPSXML01 Extpgm;
        End-Pi;
      *
      *?Procedure Prototype Declaration : Webservice Driver Program
        Dcl-Pr WSORDER001 Extpgm;
           POXml      Char(1000000);
           Httpstatus Int(10:0);
           Acknowledgement Like(PAckXml);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Pgm to Call Command
        Dcl-Pr QCMDEXC Extpgm;
           Cmd Char(2000)   Const Options(*Varsize);
           Len Packed(15:5) Const;
        End-Pr;
      *
      *?Program Status Data Structure :
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?Global Variable Declaration :
        Dcl-S Dh         Pointer;
        Dcl-S Cmd        Char(2000)    Inz;
        Dcl-S Name       Char(640);
        Dcl-S Xml        Char(3965);
        Dcl-S HttpStatus Int(10:0);
        Dcl-S NullInd    Int(5) Inz(0);                      // Null Indicator
        Dcl-S NullValue  Like(NullInd) Inz(-1);
      *
      *?Work Variable Declaration :
        Dcl-S WkXml    Char(1000000) Inz;
        Dcl-S WkFile   Char(100)     Inz;
        Dcl-S WkFlag   Char(1)       Inz('Y');
        Dcl-S WkPoFlag Char(2)       Inz;
        Dcl-S WkPath   Char(75)      Inz;
        Dcl-S WkPathPO Char(75)      Inz;
        Dcl-S WkPos    Int(10:0)     Inz;
      *
      *?Parameter Variable Declaration :
        Dcl-S PAckXml  Char(1000000) Inz;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Execute Intialise
           Exsr InzPgm;

      *?   // End Program
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : InzPgm Subroutine :
      *?                :-------------------:
      *
        Begsr InzPgm;

      *?   // Create CPYXML temp file in QTEMP to Store Xml
           Exec SQL Create or Replace table QTEMP.CPYXML (CPYXML VARCHAR(3965));
           Exec SQL Delete from Qtemp.CPYXML;

      *?   // Delete CPYIFS temp file in QTEMP , If Exists
           Cmd = 'DLTF FILE(QTEMP/CPYIFSN)';
           Exsr CallCmd;

      *?   // Create CPYIFS temp file in QTEMP
           Cmd = 'CRTPF FILE(QTEMP/CPYIFSN) RCDLEN(640)';
           Exsr CallCmd;

      *?   // Open and Read Directory
           Exsr OpenCreateDirSr;
           Exsr OpenChangeDirSr;

        Endsr;
      //--------------------------------------------------------------------
      *?                :----------------------------:
      *?                : OpenCreateDirSr Subroutine :
      *?                :----------------------------:
      *
      *?Logic : Open Order Create Reprocess Directory get the file name
      *?        and Process the Order XML
      *
        Begsr OpenCreateDirSr;

      *?   // Get File Path for Order Create Process
           Chain ('1000' : 'POREPROCESSPATH') FBROKDFTL0;
           If %Found;
              WkPath = %Trim(DFVARVAL);
           Endif;

      *?   // Open up the directory
           Dh = Opendir(%Trim(WkPath));
           If Dh = *NULL;
              Closedir(dh);
           Else;

      *?      // Read each entry from the directory (in a loop)
              p_dirent = Readdir(dh);
              Dow p_dirent <> *NULL;
                 Name = %Str(%Addr(d_name));
                 WkPos = *Zeros;
                 WkPos = %Scan('.xml' : Name : 1);
                 If WkPos <> *Zeros;

      *?            // Insert into Flat File
                    Exec Sql INSERT INTO CPYIFSN Values(:Name);
                 Endif;
                 p_dirent = Readdir(dh);
              Enddo;

      *?      // Read IFS File Name and Process the Order
              Exec Sql Declare A2 Cursor For
                 Select CPYIFSN From QTEMP/CPYIFSN Order by CPYIFSN;
              Exec Sql Open A2;
              If SqlCode = -502 ;
                 Exec Sql Close A2;
                 Exec Sql Open A2;
              EndIf;

              Exec Sql Fetch A2 Into :Name;
              Dow Sqlcod = 0;
                  WkPOFlag = 'PO';

      *?          // Process the Order Create
                  Exsr Process;
                  Exec Sql Fetch A2 Into :Name;
              Enddo;

      *?      // Close the directory
              Closedir(dh);

      *?      // Close the Cursor and Clear Temp File
              Exec Sql Close A2;
              Cmd  = 'CLRPFM FILE(QTEMP/CPYIFSN)';
              Exsr CallCmd;

           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :----------------------------:
      *?                : OpenChangeDirSr Subroutine :
      *?                :----------------------------:
      *
      *?Logic : Open Order Change Reprocess Directory get the file name
      *?        and Process the Order XML
      *
        Begsr OpenChangeDirSr;

      *?   // Get File Path for Order Change Process
           Chain ('1000' : 'COREPROCESSPATH') FBROKDFTL0;
           If %Found;
              WkPath = %Trim(DFVARVAL);
           Endif;

      *?   // Open up the directory
           Dh = Opendir(%Trim(WkPath));
           If Dh = *NULL;
              Closedir(dh);
              Exsr EndPgm;
           Else;

      *?      // Read each entry from the directory (in a loop)
              p_dirent = Readdir(dh);
              Dow p_dirent <> *NULL ;
                 Name = %Str(%Addr(d_name));
                 WkPos = *Zeros;
                 WkPos = %Scan('.xml' : Name : 1);
                 If WkPos <> *Zeros;

      *?            // Insert into Flat File
                    Exec Sql INSERT INTO CPYIFSN Values(:Name);
                 Endif;
                 p_dirent = Readdir(dh);
              Enddo;

      *?      // Read IFS File Name and Process the Order
              Exec Sql Declare A3 Cursor For
                 Select CPYIFSN From QTEMP/CPYIFSN Order by CPYIFSN;
              Exec Sql Open A3;
              If SqlCode = -502 ;
                 Exec Sql Close A3;
                 Exec Sql Open A3;
              Endif;

              Exec Sql Fetch A3 Into :Name;
              Dow Sqlcod = 0;
                  WkPOFlag = 'CO';

      *?          // Process the Order Create
                  Exsr Process;
                  Exec Sql Fetch A3 Into :Name;
              Enddo;

      *?      // Close the directory
              Closedir(dh) ;

      *?      // Close the Cursor and Clear Temp File
              Exec Sql Close A3;
              Cmd  = 'CLRPFM FILE(QTEMP/CPYIFSN)';
              Exsr CallCmd;

           Endif;

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

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Process Subroutine :
      *?                :--------------------:
      *
        Begsr Process;

      *?   // Copy data from IFS into Flat File
           WkFile = %Trim(WkPath) +  %Trim(Name);
           CMD = 'CPYFRMIMPF FROMSTMF(''' + %Trim(WkFile) + ''')'   +
                 ' TOFILE(CPYXML) MBROPT(*REPLACE) FROMCCSID(1208)' +
                 ' TOCCSID(838) RCDDLM(*CRLF) STRDLM(*NONE) FLDDLM(*TAB)';
           Exsr CallCmd;

      *?   // Remove Link from IFS
           Cmd = 'RMVLNK OBJLNK(''' + %Trim(WkFile) + ''')';
           Exsr CallCmd;

      *?   // Read Flat file and get XML as a string
           Exsr ReadXML;

      *?   // Process Order for each XML
           Exsr OrderProcess;

      *?   // Clear Temp File
           Cmd  = 'CLRPFM FILE(QTEMP/CPYXML)';
           Exsr CallCmd;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : ReadXML Subroutine :
      *?                :--------------------:
      *
      *?Logic : Read temp file and make Xml String
      *
        Begsr ReadXML;

      *?   // Read XML File and make it String
           Exec Sql Declare A1 Cursor For
              Select CPYXML From QTEMP/CPYXML;
           Exec Sql Open A1;
           If SqlCode = -502 ;
              Exec Sql Close A1;
              Exec Sql Open A1;
           EndIf;

           Exec Sql Fetch A1 Into :Xml;

      *?   // Make XML as a String
           WkFlag = 'Y';
           Dow SqlCod = 0;
              If WkFlag = 'Y';
                 WkPos = *Zeros;
                 WkPos = %Scan('<?xml version' : Xml : 1);
                 If WkPos <> *Zeros;
                    WkFlag = 'N';
                    WkXml  = *Blanks;
                    WkXml = %Trim(WkXml);
                 Else;
                    WkFlag = 'N';
                    WkXml = %Trim(WkXml) + %Trim(Xml);
                 Endif;
              Else;
                 WkXml = %Trim(WkXml) + %Trim(Xml);
              Endif;
              Exec Sql Fetch A1 Into :Xml :NullInd;
           Enddo;
           Exec Sql Close A1;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : OrderProcess Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Call Order Driver Program to Process the Order
      *
        Begsr OrderProcess;

      *?   // Call Order Driver Program
           HttpStatus = 0;
           PAckXml    = *Blanks;

      *?   // Call Order Driver Program
           WSORDER001(WkXml:HttpStatus:PAckXml);

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

      *?   // End Program
           *InLr = *On;
           Return;

        Endsr;
