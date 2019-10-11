    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')                                               ?Binding Directory
    ?H DftActGrp(*No)                                                           ?Default Activation
    ?H DatFmt(*usa)                                                             ?Date Format

     FFDLOTDSI  IF   E           K DISK
     FSPC130P   O    E             PRINTER OFLIND(*IN25)

      *? System Data Structure
    ?D                SDS                                                       ?SDS
    ?D #Program                1     10                                         ?Program Name
    ?D #Library               81     90                                         ?Library Name
    ?D #User                 254    263                                         ?User ID
    ?D #SrcLib               314    323                                         ?Source Library

      *? Function Prototypes
    ?D/COPY QFunctDefn,$_DATES

      *? Program Data Structure
     D                UDS
     D  WeekDate               1      6  0
     D  CANCEL                 7      7

     D  WeekDate7      S                   Like(LRCRDY)
     D  WholeTrays     S              7S 1
     D  PartTrays      S              7S 1
     D  TotalParts     S              6S 3
     D  Partial        S              4S 1

      /Free

         WeekDate7 = $Date7($DateMDY(WeekDate));
         Write Header;

         SetLL (WeekDate7) FDLOTDSI;
         ReadE (WeekDate7) FDLOTDSI;
         DoW Not %EOF(FDLOTDSI);

           Partial    = *Zero;

           WHOLETRAYS = *Zero;
           Exec SQL
             select sum(lrqtoh-lrqtal)
             into   :WHOLETRAYS
             from   fdlotrd
             where  lrcrdy =  :WeekDate7
               and  lritem =  :LRITEM
               and  lrsize =  :LRSIZE
               and  lrgloc <> 'N'
               and  lrcust <  999990;

           PartTrays  = *Zero;
           *In26 = *Off;
           Exec SQL
             select sum(lrqtoh-lrqtal)
             into   :PARTTRAYS
             from   fdlotrd
             where  lrcrdy = :WeekDate7
               and  lritem = :LRITEM
               and  lrsize = :LRSIZE
               and  lrgloc <> 'N'
               and  lrcust = 999997;
           If PARTTRAYS > 0;
             Exec SQL
               select sum(ldprtt)
               into   :TotalParts
               from   flosslot
               where  ldredy = :WeekDate7
                 and  lditem = :LRITEM
                 and  ldsize = :LRSIZE;
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
           If WholeTrays > *Zero or Partial > *Zero;
             Write Detail;
             TotWhole += WholeTrays;
             TotParts += PartTrays;
           EndIf;
           SetGT (WeekDate7:LRSIZE:LRALPH:LRITEM) FDLOTDSI;
           ReadE (WeekDate7) FDLOTDSI;
         EndDo;
         Write Totals;
         *InLR = *On;

      /End-Free
