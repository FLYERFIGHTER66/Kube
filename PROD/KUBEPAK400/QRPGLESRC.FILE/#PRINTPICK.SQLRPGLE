     H BndDir('*LIBL/KPFUNCTION')
     H DftActGrp(*No)

      //??:````````````````````````````````````````````````````````````:?
      //??:                  Print Specific Pick Slip                  :?
      //??:............................................................:?
      //? :````````````````````````````````````````````````````````````:
      //? : Created:  April 2004           ? Kube-Pak Corporation ?    :
      //? :      by:  William J. Behr                                  :
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :   Program Description                                     ?:
      //? : ```````````````````````                                   ?:
      //? :                                                           ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Subroutine Usage                                        ?:
      //? :                                                           ?:
      //? :  Scrn01   -?Display Screen 01                             ?:
      //? :  Edit01   -?EDIT Screen 01                                ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Function Usage                                          ?:
      //? :                                                           ?:
      //? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Indicator Usage                                           ?:
      //? :                                                            ?:
      //? :  01 - 24 ?Return Screen Functions                           ?:
      //? :  12      ?Cancel                                            ?:
      //? :  40      Finished Order Indicator                          ?:
      //? :  50      ?Error Indicator (All Errors)                      ?:
      //? :  51      ?Error Indicator (Bad Printer 1)                   ?:
      //? :  52      ?Error Indicator (Bad Printer 2)                   ?:
      //? :  53      ?Error Indicator (Bad "SAVE1")                     ?:
      //? :  54      ?Error Indicator (Bad "SAVE2")                     ?:
      //? :  LR      ?Does this really need a description ?             ?:
      //? :............................................................:
     F#PrintPickCF   E             WORKSTN

     D                 DS
     D  copies1
     D  copies1#                      2S 0 overlay(copies1) Inz(2)              changed per Rob Jr.

     D                 DS
     D  copies2
     D  copies2#                      2S 0 overlay(copies2) Inz(1)              changed per Rob Jr.

     D  Screen         S              2S 0 Inz(0)
     D  CSRFLD         S             10A   Inz

     D pIn             S               *   Inz(%Addr(*In))
     D indicatorArray  DS                  Based(pIn)
     D  IN40                           N   Overlay(indicatorArray:40)
     D  IN99                           N   Overlay(indicatorArray:99)

      //? Function Prototypes
    ?D/COPY QFunctDefn,$isPrinter
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,$ChgPrt
    ?D/COPY QFunctDefn,$User

    ?D/COPY QFunctDefn,$PrintPick
     D PRTFINDKP       PR                  ExtPgm('PCK010CLO')
     D     #Order                     6P 0      const                            Order Number
     D     #Printer                  10A        const                            Printer to Use
     D     #Copies                    3A        const                            Number of Copies
     D     #Save                      1A        const                            Save Spool
     D PRTFINTRP       PR                  ExtPgm('PCK900CLO')
     D     #Order                     6P 0      const                            Order Number
     D     #Printer                  10A        const                            Printer to Use
     D     #Copies                    3A        const                            Number of Copies
     D     #Save                      1A        const                            Save Spool

     C     *Entry        PList
     C                   Parm                    #Order            6 0

      /FREE

       DOU *INLR = *ON;

         SELECT;
         WHEN Screen = 1;
           ExSr Edit01;
         Other;
           // Initialize
           *In40 = *Off;
           Exec SQL Select '1' Into :In40 from FIN_ORD where PLORD# = :#Order
             Fetch First Row Only;
           If *In40;
             FINTYPE = 'T';
             PRINTER1=$DftPrt($User():'*NONE':'*USER');
             PRINTER2=*Blanks;
             copies1# = 1;
           Else;
             FINTYPE = ' ';
             PRINTER1=$DftPrt('*NONE':'#PRTPICK01':'*PGM');
             PRINTER2=$DftPrt('*NONE':'#PRTPICK02':'*PGM');
           ENDIF;
           Save1 = 'N';
           Save2 = 'N';
           ExSr SCRN01;
         ENDSL;                                                               //?

       EndDo;                                                                 //?

       //?  ...........................................................
       //?  :      Edit01 - Edit Screen 01                            :
       //?  :.........................................................:
    ?  BegSr Edit01;                                                          //?

         *In50 = *Off;                                                        //?
         If *In12 = *On;
           *InLR = *On;
           Return;
         EndIf;

         If *In13 and (
               CSRFLD = 'PRINTER1'
               or CSRFLD = 'SAVE1'     );
           Printer1 =
               $CHGPRT('*NONE':'#PRTPICK01':'*PGM');
           *In50 = *On;
           ExSr Scrn01;
         EndIf;

         If *In13 and (
               CSRFLD = 'PRINTER2'
               or CSRFLD = 'SAVE2'     );
           Printer2 =
               $CHGPRT('*NONE':'#PRTPICK02':'*PGM');
           *In50 = *On;
         EndIf;

         If Printer1 <> *Blanks;   //?Validate Printer 1
           If not $isPrinter(Printer1);
             *In51 = *On;
             $#MSID = 'PRT0102';
           EndIf;
           If copies1# <= 0;
             *In51 = *On;
             $#MSID = 'PRT0105';
           EndIf;
         EndIf;

         If Printer2 <> *Blanks;   //?Validate Printer 2
           If not $isPrinter(Printer2);
             *In52 = *On;
             $#MSID = 'PRT0102';
           EndIf;
           If copies2# <= 0;
             *In52 = *On;
             $#MSID = 'PRT0105';
           EndIf;
         EndIf;

         If Save1 <> 'Y'
               and Save1 <> 'N'
               and Save1 <> ' ';
           *In53 = *On;
           $#MSID = 'GEN0001';
         EndIf;

         If Save2 <> 'Y'
               and Save2 <> 'N'
               and Save2 <> ' ';
           *In54 = *On;
           $#MSID = 'GEN0001';
         EndIf;

         If *In51 or *In52 or *In53 or *In54 or *In50;
           *In50 = *On;
           ExSr Scrn01;
         Else;
           ExSr PrintIt;
           *InLR = *On;
         EndIf;

    ?  EndSr;

       //?  ...........................................................
       //?  :      PrintIt - Print the Pick to the Printer(s)         :
       //?  :.........................................................:
    ?  BegSr PrintIt;
         Select;
           When *In40 and FINTYPE = 'T';  //if Finished Trucking Pick
             If Printer1 <> *Blanks;
               PRTFINTRP(#Order:Printer1:Copies1:Save1);
             EndIf;
             If Printer2 <> *Blanks;
               PRTFINTRP(#Order:Printer2:Copies2:Save2);
             EndIf;
           When *In40 and FINTYPE = 'D';  //if Finished Dock Pick
             If Printer1 <> *Blanks;
               PRTFINDKP(#Order:Printer1:Copies1:Save1);
             EndIf;
             If Printer2 <> *Blanks;
               PRTFINDKP(#Order:Printer2:Copies2:Save2);
             EndIf;
           When *In40 and FINTYPE = 'P';  //if Finished Dock Pick
             If Printer1 <> *Blanks;
               $PrintPick(#Order:Printer1:Copies1:Save1);
             EndIf;
             If Printer2 <> *Blanks;
               $PrintPick(#Order:Printer2:Copies2:Save2);
             EndIf;
           Other;    //  Plug Order
             If Printer1 <> *Blanks;
               $PrintPick(#Order:Printer1:Copies1:Save1);
             EndIf;
             If Printer2 <> *Blanks;
               $PrintPick(#Order:Printer2:Copies2:Save2);
             EndIf;
         EndSl;

    ?  EndSr;                                                                 //?

       //?  ...........................................................
       //?  :      Scrn01 - Display Screen 01                         :
       //?  :.........................................................:
    ?  BegSr Scrn01;                                                          //?
        Screen = 01;     //Screen  Number
    ?    ExFmt Prompt01;
        %Subst(indicatorArray:50:5) = '00000';

        //*In50 = '0';
        //*In51 = '0';
        //*In52 = '0';
        //*In53 = '0';
        //*In54 = '0';
    ?  EndSr;                                                                 //?
      /END-FREE
