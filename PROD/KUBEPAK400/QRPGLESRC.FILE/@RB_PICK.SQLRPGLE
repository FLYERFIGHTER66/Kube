     H BndDir('*LIBL/KPFUNCTION')
     H DftActGrp(*No)

      //:````````````````````````````````````````````````````````````:?
      //:                  Print Specific Pick Slip                  :?
      //:............................................................:?
      //:````````````````````````````````````````````````````````````:
      //: Created:  February 2018        ? Kube-Pak Corporation ?    :
      //:      by:  William J. Behr                                  :
      //:............................................................:
     D                 DS
     D  copies1
     D  copies1#                      2S 0 overlay(copies1) Inz(2)
     D  copies2
     D  copies2#                      2S 0 overlay(copies2) Inz(1)
     D  copies3
     D  copies3#                      2S 0 overlay(copies3) Inz(1)

     D  PRINTER1       S             10A   inz
     D  PRINTER2       S             10A   inz
     D  PRINTER3       S             10A   inz

     D  SAVE1          S              1A   inz
     D  SAVE2          S              1A   inz
     D  SAVE3          S              1A   inz

     D isRBsvia        S               N   inz

      //? Function Prototypes
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,$PrintPick

     C     *Entry        PList
     C                   Parm                    #Order            6 0

      /FREE

         If Printer1 <> *Blanks;
           $PrintPick(#Order:Printer1:Copies1:Save1);
         EndIf;
         If Printer2 <> *Blanks;
           $PrintPick(#Order:Printer2:Copies2:Save2);
         EndIf;
         If Printer3 <> *Blanks and trucking(#Order);
           $PrintPick(#Order:Printer3:Copies3:Save3);
         EndIf;

         *InLR = *On;
         return;

       //?  ...........................................................
       //?  :      Initialization                                     :
       //?  :.........................................................:
       BegSr *InzSR;

         Exec SQL
           Select '1'
           into :isRBsvia
           from FIORDRRB
           where OIORD# = :Order#
           Fetch first row only;

         If not isRBsvia;
           return;
         ENDIF;


         // Initialize
         PRINTER1=$DftPrt('*NONE':'#PRTPICK01':'*PGM');
         PRINTER1='RBOUTQ';  // Override to RBOUTQ
         PRINTER2=$DftPrt('*NONE':'#PRTPICK02':'*PGM');
         PRINTER3=$DftPrt('BILL':'*NONE':'*USER');

         Save1 = 'N';
         Save2 = 'N';
         Save3 = 'Y';

       EndSr;

       dcl-proc trucking;
         dcl-pi *n ind;
           Order# packed(6:0);
         END-PI;
         dcl-s svia41 ind inz;
         Exec SQL
           Select '1'
           into :svia41
           from FHORDR
           where OHORD# = :Order# and OHSHPC = '41';
         return svia41;
       END-PROC;

      /END-FREE
