**FREE
  //? Program        : WSEMLACKB
  //?
  //? Description    : This program to Send Acknowledgement XML
  //?                  through Email
  //? Created By     : S.Uthayadurga
  //?
  //? Date           : 28 Sep 2018
  //--------------------------------------------------------------------
  //? Special Notes  : ** Email Acknowledgement for Brokers
  //
  //? Called Program : BIC420CLEM-O/E Order Acknowledgements Email-Called/Batch
  //?                  SENDACKPDF-Send Acknowledgement PDF
  //?                  SNDPCMSG  -Send a Windows based Popup Message
  //--------------------------------------------------------------------
  //?                :---------------:
  //?                : Modifications :
  //?                :---------------:
  // ------  --------   ----------   ------------------------------------
  // MOD#    MOD Date   Programmer   Description
  // ------  --------   ----------   ------------------------------------
  // WJB01   10/08/18   W.J.BEHR     Changed email to not include Name
  // WJB01   10/08/18   W.J.BEHR     Changed to use 'OAC' email type / not 'INV'
  // WJB01   10/08/18   W.J.BEHR     Only Send PC Message on failure.
  // WJB01   09/11/19   W.J.BEHR     Removed SNDPCMSF|Set default email address|CVT 2 ALL FREE
  // _____   __/__/__
  //
  //--------------------------------------------------------------------

  //?                 Header Specification

  Ctl-Opt   DftActGrp(*NO)
            Option(*NoDebugIO)
            BndDir('*LIBL/KPFUNCTION')
            DatFmt(*Usa);
  /COPY QFunctDefn,@CopyRight

 //?                 Data Specification

  Dcl-Pi WSEMLACKB;  //?Procedure Interface Declaration : *Entry
    POrder#  Packed(6:0);
  End-Pi;

  Dcl-Pr BIC420CLEM  ExtPgm('BIC420CLEM'); //?Procedure Prototype Declaration : Generate PDF
    Order#    Char(6);
    LPlug     Char(1);
    Link      Char(256);
  End-Pr;

  Dcl-Pr SendAckPdf  ExtPgm('SENDACKPDF');  //?Procedure Prototype Declaration : Send Email
    Subject      Char(80);
    SendName     Char(256);
    SendEmail    Char(256);
    RcvName      Char(48);
    RcvEmail     Char(256);
    Order#       Char(6);
    Link         Char(256);
  End-Pr;

  Dcl-Pr  SNDPCMSG   EXTPGM('SNDPCMSG');  //?Procedure Prototype Declaration : Send Message
     PMessage     Char(256);
  End-Pr;

  //?Global Variable Declaration :
  Dcl-S Subject   Char(80);
  Dcl-S SendName  Char(256);
  Dcl-S SendEmail Char(256);
  Dcl-S RcvEmail  Char(256);
  Dcl-S RcvName   Char(48);
  Dcl-S Order#    Char(6);
  Dcl-S Link      Char(256);
  Dcl-S LPlug     Char(1);

  //?Parameter Variable Declaration :
  Dcl-S PMessage  Char(256);

  //?Work Variable Declaration :
  Dcl-S WkCust    Zoned(6:0);
  Dcl-S WkCustC   Char(48);
  Dcl-S WkPO#     Char(15);
  Dcl-S WkEmail   Char(256);
  Dcl-S WkPos     Int(3:0);

  /Include QFunctDefn,$isOrder

  //?                 Calculation Spec

  //? Check Order is Valid
  If $isOrder(POrder#);
    Order# = %Char(POrder#);
    Exsr GetEmail;
  Endif;

  //?  End Program
  //InLR = *On;
  Return;

  //?                GetEmail Subroutine
  Begsr GetEmail;

    //?   Get Bill To Customer from Order Header
    Exec SQL
       Select OHBLCU, OHPONO Into :WkCust, :WkPO# from FHORDR
                       Where OHORD# = :POrder#;

    //?   If PO is Blanks
    If WkPO# = *Blanks;
       WkPO# = '*None';
    Endif;

    //?   Determine if this is a Plug Order
    LPLUG = 'F';
    Exec SQL
       Select 'P' into :LPLUG from PLUG_ORD where PLORD# = :POrder#
       Fetch First Row Only;

    //?   Get Customer Name and Email Address from FMEMAIL
    WkEmail = 'webmaster@kubepak.com';  // Default in case *blank
    Exec SQL
    // Select  EMNAME||EMAIL into :WkEmail from FMEMAIL //*WJB01**
       Select          EMAIL into :WkEmail from FMEMAIL
       Where  EMSTAT = 'A'
          and EMACTT = 'C'
          and EMCODE = 'OAC'
          and EMAIL <> ' '
          and EMACCT = :WkCust;

     // Make Subject statement
     Subject = 'Order Number:' + Order# + '-B2B Acknowledgement.' +
                 'Reference PO#:' + WkPO#;

     // Get Pdf Link
     BIC420CLEM(Order#:LPlug:Link);

     // Send Acknowledgement
     SendName  = 'Kube-Pak Automated Order Acknowledgements' ;
     SendEmail = 'DoNotReply@kubepak.com' ;
     SENDACKPDF(Subject:SendName:SendEmail:WKCustC:WkEmail:
                     Order#:Link);

  Endsr;
