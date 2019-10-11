      *? Program        : WSORDERACK
      *?
      *? Description    : Common program to Generate Acknowledgement XML &
      *?                  POST to Client Site for both Create and Change Order
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 30 Nov 2017
      //--------------------------------------------------------------------
      *? Special Notes  : *Entry Parameters
      *?                : Order Number (6P)
      *?                : Httpstatus   (10I) - Output Parameter
      *?
      *? Called Program : WSPOPSTACK - To Generate & POST Acknowledgement XML
      *?                               for Create Order
      *?                  WSCOPSTACK - To Generate & POST Acknowledgement XML
      *?                               for Change Order
SUD01 *?                  WSPSTACKMC - To Generate & POST Acknowledgement XML
      *?                               for Michell Create & Change Order
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * WJB01   02/28/18   W.J.Behr     Added logic to ADDLIBLE LIBHTTP
      * SUD01   05/04/18   S.Uthaya     Added New Brokers for Phase II Changes
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt Pgminfo(*Pcml:*Module) DftActGrp(*NO) Option(*NoDebugIO)
           ActGrp ('HTTP') BndDir('QC2LE');
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSORDERACK ExtPgm;
           POrderNo     Packed(6);
           HttpStatus   Int(10:0);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Call Pgm to POST Order Create XML
        Dcl-Pr WSPOPSTACK ExtPgm;
           PFromOrgID   Like(PFromOrgID);
           PBrokOrID    Like(PBrokOrID);
           POrderNo     Packed(6);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Call Pgm to POST Order Change XML
        Dcl-Pr WSCOPSTACK ExtPgm;
           PFromOrgID   Like(PFromOrgID);
           PBrokOrID    Like(PBrokOrID);
           POrderNo     Packed(6);
        End-Pr;
      *
SUD01 *?Procedure Prototype Declaration : Call Pgm to POST Michell PO & CO XML
  |     Dcl-Pr WSPSTACKMC ExtPgm;
  |        PFromOrgID   Like(PFromOrgID);
  |        PBrokOrID    Like(PBrokOrID);
  |        POrderNo     Packed(6);
  |     End-Pr;
SUD01 *
      *?Parameter Variable Declaration :
        Dcl-S PFromOrgID  Char(30) Inz;
        Dcl-S PBrokOrID   Char(10) Inz;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

           Exsr InzPgm;
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Initialise Subroutine :
      *?                :-----------------------:
      *
        Begsr InzPgm;

      *?   // Clear Parameters
           PFromOrgID = *Blanks;
           PBrokOrID  = *Blanks;

      *?   // Add HTTP Library in Library List                                  WJB01
           Monitor;
             Exec SQL
               CALL QSYS2/QCMDEXC(
                 'ADDLIBLE LIB(LIBHTTP) POSITION(*Last)'
               );
           On-Error;
           EndMon;

      *?   // Execute Process
           Exsr Process;

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
      *?                : Process Subroutine :
      *?                :--------------------:
      *
      *?Logic : Check record exists in Change Order file , If not found
      *?        Check record exists in Order Create file
      *?        and the process flag should be 'C'/'P'
      *?      : Based on File call the Acknowledgement program
      *
        Begsr Process;

      *?   // First check record exist in Change Order XML file
           Exec SQL
              Select CHFRORID,CHBRKORID Into :PFromOrgID, :PBrokOrID
              from WSCOHDRPF
              Where (CHFLAG='C' or CHFLAG='P') And CHORDNO = :POrderNo
              Fetch first row only;

      *?   // If Order found
           If SqlCode = 0;
              If PFromOrgID <> *Blanks and PBrokOrID <> *Blanks;

SUD01            If PFromOrgID = 'Michell';                     // Michell POST Program
  |                 WSPSTACKMC(PFromOrgId:PBrokOrId:POrderNo);
  |              Else;
SUD01
      *?            // Order found in Change order file, Call POST program
                    WSCOPSTACK(PFromOrgId:PBrokOrId:POrderNo);
SUD01            Endif;
                 Httpstatus = 0;
              Else;
                 Httpstatus = 400;
              Endif;
           Else ;

      *?      // Check if record exist in Order Create XML file
              Exec SQL
                 Select PHFRORID,PHBRKORID Into :PFromOrgID,
                    :PBrokOrID  from WSPOHDRPF
                Where (PHFLAG='C' or PHFLAG='P') And PHORDNO = :POrderNo;

      *?      // If Order not Found Send Error Status
              If PFromOrgID = *Blanks and PBrokOrID = *Blanks;
                 Httpstatus = 400;
              Else;
SUD01                                                                // Michell POST Program
  |              If PFromOrgID = 'Michell';
  |                 WSPSTACKMC(PFromOrgId:PBrokOrId:POrderNo);
SUD01            Else;

      *?            // Order found in Create order file, Call POST program
                    WSPOPSTACK(PFromOrgId:PBrokOrId:POrderNo);
SUD01            Endif;
                 Httpstatus = 0;
              Endif;
           Endif;

        EndSr;
