      *? Program        : WSPOSTXML
      *?
      *? Description    : This program is to Post XML to Client Site
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 02 Nov 2017
      //--------------------------------------------------------------------
      *? Special Notes  :** This program to receive Data as entry
      *?                    parameter and sends to Client Site based
      *?                    Broker
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   06/11/19   S.Uthaya     1.Receive response and check HttpStatus
      *                                 2.Email Notification to Kube-Pak
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
       Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes)
              BndDir('HTTPAPI');
      //--------------------------------------------------------------------
      *? Copy Httpapi_h Source
      /Copy QRpglesrc,Httpapi_h
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
      *?Procedure Interface Declaration: *Entry Parameters
        Dcl-Pi WSPOSTXML ;
           PBrkXml     Char(1000000) Options(*Varsize);
           PFromOrgId  Char(30) Options(*Varsize);
           PFlag       Char(1);
           HttpStatus  Int(10:0);
        End-Pi;
      *
SUD01 *?Procedure Prototype Declaration : Pgm to Call Command
  |     Dcl-Pr QCMDEXC Extpgm;
  |        Cmd Char(200)    Const Options(*Varsize);
  |        Len Packed(15:5) Const;
  |     End-Pr;
  |   *
  |   *?Data Structure Declaration : OrderHeader
  |     Dcl-Ds OrderHeader  Qualified;
  |        VendorOrderID    Char(6);
  |        BrokerOrderId    Char(10);
SUD01   End-Ds;
      *
      *?Constants Variable Declaration : Password for Ball
        Dcl-C UserID    'KBPKRemote';
        Dcl-C Password  'KBPK103585';
      *
      *?Global Variable Declaration :
        Dcl-S Xml      Char(1000000) Inz;
        Dcl-S Url      Char(400)     Inz;
SUD01   Dcl-S Cmd      Char(400)     Inz;
  |     Dcl-S File     Char(100)     Inz;
  |     Dcl-S Options  Char(150)     Inz;
  |     Dcl-S Rc       Int(10:0)     Inz;
  |   *
  |   *?Work Variable Declaration :
  |     Dcl-S WkSub        VarChar(75) Inz;             // Email Subject
  |     Dcl-S WkFile       Char(75)    Inz;
  |     Dcl-S WkExtra      Char(55)    Inz;
  |     Dcl-S WkBroker     Char(10)    Inz;
  |   *
  |   *?Email Variable Declaration :
  |     Dcl-S ToEml       Varchar(256) Inz('raswanekamp@kubepak.com');
  |     Dcl-S BccEmail    Varchar(256) Inz('bcc@kubepak.net');
  |     Dcl-S Html        Varchar(256) Inz('/home/AutoNotification.html');
  |     Dcl-S Name        Char(40)     Inz('KubePak');
