      *? Program        : WSPLGORD01
      *?
      *? Description    : This pgm to Create Plug Order Entry for the Customer
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 13 Jul 2018
      //--------------------------------------------------------------------
      *? Special Notes  : ** Validate Screen fields and Process
      *?
      *? Called Program : WSPLGORD02 - WS - Plug Entry Order Creation - Item Entry Screen
      *?                : WSRTVMSG   - WS - Retrieve message from Message file
      *?                : LKCUST     - Customer Lookup
      *?                : LKTELE     - Telephone Number Lookup
      *?                : LKZIP      - Customer Zip Code Lookup
      *?                : QCMDEXC    - Pgm To Call CL command in Rpg
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
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes)
           BndDir('*LIBL/KPFUNCTION') DatFmt(*usa);
        /COPY QFunctDefn,@CopyRight
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: FMCUST  M/F Customer Master File
      *?Key : Customer Number
        Dcl-F FMCUST Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: FMINVT  Item Master File
      *?Key : Item : Size
        Dcl-F FMINVT Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Display file for Plug Order Entry Program
        Dcl-F WSPLG001FM Workstn Indds(Dspf);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSPLGORD01 End-Pi;
      *
      *?Procedure Prototype Declaration : To Call Plug Entry Subfile Program
        Dcl-Pr WSPLGORD02 Extpgm;
          PReqdte   Packed(6);
          PCust#    Packed(6);
          PItem     Char(5);
          PSize     Char(3);
          PDesc     Char(30);
          PAlpha    Char(15);
          PSts      Char(2);
        End-Pr;
      *
      *?Procedure Prototype Declaration : To get Customer based on Alpha Search
        Dcl-Pr Lkcust Extpgm;
          PLook     Char(15);
          PCust#    Packed(6);
          PName     Char(30);
        End-Pr;
      *
      *?Procedure Prototype Declaration : To get Customer based on Telephone# Search
        Dcl-Pr Lktele Extpgm;
          PTele#    Packed(10);
          PCust#    Packed(6);
          PName     Char(30);
        End-Pr;
      *
      *?Procedure Prototype Declaration : To get Customer based on Zip Code Search
        Dcl-Pr Lkzip Extpgm;
          PZip      Char(9);
          PCust#    Packed(6);
          PName     Char(30);
        End-Pr;
      *
      *?Procedure Prototype Declaration : To Call CL program to Retreive MSG
        Dcl-Pr RtvErrMsg Extpgm('WSRTVMSG');            // CL Program
           WkMsgId  Char(7);                            // Msg Id
           WkMsgF   Char(10);                           // Msg File
           WKMsg    Char(132);                          // Msg
           WkDta    Char(10);                           // Msg Data
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
        Dcl-S ModReq    Char(10)  Inz;
        Dcl-S FunReq    Char(10)  Inz;
        Dcl-S Cmd       Char(200) Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkMsgf   Char(10)    Inz;                // Used for Msg File
        Dcl-S WkMsgId  Char(7)     Inz;                // Used for Msg File
        Dcl-S WkMsg    Char(132)   Inz;                // Used for Msg File
        Dcl-S WkDta    Char(10)    Inz;                // Used for Msg File
        Dcl-S WkMonDte Packed(6)   Inz;                // Used for Sql
        Dcl-S WkRbDte  Date(*ISO);                     // Used for Sql
        Dcl-S WkReqDt  Date(*ISO);                     // Used for Sql
        Dcl-S WkItem   Char(12)    Inz;                // Used for Msg File
      *
      *?Flag Variables Declaration :
        Dcl-S FlError  Ind Inz(*Off);
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Parameter Variable Declaration :
        Dcl-S PCust#  Packed(6)  Inz;
        Dcl-S PName   Char(30)   Inz;
        Dcl-S PLook   Char(15)   Inz;
        Dcl-S PTele#  Packed(10) Inz;
        Dcl-S PZip    Char(9)    Inz;
        Dcl-S PReqdte Packed(6)  Inz;
        Dcl-S PSts    Char(2)    Inz;
      *
      *?Display File Indicators Declaration :
        Dcl-Ds Dspf Qualified;
           Exit        Ind Pos(3);              // Exit Function Key
           PrevWeek    Ind Pos(7);              // Previous Function Key
           NextWeek    Ind Pos(8);              // Next Function Key
      *
           RCustRi     Ind Pos(11);             // Record Customer Ind
           RReqDteRi   Ind Pos(12);             // Record Requested Date Ind
           RItemRi     Ind Pos(13);             // Record Item Search Ind
           RSizeRi     Ind Pos(14);             // Record Size Search Ind
        End-Ds;
      //--------------------------------------------------------------------
      *?                :-------------:
      *?                : Copy Source :
      *?                :-------------:
      *
      *?Function Prototypes
    ? /COPY QFunctDefn,$_Dates
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Process until Exit
           Dou ModReq = 'EXIT';

      *?      // Process Screen
              Dow ModReq = 'SCREEN';
                 Exsr SN1M;
              Enddo;

           Enddo;

      *?   // Release Cursor to Unlock Qtemp Files
           Exec Sql
             Set Option CLOSQLCSR=*ENDMOD;

      *?   // End Program
           *InLr = *On;
           Return;

      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1M Subroutine :
      *?                :-----------------:
      *
      *?Logic : Call subroutine based on functional request
      *?
        Begsr SN1M;

      *?   // Initialization
           If FunReq = 'INITIAL' Or FunReq = 'RELOAD';
              Exsr SN1I;
           Endif;

      *?   // Display
           If FunReq = 'DISPLAY';
              Exsr SN1D;
           Endif;

      *?   // Validate
           If FunReq = 'VALIDATE';
              Exsr SN1V;
           Endif;

      *?   // Process
           If FunReq = 'PROCESS';
              Exsr SN1P;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1I Subroutine :
      *?                :-----------------:
      *
      *?Logic : Clear all screen Input Parameters and control field values
      *?
        Begsr SN1I;

      *?   // Initialise Reverse Image indicator
           Dspf.RCustRi   = False;
           Dspf.RReqDteRi = False;

      *?   // Clear Plug Order Work File
           Cmd = 'CLRPFM FILE(QTEMP/WPLGORDPF)';
           Exsr CallCmd;

      *?   // Clear XML Work File
           Cmd = 'CLRPFM FILE(QTEMP/WPLGORXML)';
           Exsr CallCmd;

      *?   // Clear Record Format
           Clear PLGSCRN01;

      *?   // Move Default Values
           Exec sql SET :WkRbDte = Ready_Bay_Week;
           REQDTE = %Int(%Char(WkRbDte:*MDY0));

      *?   // Move Values into Screen
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1D Subroutine :
      *?                :-----------------:
      *
      *?Logic : Write the Record Format , Check the Function Key Pressed
      *?
        Begsr SN1D;

      *?   // Write the Record format
           Exfmt PLGSCRN01;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';

      *?      // F8 Pressed
              When Dspf.PrevWeek;
                 REQDTE = $MDYDate($AddDate($DateMDY(REQDTE):-7));
                 FunReq = 'DISPLAY';

      *?      // F9 Pressed
              When Dspf.NextWeek;
                 REQDTE = $MDYDate($AddDate($DateMDY(REQDTE):+7));
                 FunReq = 'DISPLAY';

      *?      // Enter Pressed
              Other;
                 FunReq = 'VALIDATE';
           Endsl;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1V Subroutine :
      *?                :-----------------:
      *
      *?Logic : Validate input Capable Fields
      *?      : If No errors then Process , Else Display error in Screen
      *?
        Begsr SN1V;

      *?   // Clear Message
           Clear ErrMsg;

      *?   // Initialise Reverse Image Indicator & Flag
           FlError = False;
           Dspf.RCustRi  = False;
           Dspf.RReqDteRi= False;
           Dspf.RItemRi  = False;
           Dspf.RSizeRi  = False;

      *?   // Validate Alpha search Field
           If Alpha <> *Blanks and FlError = False;
              LkCust(Alpha:PCust#:PName);
              Alpha = *Blanks;
              Cust# = PCust#;
              Name  = PName;
           Endif;

      *?   // Validate Telephone search Field
           If Alpha = *Blanks and Tele# <> *Zeros and FlError = False;
              LkTele(Tele#:PCust#:PName);
              Tele# = *Zeros;
              Cust# = PCust#;
              Name  = PName;
           Endif;

      *?   // Validate Zip# Field
           If Alpha = *Blanks and Tele# = *Zeros and Zip# <> *Blanks
              and FlError = False;
              LkZip(Zip#:PCust#:PName);
              Zip#  = *Blanks;
              Cust# = PCust#;
              Name  = PName;
           Endif;

      *?   // Validate Customer Field
           If Cust# = *Zeros and FlError = False;
              FlError = True;
              Dspf.RCustRi = True;
              WkMsgID = 'WS00065';
              Exsr ErrMessage;
           Elseif Cust# <> *Zeros and FlError = False;
              Chain Cust# FMCUST;
              Name = CMNAME;
              If Not %Found;
                 FlError = True;
                 Dspf.RCustRi =  True;
                 WkMsgID = 'WS00015';
                 Exsr ErrMessage;
              Else;
                 If CMSTAT <> 'A';
                    FlError = True;
                    Dspf.RCustRi = True;
                    WkMsgID = 'WS00023';
                    Exsr ErrMessage;
                 Endif;
              Endif;
           Endif;

      *?   // Validate Requested Date Field
           If ReqDte = *Zeros and FlError = False;
              FlError = True;
              Dspf.RReqDteRi = True;
              WkMsgID = 'WS00002';
              Exsr ErrMessage;
           Elseif ReqDte <> *Zeros and FlError = False;
              Exec sql
                 Select MONDAY_DATE_mdy6 into :WkMonDte from Mondays
                        Where monday_date_mdy6 = :Reqdte;
              If SqlCod <> 0;
                 FlError = True;
                 Dspf.RReqDteRi = True;
                 WkMsgID = 'WS00070';
                 Exsr ErrMessage;
              Endif;
              If FlError =  False;
                 WkReqDt = %Date(ReqDte:*MDY);
                 If WkRbDte > WKReqdt;
                    FlError = True;
                    Dspf.RReqDteRi = True;
                    WkMsgID = 'WS00069';
                    Exsr ErrMessage;
                 Endif;
              Endif;
           Endif;

      *?   // Validate Item Field
           If ItemS <> *Blanks and FlError = False;
              WkItem = ItemS;
              Chain WkItem FMINVT;
              If Not %Found;
                 FlError = True;
                 Dspf.RItemRi =  True;
                 WkMsgID = 'WS00021';
                 Exsr ErrMessage;
              Else;
                 If IMSTAT <> 'A';
                    FlError = True;
                    Dspf.RItemRi = True;
                    WkMsgID = 'WS00024';
                    Exsr ErrMessage;
                 Endif;
              Endif;
           Endif;

      *?   // Validate Size Field
           If SizeS <> *Blanks and ItemS <> *Blanks and FlError = False;
              WkItem = ItemS;
              Chain (WkItem:SizeS) FMINVT;
              If Not %Found;
                 FlError = True;
                 Dspf.RItemRi = True;
                 Dspf.RSizeRi = True;
                 WkMsgID = 'WS00021';
                 Exsr ErrMessage;
              Endif;
           Endif;

      *?   // Process non error screen
           If FlError = True;
              FunReq = 'DISPLAY';
           Else;
              FunReq = 'PROCESS';
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1P Subroutine :
      *?                :-----------------:
      *
      *?Logic : Process Non Error Screen Inputs
      *?
        Begsr SN1P;

      *?   // Call Item Entry Screen
           PReqdte = %Int(Reqdte);
           PSts = *Blanks;
           WSPLGORD02(PReqDte:Cust#:ItemS:SizeS:Desc:Alphas:PSts);
           If PSts = '03';
              ModReq = 'EXIT';
           ElseIf PSts = '12';
              ModReq = 'SCREEN';
              FunReq = 'INITIAL';
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : INZSR Subroutine :
      *?                :------------------:
      *
      *?Logic : Initialise Subroutine
      *?
        Begsr *InzSr;

      *?   // Initial Screen
           ModReq = 'SCREEN';
           FunReq = 'INITIAL';

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
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : ErrMessage Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Call CL program to Show Message
      *?
        Begsr ErrMessage;

      *?   // Show Message On Screen from Message File
           Monitor;
             WkMsgf = 'WSMSGF';
             WkDta  = *Blanks;
             RtvErrMsg(WkMsgID:WkMsgf:WkMsg:WkDta);
           On-Error;
           EndMon;
           ErrMsg = WkMsg;
           ModReq = 'SCREEN';
           FunReq = 'DISPLAY';

        Endsr;
      *?---------------- End Of Subroutines --------------------------------
