     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
          //
         //     Print Truck Cover
        //
     FPCK021P   O    E             PRINTER OFLIND(OA)

      //  Main procedure prototype & interface
     D PCK021          PR                  ExtPgm('PCK021')
     D  #ThisTruck                    4A   Const
     D  #ThisDate7                    7P 0 Const
     D  #ThisGroup                   10A   Const
     D PCK021          PI
     D  #ThisTruck                    4A   Const
     D  #ThisDate7                    7P 0 Const
     D  #ThisGroup                   10A   Const

     D/COPY QFunctDefn,$_Dates

     D RTRSCHD       E DS                  Inz ExtName(FTRSCHD)
     D RHORDR        E DS                  Inz ExtName(FHORDR)

     D ThisTruck       S              4A   Inz
     D ThisDate7       S              7S 0 Inz(0)
     D ThisGroup       S             10A   Inz
     D ThisDate        S              6S 0 Inz(0)
     D NotOnMM         S              1A   Inz                                  Not on Manual Master
     D x               S              6S 0 Inz(0)

      /Free

         Monitor;
           ThisTruck = #ThisTruck;
           ThisDate7 = #ThisDate7;
           ThisDate  = $MDYDate($Date(ThisDate7));
           ThisGroup = #ThisGroup;
         On-Error;
           Return;
         ENDMON;

         Write Header;
         Reset Detail;
         Write Detail;

         SQLSTATE = '00000';

         Exec SQL   Declare TR Cursor for
           Select   *
           From     FTRSCHD
           Where    TRTRK# = :ThisTruck
             and    TRSHDT = :ThisDate7
           Order by TRSTOP
           For Read Only;

         Exec SQL Close TR;
         Exec SQL Open  TR;

         Exec SQL Fetch TR into :RTRSCHD;

         DoW SQLSTATE = '00000';
           Exec SQL Select * Into :RHORDR from FHORDR where OHORD# = :TRORD#;
           NotOnMM = '*';
           Exec SQL Select ' ' Into :NotOnMM
                     from  FMANUALD
                     where MNORD# = :TRORD#
                       and MNDATE = :TRSHDT  Fetch First Row Only;
           CTSTZP = %Trim(OHSHCT) + ', ' + OHSHST + ' ' + OHSHZP;
           Write Detail;
           Exec SQL Fetch TR into :RTRSCHD;
         EndDo;

         Write Footer;

         Exec SQL Close TR;
         *InLR = *On;

