     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format

      //  Main procedure prototype & interface
     D PCK030          PR                  ExtPgm('PCK030')
     D  #ThisDate7                    7P 0 Const
     D  #ThisMaster                   2P 0 Const
     D PCK030          PI
     D  #ThisDate7                    7P 0 Const
     D  #ThisMaster                   2P 0 Const

     D FinishedPick    PR                  ExtPgm('PCK010')
     D  #Order                        6P 0 Const
     D  #ThisGroup                   10A   Const
     D  #ThisList                     6A   Const

     DPrintTruckCover  PR                  ExtPgm('PCK021')
     D  #Truck                        4A   Const
     D  #ThisDate7                    7P 0 Const
     D  #ThisGroup                   10A   Const

     D TruckOrdDS      DS
     D  ThisTruck                     4A   Inz(*Blanks)
     D  ThisOrder                     6S 0 Inz(*Zeros)

     D/COPY QFunctDefn,$_Dates

     D ThisDate7       S              7S 0 Inz
     D ThisMaster      S              2S 0 Inz
     D ThisPrinter     S             10A   Inz
     D LastTruck       S                   Inz Like(ThisTruck)

      /Free

         Monitor;
           ThisDate7  = #ThisDate7;
           ThisMaster = #ThisMaster;
         On-Error;
           Return;
         ENDMON;

         Monitor;
           SQLSTATE = '00000';

           Exec SQL   DECLARE TRC1 Cursor for    // Truck Schedule Cursor
             SELECT    COALESCE (FTRSCHD.TRTRK#,'')
                  ,    FMANUALD.MNORD#
             FROM      FMANUALd left outer join
                       FTRSCHD
               on      MNORD# = TRORD#
             WHERE     FMANUALD.MNDATE = :ThisDate7
               and     FMANUALD.MNSEQ# = :ThisMaster
             ORDER BY  FTRSCHD.TRTRK#
                    ,  FTRSCHD.TRSTOP
                    ,  FMANUALD.MNORD#
             For Read Only;

           Exec SQL   Close TRC1;
           Exec SQL   Open TRC1;

           DoW SQLSTATE = '00000';
             Exec SQL  Fetch TRC1 into :TruckOrdDS;
             If  SQLSTATE = '00000' and ThisOrder <> 0;
               If ThisTruck <> LastTruck;
                 LastTruck = ThisTruck;
               PrintTruckCover(ThisTruck:ThisDate7:'*ALL');
               EndIf;
               FinishedPick(ThisOrder:'*ALL':'*ALL');
             ENDIF;
           ENDDO;

           Exec SQL   Close TRC1;

         On-Error;
           Exec SQL   Close TRC1;
         ENDMON;

         Return;
