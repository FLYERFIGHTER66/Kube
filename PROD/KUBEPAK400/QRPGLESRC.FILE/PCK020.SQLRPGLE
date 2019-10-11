     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format

      //  Main procedure prototype & interface
     D PCK020          PR                  ExtPgm('PCK020')
     D  #ThisTruck                    4A   Const
     D  #ThisDate                     6P 0 Const
     D  #Group                       10A   Const
     D  #List                         6A   Const
     D PCK020          PI
     D  #ThisTruck                    4A   Const
     D  #ThisDate                     6P 0 Const
     D  #Group                       10A   Const
     D  #List                         6A   Const

     D FinishedPick    PR                  ExtPgm('PCK010')
     D  #Order                        6P 0 Const
     D  #Group                       10A   Const
     D  #List                         6A   Const

     D RTRSCHD       E DS                  ExtName(FTRSCHD)

     D/COPY QFunctDefn,$_Dates

     D ThisTruck       S              4A
     D ThisDate7       S              7S 0 Inz(0)

      /Free

         Monitor;
           ThisTruck = #ThisTruck;
           ThisDate7 = $Date7($DateMDY(#ThisDate));
         On-Error;
           Return;
         ENDMON;

         Monitor;
           SQLSTATE = '00000';

           Exec SQL   DECLARE TRC1 Cursor for    // Truck Schedule Cursor
             SELECT   *
             FROM     FTRSCHD
             WHERE  ( TRTRK# = :ThisTruck
                   or :ThisTruck = '*ALL' )
               and    TRSHDT = :ThisDate7
               and    TRORD# in (SELECT PLORD# FROM FIN_ORD)
             ORDER BY TRTRK#, TRSTOP
             For Read Only;

           Exec SQL   Close TRC1;
           Exec SQL   Open TRC1;

           DoW SQLSTATE = '00000';
             Exec SQL  Fetch TRC1 into :RTRSCHD;
             If  SQLSTATE = '00000' and TRORD# <> 0;
               FinishedPick(TRORD#:#Group:#List);
             ENDIF;
           ENDDO;

           Exec SQL   Close TRC1;

         On-Error;
           Exec SQL   Close TRC1;
         ENDMON;

         Return;
