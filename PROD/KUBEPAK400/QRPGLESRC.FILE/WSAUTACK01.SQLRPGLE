      *? Program        : WSAUTOACK01
      *?
      *? Description    : This program to send Auto Acknowledgment XML
      *?                  for Changeed Orders, taking Order numbers from
      *?                  file AUTOACKPF
      *? Created By     : Vimala V
      *?
      *? Date           : 8 Jan 2018
      //--------------------------------------------------------------------
      *? Special Notes  : ** Takes Changed Orders from file AUTOACKPF
      *?                : ** Check if its a B2B Order and is Active in FHORDR
      *?                : ** Call Post Acknowledgement program for Change Orders
      *?                     for all Brokers and Michell
      *
      *? Called Program : WSCOPSTACK - WS - POST Acknowledgment for CHANGE Order
      *?                  WSPSTACKMC - WS - Post Acknowledgment Process for Michell PO&CO
      *
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO)
           ActGrp ('HTTP') BndDir('QC2LE');
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: AUTOACKPF:AUTO_ACKNOWLEDGE_CHANGED_ORDERS
      *?Key : Order #
        Dcl-F AUTOACKPF Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Order Header Record
      *?Key : Order Number
        Dcl-F FHORDR Disk(*Ext) Keyed Usage(*Input);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSAUTACK01;
        End-Pi;
      *
      *?Procedure Prototype Declaration : Order Acknowledgement
        Dcl-Pr WSORDERACK ExtPgm;
           POrderNo     Packed(6) Const;
           HttpStatus   Int(10:0);
        End-Pr;

      *?Procedure Prototype Declaration : CO Post Acknowledgement Program
        Dcl-Pr WSCOPSTACK Extpgm;
           PFromOrgId   Like(PFromOrgId);
           PBrokOrId    Like(PBrokOrId);
           POrderNo     Packed(6);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Michell Post Acknowledgement Program
        Dcl-Pr WSPSTACKMC Extpgm;
           PFromOrgId   Like(PFromOrgId);
           PBrokOrId    Like(PBrokOrId);
           POrderNo     Packed(6);
        End-Pr;
      *
      *?Work Variable Declaration :
        Dcl-S PFromOrgId   Char(30) Inz;
        Dcl-S PBrokOrId    Char(10) Inz;
        Dcl-S POrderNo     Packed(6);
        Dcl-S HttpStatus   Int(10:0);
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

           Exsr Main;
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : Main Subroutine :
      *?                :-----------------:
      *
        Begsr Main;

      *?   // Read AUTOACKPF file for each Order
           Setll *Loval AUTOACKPF;
           Read AUTOACKPF;
           Dow Not %Eof;


      *?      // Clear Parameters
              PFromOrgId = *Blanks;
              PBrokOrId  = *Blanks;
              OHORD# = *Zeros;

      *?      // Check if Order is a B2B Order
              Exec SQL
                 Select PHFRORID,PHBRKORID Into :PFromOrgId, :PBrokOrId
                 From WSPOHDRPF
                 Where  PHFLAG = 'P' and PHORDNO = :AAORD#
                 Fetch First Row Only;

      *?      // If Order found
              If SqlCode = 0;
                 If PFromOrgID <> *Blanks and PBrokOrID <> *Blanks;

      *?            // Check if the Order is Active in FHORDR
                    Chain (AAORD#) FHORDR;
                    If %Found and OHSTAT = 'A';
                       POrderNo = OHORD#;

      *?               // Call Post Acknowledgment Program to send Acknowledgment
                    // WSCOPSTACK(PFromOrgId:PBrokOrId:POrderNo);
                       WSORDERACK(POrderNo:HttpStatus);

      *?               // Call Post Acknowledgment Program for Michell
                       If PFromOrgId = 'Michell';
                          WSPSTACKMC(PFromOrgId:PBrokOrId:POrderNo);
                       Endif;
                    Endif;
                 Endif;
              Endif;
              Exec SQL Delete from AUTOACKPF
                       where ORDER_NUMBER = :ORDER_NUMBER;
              Read AUTOACKPF;
           Enddo;

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
