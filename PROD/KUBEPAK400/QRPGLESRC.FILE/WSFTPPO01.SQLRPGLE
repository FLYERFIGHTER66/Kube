      *? Program        : WSFTPPO01
      *?
      *? Description    : This program to read IFS and get the file name
      *?                  for the further PO/CO Process
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 06 June 2018
      //--------------------------------------------------------------------
      *? Special Notes  : 1. Read directory get XML name
      *?                  2. Get data from XML
      *?                  3. Remove XML from temp folder
      *?                  4. Pass XML as a string to WSORDER001 Program
      *
      *? Called Program : WSORDER001 - B2B WS Pgm to rcv PO&CO Xml
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
      * SUD01   10/09/18   S.Uthaya     Change CCSID code and String Delimiter
      *         10/11/18   S.Uthaya     Change CCSID code
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
        Dcl-Pi WSFTPPO01;
           PBroker Char(10);
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
           Cmd Char(200)    Const Options(*Varsize);
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
        Dcl-S Cmd        Char(400) Inz;
        Dcl-S Dh         Pointer;
        Dcl-S Name       Char(640);
        Dcl-S Xml        Char(900);
        Dcl-S HttpStatus Int(10:0);
      *
      *?Work Variable Declaration :
        Dcl-S WkXml    Char(1000000) Inz;
        Dcl-S WkFile   Char(75)      Inz;
        Dcl-S WkFlag   Char(1)       Inz('Y');
        Dcl-S WkBroker Char(20)      Inz;
        Dcl-S WkPos    Int(10:0)     Inz;
        Dcl-S WkPath   Char(75)      Inz;
        Dcl-S WkPathPO Char(75)      Inz;
      *
      *?Parameter Variable Declaration :
        Dcl-S PAckXml    Char(1000000) Inz;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

           Exsr InzPgm;
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : InzPgm Subroutine :
      *?                :-------------------:
      *
        Begsr InzPgm;

      *?   // Create IFSXML temp file in QTEMP
           Cmd = 'CRTPF FILE(QTEMP/CPYXML) RCDLEN(900)';
           Exsr CallCmd;

      *?   // Open and Read Directory
           Exsr OpenDirSr;

        Endsr;
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : OpenDirSr Subroutine :
      *?                :----------------------:
      *
        Begsr OpenDirSr;

      *?   // Get File Path
           Chain (PBroker : 'IFSORDPATH') FBROKDFTL0;
           If %Found;
              WkPath = %Trim(DFVARVAL);
           Endif;

      *?   // Open up the directory
           Dh = Opendir(%Trim(WkPath)) ;
           If Dh = *NULL ;
              Exsr EndPgm;
           Endif ;

      *?   // Read each entry from the directory (in a loop)
           p_dirent = Readdir(dh);
           Dow p_dirent <> *NULL ;
              Name = %Str(%Addr(d_name));
              Wkpos = *Zeros;
              Wkpos = %Scan('.xml' : Name : 1);
              If WkPos <> *Zeros;
                 Exsr Process;                   // Process PO/CO
              Endif;
              p_dirent = Readdir(dh);
           Enddo ;

      *?   // Close the directory
           Closedir(dh) ;

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
           WkFile = %Trim(WkPath) + '/' + %Trim(Name);
           CMD = 'CPYFRMIMPF FROMSTMF(''' + %Trim(WkFile) + ''')'   +
                 ' TOFILE(CPYXML) MBROPT(*REPLACE) FROMCCSID(1208)' +
SUD01            ' TOCCSID(838) RCDDLM(*CRLF) STRDLM(*NONE) FLDDLM(*TAB)';
           Exsr CallCmd;

      *?   // Remove Link from IFS
           Cmd = 'RMVLNK OBJLNK(''' + %Trim(WkFile) + ''')';
           Exsr CallCmd;

      *?   // Read Flat file and get XML as a string
           Exsr ReadXML;

      *?   // Process Order for each XML
           Exsr OrderProcess;

      *?   // Store XML in IFS for FTP use
           Chain (PBroker : 'IFSORDFTP') FBROKDFTL0;
           If %Found;
              WkPathPO = %Trim(DFVARVAL);
           Endif;

           Cmd = 'CPYTOSTMF FROMMBR' +
                 '(''' + '/QSYS.LIB/QTEMP.LIB/CPYXML.FILE/CPYXML.MBR' + ''')' +
                 ' TOSTMF(''' + %Trim(WKPathPO) + %Trim(Name) + ''')' +
SUD01            ' STMFCCSID(1208)';
           Exsr CallCmd;

      *?   // Clear Temp File
           Cmd  = 'CLRPFM FILE(QTEMP/CPYXML)';
           Exsr CallCmd;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : ReadXML Subroutine :
      *?                :--------------------:
      *
        Begsr ReadXML;

      *?   // Read XML File and make it String
           Exec Sql Declare A1 Cursor For
              Select CPYXML From QTEMP/CPYXML;
              Exec Sql
                 Open A1;
              If SqlCode = -502 ;
                  Exec Sql
                  Close A1;
                  Exec Sql
                  Open A1;
              EndIf;

           Exec Sql Fetch A1 Into :Xml;

      *?   // Make XML as a String
           WkFlag = 'Y';
           Dow SqlCod = 0;
              If WkFlag = 'Y';
                 WkPos = *Zeros;
                 Wkpos = %Scan('<?xml version' : Xml : 1);
                 If WkPos <> *Zeros;
                    WkFlag = 'N';
                    WkXml  = *Blanks;
                 Else;
                    WkFlag = 'N';
                    WkXml = %Trim(WkXml) + %Trim(Xml);
                 Endif;
              Else;
                 WkXml = %Trim(WkXml) + %Trim(Xml);
              Endif;
              Exec Sql Fetch A1 Into :Xml;
           Enddo;
           Exec Sql Close A1;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : OrderProcess Subroutine :
      *?                :-------------------------:
      *
        Begsr OrderProcess;

      *?   // Call Order Driver Program
           PAckXml    = *Blanks;
           HttpStatus = 0;
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
