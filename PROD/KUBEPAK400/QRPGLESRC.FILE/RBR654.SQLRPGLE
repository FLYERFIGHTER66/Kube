     H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')

     FRBR654FM  CF   E             WORKSTN
     FRBR654P   O    E             PRINTER OFLIND(OverFlow) USROPN
     FRBLOTRD   UF A E           K DISK    Prefix(rb_)
     FFDLOTRD_S UF A E           K DISK    Rename(RDLOTRD:RDLOTRD_S)
     FFDLOTRD_PTIF   E           K DISK    Rename(RDLOTRD:RDLOTRD_PT)
     FFDLOTRD_NRIF   E           K DISK    Rename(RDLOTRD:RDLOTRD_NR)
     FFDLOTRD_AVIF   E           K DISK    Rename(RDLOTRD:RDLOTRD_AV)
     FFMINVT    IF   E           K DISK

      //  Main procedure prototype & interface
     D RBR654          PI

      *  System Data Structure
     D                SDS
     D $PGM              *PROC

      *  Field Definitions
     D Count           S             15S 5
     D ReturnCode      S              7A
     D FirstPage       S               N   Inz(*On)
     D OverFlow        S               N   Inz(*On)
     D EndOfFile       S               N   Inz(*On)
     D OvrPrtf         S            256A
     D Screen          S              3S 0
     D Authorized      S               N
     D ItemSize        S             10A
     D rb_LRITEMP      S                   like(rb_LRITEM)
     D*rbSTAT          S                   Like(LRSTAT   )
     D*rbITEM          S                   Like(LRITEM   )
     D*rbITEMP         S                   Like(LRITEM   )
     D*rbSIZE          S                   Like(LRSIZE   )
     D*rbSOWD          S                   Like(LRSOWD   )
     D*rbCRDY          S                   Like(LRCRDY   )
     D*rbGLOC          S                   Like(LRGLOC   )
     D*rbCUST          S                   Like(LRCUST   )
     D*rbDESC          S                   Like(LRDESC   )
     D*rbQTAV          S                   Like(LRQTAV   )
     D*rbALPH          S                   Like(LRALPH   )
     D Qty2Move        S                   Like(LRQTAV   )
     D ThisMovQty      S              7S 1
     D ThisFile        S              2A

      *  C1 Data Structure
     D  C1_DS          DS
     D  C1_LRSTAT                          Like(LRSTAT   )
     D  C1_LRITEM                          Like(LRITEM   )
     D  C1_LRSIZE                          Like(LRSIZE   )
     D  C1_LRSOWD                          Like(LRSOWD   )
     D  C1_LRCRDY                          Like(LRCRDY   )
     D  C1_LRGLOC                          Like(LRGLOC   )
     D  C1_LRCUST                          Like(LRCUST   )
     D  C1_LRDESC                          Like(LRDESC   )
     D  C1_LRQTAV                          Like(LRQTAV   )
     D  C1_LRALPH                          Like(LRALPH   )

      *  Function Prototypes
     D/COPY QFunctDefn,$_Dates
     D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$Now

     D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$isPrinter

     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$RtvMsgD
     D/COPY QFunctDefn,QCmdExc

    ?
      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         Exec SQL  Select '1' into :Authorized
                   from RBInvUser where RBIUSR = USER
                   Fetch First Row Only;
         If not Authorized;
           Load01();
           Scrn01();
          Else;
           Load02();
           Scrn02();
         EndIf;

         DoW not *InLr;
           Select;
           When Screen = 1;
             Edit01();
           When Screen = 2;
             Edit02();
           When Screen = 3;
             Edit03();
           EndSl;
         EndDo;

         *InLR = *On;

      /End-Free

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : SubProcedures                                                    :
      // :..................................................................:

           // :'''''''''''': //
           // : Screen 01  : //
           // :............: //

     P Scrn01          B
     D Scrn01          PI
      /Free
         Screen = 1;
         ExFmt RBR65401;
      /End-Free
     P Scrn01          E

     P Load01          B
     D Load01          PI
      /Free
      /End-Free
     P Load01          E

     P Edit01          B
     D Edit01          PI
      /Free
         Select;
         When *In03;
           *InLR = *On;
         Other;
           *InLR = *On;
         EndSL;
      /End-Free
     P Edit01          E

           // :'''''''''''': //
           // : Screen 02  : //
           // :............: //

     P Scrn02          B
     D Scrn02          PI
      /Free
         Screen = 2;
         ExFmt RBR65402;
      /End-Free
     P Scrn02          E

     P Load02          B
     D Load02          PI
      /Free
         If PRINTER = *Blanks;
           PRINTER = $dftprt($User():$PGM:'*PGM');
         ENDIF;
      /End-Free
     P Load02          E

     P Edit02          B
     D Edit02          PI
      /Free
         Select;
         When *In03;
           *InLR = *On;
         When *In11;
           PRINTER = $ChgPrt($User():$PGM:PRINTER);
           Scrn02();
         When *In13;
           AdjInventory();
           Exec SQL Delete from FTRAY_RB;
           Exec SQL Insert into FTRAY_RB (Select * from RB_TRAY);
           *InLr = *On;
         When *In23;
           Load03();
           Scrn03();
         Other;
           Scrn02();
         EndSL;
      /End-Free
     P Edit02          E

           // :'''''''''''': //
           // : Screen 03  : //
           // :............: //

     P Scrn03          B
     D Scrn03          PI
      /Free
         Screen = 3;
         ExFmt RBR65403;
      /End-Free
     P Scrn03          E

     P Load03          B
     D Load03          PI
      /Free
         Usr2Add = *Blanks;
         Usr2Del = *Blanks;
      /End-Free
     P Load03          E

     P Edit03          B
     D Edit03          PI
      /Free
         Select;
         When *In03;
           *InLR = *On;
         When *In12;
           Scrn02();
         Other;
           If Usr2Add <> 'KUBE';
             Exec SQL Insert INTO RBInvUser VALUES(:Usr2Add);
           EndIf;
           Exec SQL DELETE FROM RBINVUSER WHERE RBIUSR = :Usr2Del;
           Load03();
           Scrn03();
         EndSL;
      /End-Free
     P Edit03          E

           // :'''''''''''': //
           // : Adjust Inv : //
           // :............: //

     P AdjInventory    B
     D AdjInventory    PI
      /Free

         Read RBLOTRD;
         DoW not %EOF(RBLOTRD);

           If rb_LRQTAV <> *Zero;

             ItemSize = %Trim(rb_LRITEM) + '-' + %Trim(rb_LRSIZE);
             rbDESC2  = %Subst(rb_LRDESC:1:%Len(rbDESC2));
             rb_LRITEMP  = rb_LRITEM;
             If %SCAN('P':rb_LRITEM) > 0;  // If it has a "P" get rid of it.
               rb_LRITEM   = %REPLACE('' :rb_LRITEM:%SCAN('P':rb_LRITEM):1);
             ENDIF;


             If FirstPage or OverFlow;
               WriteHeader();
             EndIf;

             ProcessDetail();
             rb_LRQADJ = rb_LRQTAV;
             rb_LRQTAV = *Zero;
             rb_LRITEM = rb_LRITEMP;  // TEST 3/16/2017
             Update RDLOTRD;

           EndIf;

           Read RBLOTRD;
         EndDo;

         //CloseDataSet();

         If %Open(RBR654P);
           Close RBR654P;
         EndIf;

      /End-Free
     P AdjInventory    E
      //_____________________________________________________________________
      //
     P ProcessDetail   B
     D ProcessDetail   PI
      /Free
         Qty2Move = rb_LRQTAV;
         Select;
         When Qty2Move > 0;
           RmvRBInventory();
         When Qty2Move < 0;
           ThisMovQty = %Abs(Qty2Move);
           Qty2Move   = %Abs(Qty2Move);
           DoW Qty2Move <> *Zero and ThisMovQty <> *Zero;
             AddRBInventory();
           EndDo;
         Other;
             // Do Nothing
         EndSl;
         Qty2Move *= -1;
      /End-Free
     P ProcessDetail   E
      //_____________________________________________________________________
      //
     P RmvRBInventory  B
     D RmvRBInventory  PI
      /Free
        // Move the unavailable quantity from 'R' location to 'N' Location.
         Chain (rb_LRITEM:rb_LRSIZE:rb_LRCRDY:rb_LRSOWD:rb_LRGLOC:rb_LRCUST)
           FDLOTRD_S;
         If %Found(FDLOTRD_S);
           LRQTOH -= Qty2Move;
           LRQTAV -= Qty2Move;
           LRDTLA  = $MDYDate($Date(0));
           LRTIME  = $Now();
           LRUSER  = 'RBR654r1';
           Update RDLOTRD_S;
           ThisMovQty = Qty2Move;
           rbDESC2  = 'Inv reclass: R -> N';
           Write Detail;

           Chain (rb_LRITEM:rb_LRSIZE:rb_LRCRDY:rb_LRSOWD:'N  ':rb_LRCUST)
             FDLOTRD_S;
           LRDTLA  = $MDYDate($Date(0));
           LRTIME  = $Now();
           LRUSER  = 'RBR654n1';
           If %Found(FDLOTRD_S);
             LRQTOH += Qty2Move;
             LRQTAV += Qty2Move;
             Update RDLOTRD_S;
            Else;
             LRGLOC  = 'N  ';
             LRQTOH  = Qty2Move;
             LRQTAV  = Qty2Move;
             Write RDLOTRD_S;
           EndIf;
         EndIf;
         Qty2Move = *Zero;

      /End-Free
     P RmvRBInventory  E
      //_____________________________________________________________________
      //
     P AddRBInventory  B
     D AddRBInventory  PI
      /Free
         // Now check Available Inventory and convert it to RB.
         ThisMovQty = *Zero;
         If rb_LRITEMP <> rb_LRITEM;
           Chain (rb_LRITEM:rb_LRSIZE:rb_LRCRDY:rb_LRSOWD:'   ') FDLOTRD_PT;
           If not %Found(FDLOTRD_PT);
             Chain (rb_LRITEM:rb_LRSIZE:rb_LRCRDY:rb_LRSOWD:'S  ') FDLOTRD_PT;
             If not %Found(FDLOTRD_PT);
               Chain (rb_LRITEM:rb_LRSIZE:rb_LRCRDY:rb_LRSOWD:'N  ') FDLOTRD_PT;
               If not %Found(FDLOTRD_PT);
                 // Write Inventory Not Found record on the report.
                 rbDESC2  = 'Inventory not found -Part';
                 ThisMovQty = Qty2Move;
                 Write Strike;
                 Write Detail;
                 CreateNewInv();
                 ThisMovQty = *Zero;
                 Return;
               EndIf;
             EndIf;
           EndIf;
          Else;   // i.e. not a Partial => any customer
           Chain (rb_LRITEM:rb_LRSIZE:rb_LRCRDY:rb_LRSOWD:rb_LRCUST) FDLOTRD_NR;
           If not %Found(FDLOTRD_NR) or %Found(FDLOTRD_NR) and LRCUST > 999990;
             Chain (rb_LRITEM:rb_LRSIZE:rb_LRCRDY:rb_LRSOWD:'   ') FDLOTRD_AV;
             If not %Found(FDLOTRD_AV);
               Chain (rb_LRITEM:rb_LRSIZE:rb_LRCRDY:rb_LRSOWD:'S  ') FDLOTRD_AV;
               If not %Found(FDLOTRD_AV);
                 Chain (rb_LRITEM:rb_LRSIZE:rb_LRCRDY:rb_LRSOWD:'N  ')
                   FDLOTRD_AV;
                 If not %Found(FDLOTRD_AV);
                   // Write Inventory Not Found record on the report.
                   rbDESC2  = 'Inventory not found -Full';
                   ThisMovQty = Qty2Move;
                   Write Strike;
                   Write Detail;
                   CreateNewInv();
                   ThisMovQty = *Zero;
                   Return;
                 EndIf;
               EndIf;
             EndIf;
           EndIf;
         EndIf;

         // If we get here, we got a hit on one of the files.
         // Now use the Key Fields from the record we found to chain to the record we will change


         Chain (LRITEM:LRSIZE:LRCRDY:LRSOWD:LRGLOC:LRCUST) FDLOTRD_S;

         If LRQTAV <= Qty2Move;
           ThisMovQty = LRQTAV;
          Else;
           ThisMovQty = Qty2Move;
         EndIf;

         // Deduct Quantity to Move from Source Location
         LRQTOH -= ThisMovQty;
         LRQTAV -= ThisMovQty;
         LRDTLA  = $MDYDate($Date(0));
         LRTIME  = $Now();
         LRUSER  = 'RBR654add1';

         // Update the appropriate Source File.
             Update RDLOTRD_S;

         // Write reclass record on the report.
         rbDESC2  = 'Inv reclass: ' + %Trim(LRGLOC) + ' -> R';
         Write Detail;

         // Write/Update the Ready Bay Inventory Record
         Chain (LRITEM:LRSIZE:LRCRDY:LRSOWD:'R  ':LRCUST) FDLOTRD_S;
         LRDTLA  = $MDYDate($Date(0));
         LRTIME  = $Now();
         LRUSER  = 'RBR654add2';
         If %Found(FDLOTRD_S);
           LRQTOH += ThisMovQty;
           LRQTAV += ThisMovQty;
           Update RDLOTRD_S;
          Else;
           LRGLOC  = 'R  ';
           LRQTOH  = ThisMovQty;
           LRQTAV  = ThisMovQty;
           Write  RDLOTRD_S;
         EndIf;
         Qty2Move -= ThisMovQty;
      /End-Free
     P AddRBInventory  E
      //_____________________________________________________________________
      //
     P CreateNewInv    B
     D CreateNewInv    PI
      /Free
       dcl-s Customer like(rb_LRCUST);

       //  If rb_LRCUST <> 999997;
       //    Eval rb_LRCust = 0;
       //  EndIf;

         If rb_LRCUST <> 999997;
           Eval Customer = 0;
          Else;
           Eval Customer = rb_LRCUST;
         ENDIF;


         Chain (rb_LRITEM:rb_LRSIZE:rb_LRCRDY:rb_LRSOWD:rb_LRGLOC:rb_LRCUST)
           FDLOTRD_S;

         LRDTLA  = $MDYDate($Date(0));
         LRTIME  = $Now();
         LRUSER  = 'RBR654_NEW';
         If %Found(FDLOTRD_S);
           LRQTOH += Qty2Move;
           LRQTAV += Qty2Move;
           Update RDLOTRD_S;
          Else;
           Chain (rb_LRITEM:rb_LRSIZE) FMINVT;
           LRSTAT = rb_LRSTAT;
           LRITEM = rb_LRITEM;
           LRSIZE = rb_LRSIZE;
           LRSOWD = rb_LRSOWD;
           LRCRDY = rb_LRCRDY;
           LRGLOC = rb_LRGLOC;
           LRCUST = rb_LRCUST;
           LRQTAV = rb_LRQTAV;
           LRALPH = IMLOOK;
           LRDESC = IMDES1;
           LRQTOH = Qty2Move;
           LRQTAV = Qty2Move;
           LRQTAL = 0;
           Write RDLOTRD_S;
         EndIf;

         Qty2Move -= ThisMovQty;

         rbDESC2  = 'Created New Inventory !!!';
         Write Detail;

      /End-Free
     P CreateNewInv    E
      //_____________________________________________________________________
      //
     P WriteHeader     B
     D WriteHeader     PI
      /Free
         If not %Open(RBR654P);
           OVRPRTF = 'OVRPRTF FILE(RBR654P)' +
                            ' FORMTYPE(*NAR)' +
                            ' OUTQ(' + %Trim(Printer) + ')' +
                            ' CPI(10) ' +
                            ' PAGRTT(0)' +
                            ' PAGESIZE(66 80)' +
                            ' OPNSCOPE(*JOB)';
           QCmdExc(OVRPRTF : %len(%trim(OVRPRTF)));
           Open RBR654P;
         EndIf;
         FirstPage = *Off;
         OverFlow  = *Off;
         Write Header;
      /End-Free
     P WriteHeader     E
      //_____________________________________________________________________
      //
