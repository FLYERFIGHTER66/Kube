     H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')

     FFHORDR    IF   E           K DISK
     FFIORDR    UF A E           K DISK
     FFIORDRSVIAUF A E           K DISK    Rename(RIORDR:SV_RIORDR)
     F                                     Prefix(SV_)
     FFIORDRPO# UF A E           K DISK    Rename(RIORDR:PO_RIORDR)
     F                                     Prefix(PO_)
     FFIORDRRB  UF A E           K DISK    Rename(RIORDR:RB_RIORDR)
     F                                     Prefix(RB_)
     FFIORDRCSTMUF A E           K DISK    Rename(RIORDR:CU_RIORDR)
     F                                     Prefix(CU_)
     FFHORDRCSTMIF   E           K DISK
     FFMSVIA    IF   E           K DISK

       // Function Prototypes
     D/COPY QFunctDefn,$Now
     D/COPY QFunctDefn,$Date
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$MDYDate
     D/COPY QFunctDefn,$InsertLn

       // Field Definitions
     D  Order#         S                   Like(OHORD#)
     D  K_Seq#         S                   Like(SV_OISEQ#)
     D  Lines          S                   Like(OISEQ#) Inz(1)
     D  SV_Desc        S                   Like(OIDES1)
     D  PO_Desc        S                   Like(OIDES1)
     D  CU_Desc        S                   Like(OIDES1)
     D  RB_Desc        S                   Like(OIDES1)

     C     *Entry        PList
     C                   Parm                    Order#

     C     OrderKey      KList
     C                   KFld                    Order#
     C                   KFld                    K_Seq#

      /FREE

       //  Check to see if the Order is open.  If not bail out.
       Chain Order# FHORDR;
       if not %found(FHORDR) or OHSTAT <> 'A' or OHCOFL = 'Y' or OHHOLD = 'R';
         Return;
       ENDIF;

       Process_SV(); // Process Ship Via Comment ("Ship ____________")
       Process_PO(); // Process Purchase Order Comment ("PO#:_________")
       Process_RB(); // Process RB Comment ("Following Off READY LIST")
       Process_CU(); // Process Custom Comment ("C U S T O M   O R D E R")

       //  OK, Our work here is done.
       *INLR = *ON;
       return;


       //-----------------------------------------------------------------------
       dcl-proc Process_SV;
       //-----------------------------------------------------------------------

       //  Check if Ship Via Entry Exists
       Chain Order# FIORDRSVIA;
       If %Found(FIORDRSVIA) and SV_OISEQ#<>3 or not %Found(FIORDRSVIA);
         ExSr FixSVSeq#;
       EndIf;

              //  Build Ship Via description.
       SV_Desc = *Blanks;
       Chain OHSHPC FMSVIA;
           SV_Desc = %SubSt( ' ' +
                    %SubSt(%EditC(OHDTCN:'Y'):1:5) +
                    ' Ship ' +  SVDESC:1:30);

       //  Write/Update Ship Via Record
           SV_OISHPC = OHSHPC;                              //SHIP VIA CODE
           SV_OIDES1 = SV_Desc;                             //COMMENT
           SV_OIDTRQ = OHDTRQ;                              //REQ SHIP DATE MDY
           SV_OIRVDT = OHDTRY;                              //REQ SHIP DATE CYMD
           SV_OIDTLA = $MDYDate($Date(0));                  //LAST ACTIVITY DATE
           SV_OITIME = $Now();                              //TIME
           SV_OIUSER = $User();                             //USER
           SV_OIITEM = 'SVIA';                              //ITEM
           SV_OISIZE = '   ';                               //SIZE
           SV_OIITMA = ' Auto Comment';                     //ITEM ALPHA SEARCH
           SV_OISTAT = 'A';                                 //STATUS
           SV_OIORD# = OHORD#;                              //ORDER NUMBER
           SV_OISEQ# = 3;                                   //SEQ NUMBER
           SV_OICOMP = 1;                                   //COMPANY #
           SV_OISHCD = 'N';                                 //SHIP RELEASE CODE
           SV_OIOVER = '5';                                 //OVERRIDE CODE
           SV_OIBOCD = 'Y';                                 //ITEM B/O ALLOWED
           SV_OISLM1 = '01';                                //SALESPERSON 1
           SV_OICUST = OHCUST;                              //CUSTOMER #
           SV_OIITYP = 'C';                                 //ITEM TYPE
           SV_OITXCD = 'N';                                 //TAX ITEM CODE 1
           SV_OITXST = 'N';                                 //TAX ITEM CODE 2
           SV_OITXCT = 'N';                                 //TAX ITEM CODE 3
           SV_OITXLC = 'N';                                 //TAX ITEM CODE 4
           SV_OIMUL2 = 1;                                   //MULT 2
           SV_OILOTC = 'N';                                 //LOT CONTROL
           SV_OISTA  = 'N';                                 //SUBJ TO AVAIL FLAG
           SV_OIALPH = OHALPH;

         If not %Found(FIORDRSVIA);
           Write SV_RIORDR;
         Else;
           Update SV_RIORDR;
         ENDIF;

         BegSr FixSVSeq#;
           Unlock FIORDRSVIA;
           K_Seq# = 3;
           Chain(n) OrderKey FIORDR;
           if %Found(FIORDR);
             $InsertLn(OHORD#:K_Seq#:Lines);
           EndIf;
           If %Found(FIORDRSVIA);
             Chain Order# FIORDRSVIA;
             SV_OISEQ# = 3;
             Update SV_RIORDR;
             Chain Order# FIORDRSVIA;
           EndIf;
         EndSr;

       END-PROC;


       //-----------------------------------------------------------------------
       dcl-proc Process_PO;
       //-----------------------------------------------------------------------

      //  Check if PO# Entry Exist
       Chain Order# FIORDRPO#;
       If %Found(FIORDRPO#) and PO_OISEQ#<>5 or not %Found(FIORDRPO#);
         ExSr FixPOSeq#;
       EndIf;

       //  Build PO# description.
       PO_Desc = *Blanks;
       If OHPONO = *Blanks;
           PO_Desc = ' PO#: _______________';
       Else;
           PO_Desc = ' PO#: ' + %Trim(OHPONO);
       EndIf;

       //  Write/Update PO# Record
           PO_OISHPC = OHSHPC;                              //SHIP VIA CODE
           PO_OIDES1 = PO_Desc;                             //COMMENT
           PO_OIDTRQ = OHDTRQ;                              //REQ SHIP DATE MDY
           PO_OIRVDT = OHDTRY;                              //REQ SHIP DATE CYMD
           PO_OIDTLA = $MDYDate($Date(0));                  //LAST ACTIVITY DATE
           PO_OITIME = $Now();                              //TIME
           PO_OIUSER = $User();                             //USER
           PO_OIITEM = 'PO# ';                              //ITEM
           PO_OISIZE = '   ';                               //SIZE
           PO_OIITMA = ' Auto Comment';                     //ITEM ALPHA SEARCH
           PO_OISTAT = 'A';                                 //STATUS
           PO_OIORD# = OHORD#;                              //ORDER NUMBER
           PO_OISEQ# = 5;                                   //SEQ NUMBER
           PO_OICOMP = 1;                                   //COMPANY #
           PO_OISHCD = 'N';                                 //SHIP RELEASE CODE
           PO_OIOVER = '5';                                 //OVERRIDE CODE
           PO_OIBOCD = 'Y';                                 //ITEM B/O ALLOWED
           PO_OISLM1 = '01';                                //SALESPERSON 1
           PO_OICUST = OHCUST;                              //CUSTOMER #
           PO_OIITYP = 'C';                                 //ITEM TYPE
           PO_OITXCD = 'N';                                 //TAX ITEM CODE 1
           PO_OITXST = 'N';                                 //TAX ITEM CODE 2
           PO_OITXCT = 'N';                                 //TAX ITEM CODE 3
           PO_OITXLC = 'N';                                 //TAX ITEM CODE 4
           PO_OIMUL2 = 1;                                   //MULT 2
           PO_OILOTC = 'N';                                 //LOT CONTROL
           PO_OISTA  = 'N';                                 //SUBJ TO AVAIL FLAG
           PO_OIALPH = OHALPH;

         If not %Found(FIORDRPO#);
           Write PO_RIORDR;
         Else;
           Update PO_RIORDR;
         ENDIF;

         BegSr FixPOSeq#;
           Unlock FIORDRPO#;
           K_Seq# = 5;
           Chain(n) OrderKey FIORDR;
           if %Found(FIORDR);
            $InsertLn(OHORD#:K_Seq#:Lines);
           EndIf;
           If %Found(FIORDRPO#);
             Chain Order# FIORDRPO#;
             PO_OISEQ# = 5;
             Update PO_RIORDR;
             Chain Order# FIORDRPO#;
           EndIf;
         EndSr;

       END-PROC;



       //-----------------------------------------------------------------------
       dcl-proc Process_RB;
       //-----------------------------------------------------------------------

       Chain Order# FIORDRRB;

       //  Check if Order is Ready Bay
       If not RB_SVIA(OHSHPC);
         If %Found(FIORDRRB);
           Delete RB_RIORDR;
         EndIf;
         return;
        else;
         // If this is a Ready Bay Ship Via...

         If %Found(FIORDRRB) and RB_OISEQ#<>6  or not %Found(FIORDRRB);
             ExSr FixRBSeq#;
         EndIf;

         //  Build PO# description.
         RB_Desc = ' FOLLOWING OFF READY LIST';

         //  Write/Update PO# Record
         RB_OISHPC = OHSHPC;                              //SHIP VIA CODE
         RB_OIDES1 = RB_Desc;                             //COMMENT
         RB_OIDTRQ = OHDTRQ;                              //REQ SHIP DATE MDY
         RB_OIRVDT = OHDTRY;                              //REQ SHIP DATE CYMD
         RB_OIDTLA = $MDYDate($Date(0));                  //LAST ACTIVITY DATE
         RB_OITIME = $Now();                              //TIME
         RB_OIUSER = $User();                             //USER
         RB_OIITEM = 'RB';                                //ITEM
         RB_OISIZE = '   ';                               //SIZE
         RB_OIITMA = ' Auto Comment';                     //ITEM ALPHA SEARCH
         RB_OISTAT = 'A';                                 //STATUS
         RB_OIORD# = OHORD#;                              //ORDER NUMBER
         RB_OISEQ# = 6;                                   //SEQ NUMBER
         RB_OICOMP = 1;                                   //COMPANY #
         RB_OISHCD = 'N';                                 //SHIP RELEASE CODE
         RB_OIOVER = '5';                                 //OVERRIDE CODE
         RB_OIBOCD = 'Y';                                 //ITEM B/O ALLOWED
         RB_OISLM1 = '01';                                //SALESPERSON 1
         RB_OICUST = OHCUST;                              //CUSTOMER #
         RB_OIITYP = 'C';                                 //ITEM TYPE
         RB_OITXCD = 'N';                                 //TAX ITEM CODE 1
         RB_OITXST = 'N';                                 //TAX ITEM CODE 2
         RB_OITXCT = 'N';                                 //TAX ITEM CODE 3
         RB_OITXLC = 'N';                                 //TAX ITEM CODE 4
         RB_OIMUL2 = 1;                                   //MULT 2
         RB_OILOTC = 'N';                                 //LOT CONTROL
         RB_OISTA  = 'N';                                 //SUBJ TO AVAIL FLAG
         RB_OIALPH = OHALPH;

         If not %Found(FIORDRRB);
           Write RB_RIORDR;
          Else;
           Update RB_RIORDR;
         EndIf;
       EndIf;

         BegSr FixRBSeq#;
           Unlock FIORDRRB;
           Chain(n) (Order#:6) FIORDR;
           if %Found(FIORDR);
            $InsertLn(OHORD#:6:Lines);
           EndIf;
           If %Found(FIORDRRB);
             Chain Order# FIORDRRB;
             RB_OISEQ# = 6;
             Update RB_RIORDR;
             Chain Order# FIORDRRB;
           EndIf;
         EndSr;

       END-PROC;


       //-----------------------------------------------------------------------
       dcl-proc Process_CU;
       //-----------------------------------------------------------------------

       //  Check if Custom Order Entry Exist
       Chain Order# FIORDRCSTM;
       Chain Order# FHORDRCSTM;
       If (%Found(FIORDRCSTM) and CU_OISEQ#<>7) or
          (not %Found(FIORDRCSTM) and %Found(FHORDRCSTM));
         ExSr FixCUSeq#;
       EndIf;

       //  Build PO# description.
       CU_Desc = ' C U S T O M   O R D E R';

       //  Write/Update PO# Record
           CU_OISHPC = OHSHPC;                              //SHIP VIA CODE
           CU_OIDES1 = CU_Desc;                             //COMMENT
           CU_OIDTRQ = OHDTRQ;                              //REQ SHIP DATE MDY
           CU_OIRVDT = OHDTRY;                              //REQ SHIP DATE CYMD
           CU_OIDTLA = $MDYDate($Date(0));                  //LAST ACTIVITY DATE
           CU_OITIME = $Now();                              //TIME
           CU_OIUSER = $User();                             //USER
           CU_OIITEM = 'CSTM';                              //ITEM
           CU_OISIZE = '   ';                               //SIZE
           CU_OIITMA = ' Auto Comment';                     //ITEM ALPHA SEARCH
           CU_OISTAT = 'A';                                 //STATUS
           CU_OIORD# = OHORD#;                              //ORDER NUMBER
           CU_OISEQ# = 7;                                   //SEQ NUMBER
           CU_OICOMP = 1;                                   //COMPANY #
           CU_OISHCD = 'N';                                 //SHIP RELEASE CODE
           CU_OIOVER = '5';                                 //OVERRIDE CODE
           CU_OIBOCD = 'Y';                                 //ITEM B/O ALLOWED
           CU_OISLM1 = '01';                                //SALESPERSON 1
           CU_OICUST = OHCUST;                              //CUSTOMER #
           CU_OIITYP = 'C';                                 //ITEM TYPE
           CU_OITXCD = 'N';                                 //TAX ITEM CODE 1
           CU_OITXST = 'N';                                 //TAX ITEM CODE 2
           CU_OITXCT = 'N';                                 //TAX ITEM CODE 3
           CU_OITXLC = 'N';                                 //TAX ITEM CODE 4
           CU_OIMUL2 = 1;                                   //MULT 2
           CU_OILOTC = 'N';                                 //LOT CONTROL
           CU_OISTA  = 'N';                                 //SUBJ TO AVAIL FLAG
           CU_OIALPH = OHALPH;

         If %Found(FHORDRCSTM);
           If not %Found(FIORDRCSTM);
             Write CU_RIORDR;
           Else;
             Update CU_RIORDR;
           EndIf;
         Else;
           If %Found(FIORDRCSTM);
             Delete CU_RIORDR;
           EndIf;
         EndIf;

         BegSr FixCUSeq#;
           Unlock FIORDRCSTM;
           K_Seq# = 7;
           Chain(n) OrderKey FIORDR;
           if %Found(FIORDR);
            $InsertLn(OHORD#:K_Seq#:Lines);
           EndIf;
           If %Found(FIORDRCSTM);
             Chain Order# FIORDRCSTM;
             PO_OISEQ# = 7;
             Update CU_RIORDR;
             Chain Order# FIORDRCSTM;
           EndIf;
         EndSr;

       END-PROC;

       //-----------------------------------------------------------------------
       Dcl-Proc RB_SVIA;
       //-----------------------------------------------------------------------
         dcl-pi *n ind;
           SVIA_Code char(3) const;
         END-PI;
         dcl-s isRB ind inz(*off);
         Exec SQL
           Select  '1'
           into    :isRB
           from    FRBSVIA
           where   ReadyBayShipViaCode = :SVIA_Code;
         return isRB;
       END-PROC;


      /END-FREE

