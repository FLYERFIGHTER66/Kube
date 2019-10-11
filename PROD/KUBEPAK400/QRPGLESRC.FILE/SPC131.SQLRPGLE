    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')                                               ?Binding Directory
    ?H DftActGrp(*No)                                                           ?Default Activation
    ?H DatFmt(*usa)                                                             ?Date Format

     FFDLOTRD_RBIF   E           K DISK
     FSPC131P   O    E             PRINTER OFLIND(*IN25) USROPN

      *? System Data Structure
    ?D                SDS                                                       ?SDS
    ?D #Program                1     10                                         ?Program Name
    ?D #Library               81     90                                         ?Library Name
    ?D #User                 254    263                                         ?User ID
    ?D #SrcLib               314    323                                         ?Source Library

      *? Function Prototypes
    ?D/COPY QFunctDefn,$_DATES
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$ChgPrt
    ?D/COPY QFunctDefn,$User

      *? Field Definitions
     D  WholeTrays     S              7S 1
     D  PartTrays      S              7S 1
     D  TotalParts     S              6S 3
     D  Partial        S              4S 1
     D  Printer        S             10A
     D  OvrPrtf        S            256A

      /Free

         If not %Open(SPC131P);
           Printer = $ChgPrt($User():'SPC131':PRINTER);
           If Printer <> *Blanks;
             OVRPRTF = 'OVRPRTF FILE(SPC131P)' +
                              ' FORMTYPE(*NAR)' +
                              ' OUTQ(' + %Trim(Printer) + ') ' +
                              ' CPI(10) ' +
                              ' PAGRTT(0)' +
                              ' PAGESIZE(66 80)' +
                              ' OPNSCOPE(*JOB)';
             QCmdExc(OVRPRTF : %len(%trim(OVRPRTF)));
             Open SPC131P;
            Else;
             Return;
           EndIf;
         EndIf;


         Write Header;

         SetLL *LoVal FDLOTRD_RB;
         Read FDLOTRD_RB;
         DoW Not %EOF(FDLOTRD_RB);

           Partial    = *Zero;

           WHOLETRAYS = *Zero;
           Exec SQL
             select sum(lrqtoh-lrqtal)
             into   :WHOLETRAYS
             from   FDLOTRD_RB
             where  lritem =  :LRITEM
               and  lrsize =  :LRSIZE
               and  lrcust <> 999997;

           PartTrays  = *Zero;
           *In26 = *Off;
           Exec SQL
             select sum(lrqtoh-lrqtal)
             into   :PARTTRAYS
             from   FDLOTRD_RB
             where  lritem = :LRITEM
               and  lrsize = :LRSIZE
               and  lrcust = 999997;
           If PARTTRAYS > 0;
             TotalParts = *Zero;
             Exec SQL
               SELECT SUM(LDPRTT)
               INTO   :TotalParts
               FROM   FLOSSLOT, FDLOTRD_RB
               WHERE  FLOSSLOT.LDITEM = FDLOTRD_RB.LRITEM
                 and  FLOSSLOT.LDSIZE = FDLOTRD_RB.LRSIZE
                 and  FLOSSLOT.LDSOWD = FDLOTRD_RB.LRSOWD
                 and  FLOSSLOT.LDREDY = FDLOTRD_RB.LRCRDY
                 and  FDLOTRD_RB.LRCUST = 999997
                 and  FLOSSLOT.LDITEM = :LRITEM
                 and  FLOSSLOT.LDSIZE = :LRSIZE;
             *In26 = *On;
             If TotalParts < 10;
               Partial = TotalParts * 100;
              Else;
               Partial = *Zero;
             EndIf;
           EndIf;
           If *In25;
             Write Header;
             *In25 = *Off;
           EndIf;
           If WholeTrays > *Zero or PartTrays > *Zero;
             Write Detail;
             TotWhole += WholeTrays;
             TotParts += PartTrays;
           EndIf;
           SetGT (LRSIZE:LRALPH:LRITEM) FDLOTRD_RB;
           Read FDLOTRD_RB;
         EndDo;
         Write Totals;

         If %Open(SPC131P);
           Close SPC131P;
         EndIf;

         *InLR = *On;

      /End-Free
