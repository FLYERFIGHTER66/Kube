      *? Program        : WSSTOREXML
      *?
      *? Description    : This pgm to Consume XML as a string and Store into
      *?                  IFS folder for Future Use
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 09 Oct 2018
      //--------------------------------------------------------------------
      *? Special Notes  : ** Substring XML based on Length
      *?                  ** Write Record into Flat file
      *?                  ** Copy Flat File to IFS Folder
      *
      *? Called Program : QCMDEXC - Pgm To Call CL command in Rpg
      //------------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ----------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ----------------------------------------
      *?Changes in 2019
      * SUD01   03/21/19   S.Uthaya     Added Logic to Store Vendor Acknowledgement
      *                                 Xml in IFS
      * SUD02   09/11/19   S.Uthaya     Added Logic to Store Dummen URC Inventory Xml
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
        Dcl-Pi WSSTOREXML;
SUD02      POXml      Char(9999999) Options(*Varsize);
           PBroker    Char(30);
           PBrokerId  Char(10);
           PFlag      Char(10);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Pgm to Call Command
        Dcl-Pr QCMDEXC Extpgm;
           Cmd Char(200)    Const Options(*Varsize);
           Len Packed(15:5) Const;
        End-Pr;
      *
      *?Global Variable Declaration :
        Dcl-S XmlIfs  Char(3965) Inz;
        Dcl-S Cmd     Char(200)  Inz;
        Dcl-S X       Zoned(9)   Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkPath  Char(75)   Inz;
        Dcl-S WkFile  Char(75)   Inz;
        Dcl-S WkLen   Packed(9)  Inz;
        Dcl-S WkPos   Packed(9)  Inz;
        Dcl-S WkDiv   Packed(9)  Inz;
        Dcl-S WkRem   Packed(9)  Inz;
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
           WkLen   = *Zeros;
           WkDiv   = *Zeros;
           WkRem   = *Zeros;

      *?   // Delete CPYIFS temp file in QTEMP , If Exists
           Cmd = 'DLTF FILE(QTEMP/CPYIFS)';
           Exsr CallCmd;

      *?   // Create CPYIFS temp file in QTEMP
           Cmd = 'CRTPF FILE(QTEMP/CPYIFS) RCDLEN(3965)';
           Exsr CallCmd;

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
      *?Logic : Copy to Ifs folder based on Order and Broker Name
      *
        Begsr CopyToIfsSr;

      *?   // Create Stream File Name
           WkFile = *Blanks;
SUD02      If PFlag = 'Ack';
              WkFile = %Trim(PBroker) + '_' + %Trim(PBrokerId) + '_'
                            + %Char(%Timestamp()) + '.xml';
SUD02      Elseif PFlag = 'Inventory';
  |           WkFile = 'GetInv_' + %Trim(PBroker) + '_'
SUD02                       + %Char(%Timestamp()) + '.xml';
           Else;
              WkFile = 'Ack_' + %Trim(PBroker) + '_' + %Trim(PBrokerId) + '_'
                            + %Char(%Timestamp()) + '.xml';
           Endif;

      *?   // Get Ifs Path
           If PFlag = 'Create';
              Chain ('1000' : 'POIFSPATH' ) FBROKDFTL0;
           Elseif PFlag = 'Change';
              Chain ('1000' : 'COIFSPATH' ) FBROKDFTL0;
SUD01      Elseif PFlag = 'Ack';
SUD01         Chain ('1000' : 'ACKIFSPATH' ) FBROKDFTL0;
SUD02      Elseif PFlag = 'Inventory';
SUD02         Chain ('1000' : 'URCIFSPATH' ) FBROKDFTL0;
           Endif;
           If %Found;
              WkPath = %Trim(DFVARVAL);
           Endif;

      *?   // Copy to Folder
           Cmd = 'CPYTOIMPF FROMFILE(CPYIFS) STMFCODPAG(1208) ' +
                 'TOSTMF(''' + %Trim(WkPath) + %Trim(WkFile) + ''')'
                  + ' MBROPT(*REPLACE) RCDDLM(*CRLF) DTAFMT(*FIXED)';
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
