      *? Program        : WSSAVXML01
      *?
      *? Description    : This pgm to Consume PO XML as a string and Store into
      *?                  IFS folder for Reprocess Order
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 31 Jan 2019
      //--------------------------------------------------------------------
      *? Special Notes  : ** Substring POXML based on Length
      *?                  ** Write Record into Flat file
      *?                  ** Copy Flat File to IFS Folder
      *
      *? Called Program : QCMDEXC - Pgm To Call CL command in Rpg
      *
      //------------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ----------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ----------------------------------------
      *
      //------------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*No) Option(*NoDebugIO);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: WS - Broker Defaults and Control Logical File
      *?Key : Broker Number:Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);
      //------------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSSAVXML01 ExtPgm;
           POXml      Char(1000000) Options(*Varsize);
           PBroker    Char(30);
           PBrokerId  Char(10);
           PFlag      Char(2);
           Process    Char(1);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Pgm to Call Command
        Dcl-Pr QCMDEXC Extpgm;
           Cmd Char(2000)   Const Options(*Varsize);
           Len Packed(15:5) Const;
        End-Pr;
      *
      *?Program Status Data Structure : PSDS
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           JobNum  Zoned(6) Pos(264);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?Global Variable Declaration :
        Dcl-S XmlIfs  Char(3965) Inz;
        Dcl-S Cmd     Char(2000) Inz;
        Dcl-S X       Zoned(3)   Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkPath  Char(75)   Inz;
        Dcl-S WkFile  Char(75)   Inz;
        Dcl-S WkCount Packed(3)  Inz;
        Dcl-S WkLen   Packed(7)  Inz;
        Dcl-S WkPos   Packed(7)  Inz;
        Dcl-S WkDiv   Packed(4)  Inz;
        Dcl-S WkRem   Packed(4)  Inz;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Execute Initialize
           Exsr InzPgm;

      *?   // End Program
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Initialise Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Initialise Parameters & Proceed Validation
      *?
        Begsr InzPgm;

      *?   // Clear Variables
           WkCount = *Zeros;
           WkLen   = *Zeros;
           WkDiv   = *Zeros;
           WkRem   = *Zeros;

      *?   // Create CPYIFS temp file in QTEMP
           Exec SQL Create or Replace table QTEMP.CPYIFS (CPYIFS VARCHAR(3965));
           Exec SQL Delete from QTEMP.CPYIFS;

      *?   // Substring and Copy to Flat File
           Exsr CopytoFlatFile;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------------:
      *?                : CopytoFlatFile Subroutine :
      *?                :---------------------------:
      *
      *?Logic : SubString Xml and Write in to Flat
      *?
        Begsr CopytoFlatFile;

      *?   // Check Length of String
           If POXml <> *Blanks;
              WkDiv = *Zeros;
              WkRem = *Zeros;
              WKLen = %Len(%Trim(POXml));
              WkDiv = %Div(WkLen:3965);
              WkRem = %Rem(WkLen:3965);
           Endif;

      *?   // Substring and Write into Flat file
           If WkDiv >= 1;
              For X = 1 to WkDiv;
                 XmlIfs = *Blanks;
                 If X = 1;
                    XmlIfs = %Subst(POXml : 1 : 3965);
                 Else;
                    WkPos  = ((X-1) * 3965) + 1;
                    XmlIfs = %Subst(POXml : WkPos : 3965);
                 Endif;

      *?         // Insert into Flat File
                 Exec Sql
                    INSERT INTO CPYIFS Values(:XMLIFS);
              Endfor;
           Endif;

           If WkDiv = *Zeros;
              XmlIfs = %Subst(POXml : 1 : WkLen);

      *?      // Insert into Flat File
              Exec Sql
                 INSERT INTO CPYIFS Values(:XMLIFS);
           Endif;

           If WkRem <> *Zeros and WkDiv <> *Zeros;
              WkPos  = (WkDiv * 3965) + 1;
              XmlIfs = %Subst(POXml : WkPos : WkRem);

      *?         // Insert into Flat File
                 Exec Sql
                    INSERT INTO CPYIFS Values(:XMLIFS);
           Endif;

      *?   // Copy to IFS
           Exsr CopyToIfsSr;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : CopyToIfsSr Subroutine :
      *?                :------------------------:
      *
      *?Logic : Copy to Ifs folder based on Broker Name
      *
        Begsr CopyToIfsSr;

      *?   // Create Stream File Name for Reprocess Xml
           WkFile = *Blanks;
           If Process= 'R';
              WkFile = %Trim(PBroker) + '_' + %Char(%Timestamp()) + '.xml';

      *?   // Create Stream File Name for Error Xml
           Elseif Process = 'E';
              WkFile = %Trim(Job) + '_' + %Char(%Timestamp()) + '.xml';
           Endif;

      *?   // Get Ifs Path
           If Process= 'R';
              If PFlag = 'PO';
                 Chain ('1000' : 'POREPROCESSPATH') FBROKDFTL0;
              Elseif PFlag = 'CO';
                 Chain ('1000' : 'COREPROCESSPATH') FBROKDFTL0;
              Endif;
           Elseif Process = 'E';
              Chain ('1000' : 'ORDERERRORPATH') FBROKDFTL0;
           Endif;
           If %Found;
              WkPath = %Trim(DFVARVAL);
           Endif;

      *?   // Copy to Folder
           Cmd = 'CPYTOIMPF FROMFILE(CPYIFS) STMFCODPAG(1208) '
               + 'TOSTMF(''' + %Trim(WkPath) + %Trim(WkFile) + ''')'
               + ' MBROPT(*REPLACE) RCDDLM(*CRLF) DTAFMT(*FIXED)'
               + ' STRDLM(*NONE) RMVBLANK(*TRAILING)';
           Exsr CallCmd;

        EndSr;
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
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

      *?   // Clear Flat File
           Cmd = 'CLRPFM FILE(QTEMP/CPYIFS)';
           Exsr CallCmd;

      *?   // End the Program
           *InLr = *On;
           Return;

        EndSr;
      *?---------------- End Of Subroutines --------------------------------