SUD01   Dcl-S Qt          Char(1)      Inz('''');
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

      *?   // Clear XML
           Clear Xml;
           Xml = '<?xml version="1.0" encoding="utf-8" ?>';
           Xml = %Trim(Xml) + %Trim(PBrkXml);

      *?   // Post Xml
           Exsr PostXml;

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

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : PostXml Subroutine :
      *?                :--------------------:
      *
        Begsr PostXml;

      *?   // To get tech info about the HTTP transaction
           Http_debug(*ON: '/tmp/httpapi_WSPOSTXML.log');

      *?   // Provide Login Credentials to connect to Client URL
           If PFromOrgId = 'Ball Seed';
              Http_setauth(HTTP_AUTH_BASIC: UserID: Password);
           Endif;

      *?   // Get Broker Number based on FromOrgID
           Chain ('1000' : PFromOrgId) FBrokdftL0;
           If %Found;
              WkBroker = %Trim(DFVARVAL);
           Endif;

      *?   // Get Url from Control File
           If PFlag = 'A';
              Chain (WkBroker :'URL ACKNOWLEDGEMENT POST') FBrokDftL0;
           Elseif PFlag = 'I';
              Chain (WkBroker :'URL INVOICE POST') FBrokDftL0;
           Endif;
           If %Found;
              Url = %Trim(DFVARVAL);
           Endif;

SUD01 *?   // Call Post Service
  |        Exsr CrtStmf;
  |        Monitor;
  |         Rc = Http_Url_post(Url :%Addr(Xml) : %Len(%Trim(Xml))
  |                      : File
  |                      : HTTP_TIMEOUT
  |                      : HTTP_USERAGENT
  |                      :'application/xml');
  |        On-Error;
  |        EndMon;
  |
  |   *?   // If Response code <> 1 (Not Success means Notify to KubePak)
  |        If Rc <> 1;
  |           ExSr GetDetails;
  |           Exsr CrtCmd;
  |        Endif;
  |
  |   *?   // Remove Response Link
  |        Cmd = 'RMVLNK OBJLNK(''' + %Trim(File) + ''')';
  |        Exsr CallCmd;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :--------------------:
  |   *?                : CrtStmf Subroutine :
  |   *?                :--------------------:
  |   *
  |     Begsr CrtStmf;
  |
  |   *?   // Create Stream file in IFS
  |        File =  'Res_' + %Char(%Timestamp())  + '.xml';
  |        Cmd = 'STRQSH Cmd(''' + 'TOUCH ' + %Trim(File) + ''' )';
  |        Exsr CallCmd;
  |
  |   *?   // Change attributes of Stream file
  |        Cmd = 'CHGATR OBJ(''' + %Trim(File) + ''')' +
  |                      ' ATR(*CCSID) VALUE(1208)';
  |        Exsr CallCmd;
  |
  |     EndSr;
  |   //--------------------------------------------------------------------
  |   *?                :-------------------:
  |   *?                : CrtCmd Subroutine :
  |   *?                :-------------------:
  |   *
  |     Begsr CrtCmd;
  |
  |   *?   // Create Command and Move Values
  |        Cmd = 'EMLHTML2' +
  |          ' SUBJECT(' + Qt + %Trim(WkSub) + Qt + ')' +
  |          ' FROMNAME(' + Qt + 'Kube-Pak' + Qt + ')' +
  |          ' FROMADDR(DoNotReply@kubepak.com)' +
  |          ' TO(' + %Trim(ToEml) +  '/' +  %Trim(Name) + '/*TO)' +
  |          ' HTML(' + Qt + Html + Qt + ')' ;
  |        Exsr CallCmd;
  |
  |     EndSr;
  |   //--------------------------------------------------------------------
  |   *?                :-----------------------:
  |   *?                : GetDetails Subroutine :
  |   *?                :-----------------------:
  |   *
  |   *?Logic : Get Order and Broker Order ID from XML
  |   *
  |     Begsr GetDetails;
  |
  |   *?   // Extra Options Values
  |        WkExtra = 'allowextra=yes allowmissing=yes case=any doc=string';
  |
  |   *?   // Get Values into OrderHeader Data Structure
  |        Options = 'path=' + 'BrokerAcknowledgement/OrderHeader ' +
  |                     %Trim(WkExtra) ;
  |        Monitor;
  |           Xml-Into OrderHeader %XML(Xml:Options);
  |        On-Error;
  |           HttpStatus = 500;
  |        EndMon;
  |
  |   *?   // Form the Subject
  |        WkSub = 'Order ' + %Trim(OrderHeader.VendorOrderID) + ' for '
  |                   + %Trim(PFromOrgId) + ' Not acknowledged';
  |
  |     EndSr;
  |   //--------------------------------------------------------------------
  |   *?                :--------------------:
  |   *?                : CallCmd Subroutine :
  |   *?                :--------------------:
  |   *
  |     Begsr CallCmd;
  |
  |   *?   // Call QCMDEXC ,Monitor if there is a error
  |        Monitor;
  |           QCmdExc(%Trim(Cmd): %Len(%Trim(Cmd)));
  |        On-Error;
  |        EndMon;
  |
SUD01   EndSr;
