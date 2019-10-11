     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
       ctl-opt datfmt(*usa) nomain;

       dcl-s Ara char(100) dim(0003) ctdata;

       //dcl-ds LDA dtaara(*auto: *lda);
       dcl-ds LDA dtaara(*lda);
        LDAData char(134) pos(1);
       end-ds;

       dcl-ds LDAwk;
        LCONO zoned(2) inz(01) pos(1);
        LJOBQ char(1) inz('N') pos(6);
        LP1ID char(10) inz('P8') pos(17);
        LP2ID char(10) inz(*blanks) pos(27);
        LBEGDT zoned(6) inz(*zeros) pos(37);
        LENDDT zoned(6) inz(*zeros) pos(43);
        LSELEC zoned(1) inz(1) pos(49);
        LBORD zoned(6) inz(*zeros) pos(50);
        LPC1 char(2) inz(*blanks) pos(59);
        LPC2 char(2) inz(*blanks) pos(61);
        LRTE1 char(2) inz(*blanks) pos(63);
        LRTE2 char(2) inz(*blanks) pos(65);
        LPHY1 char(1) inz(*blanks) pos(67);
        LPHY2 char(1) inz(*blanks) pos(68);
        LPREV char(1) inz(*blanks) pos(69);
        LSHP1 char(2) inz(*blanks) pos(70);
        LSHP2 char(2) inz(*blanks) pos(72);
        LLOC1 char(3) inz(*blanks) pos(74);
        LLOC2 char(3) inz(*blanks) pos(77);
        LTAG zoned(1) inz(3) pos(80);
        LEORD zoned(6) inz(*zeros) pos(81);
        AREA char(2) inz(*blanks) pos(87);
        LCANCL char(1) inz(*blanks) pos(133);
        AllowDetail ind inz(*on) pos(134);
       end-ds;
      //
      //? Function Prototype(s)
     D/Copy QFunctDefn,$PrintPick
     D/Copy QFunctDefn,QCMDEXC
     D/Copy QFunctDefn,$MDYDate

      //   ..................................................................
      //   :  $PrintPick                                           function :
      //   :................................................................:

       dcl-proc $PrintPick export;

       dcl-pi $PrintPick;
        #Order zoned(6) const;
        #Printer char(10) const;
        #Copies char(3) const;
        #Save char(1) const;
        #ShipWeek date const options(*nopass:*omit);
       end-pi;

       dcl-s Command char(255);
       dcl-s Length zoned(4);
       dcl-s #Save@ char(4) inz('*NO');

       Dcl-Pr Print_Pick_BIR310 Extpgm('BIR310');
       END-PR;

       If #Copies <> '000';

         If #Save = 'Y';
           #Save@ = '*YES';
         EndIf;

         In LDA;
         Reset LDAwk;

         LBORD = #Order;
         LEORD = #Order;

         if %parms >= %parmnum(#ShipWeek)
         and %addr(#ShipWeek) <> *null;
           LBEGDT = $MDYDate(#ShipWeek);
           LENDDT = $MDYDate(#ShipWeek);
         endif;

         LDAData = LDAwk;

         Out LDA;

         //Command = %trim( %trim( ara(1) )+ara(2) );
         Command = 'OVRPRTF FILE(BIR310) TOFILE(*LIBL/QSYSPRT) '
                 + 'DEV(' + %trim(#Printer) + ') '
                 + 'PAGESIZE(66 80) LPI(6) CPI(10) OVRFLW(53) ALIGN(*NO) '
                 + 'FORMTYPE(*NAR) HOLD(*NO) '
                 + 'SAVE(' +  %Trim(#Save@) + ') '
                 + 'COPIES(' + %Trim(#Copies) + ') OVRSCOPE(*JOB) '
                 + 'USRDTA(PICK' + %Trim(%Char(#Order)) +')'   // Add Order Number to USRDTA
           ;
         ExSr $Command;

         Command = %trim( ara(3));
         ExSr $Command;

         Print_Pick_BIR310();

         Command = 'DLTOVR FILE(BIR310) LVL(*JOB)';
         ExSr $Command;

       EndIf;

       //?  ..........................................................
       //?  :   Run system command                                   :
       //?  :........................................................:
       BegSR $Command;
         //? Format the command String.  Put vaiable in place in the string.

         //?   |P?=Printer ID?    ?Put the Printer Name in the Override command?
         DoW %Scan('|P':Command) <> 0;
           Command = %REPLACE
               (%Trim(#Printer): Command :
               %SCAN('|P': Command));
         EndDo;

         //?   |C?=Number Copies?  ?Put the Number of Copies in the Override command?
         DoW %Scan('|C':Command) <> 0;
           Command = %REPLACE
               (%Trim(#Copies): Command :
               %SCAN('|C': Command));
         EndDo;


         //? |S?=Save Y or N  ?  ?Put the *YES or *NO in the SAVE parameter of the OVRPRTF command
         DoW %Scan('|S':Command) <> 0;
           Command = %REPLACE
               (%Trim(#Save@): Command :
               %SCAN('|S': Command));
         EndDo;

         //?   ~ ?=Blank that needs to be removed??Replace with nothing?
         DoW %Scan('~':Command) <> 0;
           Command =
               %SubSt(Command:1:%Scan('~':Command)-1)
               + %SubSt(Command:%Scan('~':Command)+1:
               %Len(Command) - %Scan('~':Command));
         EndDo;

         //? Execute the Command using QCMDEXC.
         qcmdexc(Command:%len(%Trim(Command)));

       EndSR;

       end-proc;
**
OVRPRTF FILE(BIR310) TOFILE(*LIBL/QSYSPRT) DEV(|P~~~~~~~~) PAGESIZE(66 80) LPI(6) CPI(10)
 OVRFLW(53) ALIGN(*NO) FORMTYPE(*NAR) HOLD(*NO) SAVE(|S~~) COPIES(|C~) OVRSCOPE(*JOB)
OVRPRTF FILE(BIR310X) TOFILE(*LIBL/QSYSPRT) OVRSCOPE(*JOB)
