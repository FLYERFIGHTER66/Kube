     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format

      //  Main procedure prototype & interface
     D PCK020          PR                  ExtPgm('PCK030')
     D  #ThisDate                     6P 0 Const
     D  #ThisMaster                   2P 0 Const
     D PCK020          PI
     D  #ThisDate                     6P 0 Const
     D  #ThisMaster                   2P 0 Const

     D FinishedPick    PR                  ExtPgm('PCK010')
     D  #ThisOrder                    6P 0 Const
     D  #ThisGroup                   10A   Const
     D  #ThisList                     6A   Const

     D RTRSCHD       E DS                  ExtName(FTRSCHD)

     D/COPY QFunctDefn,$_Dates

     D ThisDate7       S              7S 0 Inz(0)
     D ThisMaster      S              2S 0

      /Free

         Monitor;
           ThisMaster = #ThisMaster;
           ThisDate7  = $Date7($DateMDY(#ThisDate));
         On-Error;
           Return;
         ENDMON;

         Monitor;
           SQLSTATE = '00000';

           Exec SQL   DECLARE TRC1 Cursor for    // Truck Schedule Cursor
             SELECT *
             FROM       FTRSCHD
             WHERE      FTRSCHD.TRORD# in
              ( SELECT  MNORD#
                FROM    FMANUALD
                WHERE   MNDATE=:ThisDate7
                  and   MNSEQ#=:ThisMaster )
             ORDER BY   FTRSCHD.TRTRK#
                    ,   FTRSCHD.TRSTOP
             For Read Only;

           Exec SQL   Close TRC1;
           Exec SQL   Open  TRC1;

           DoW SQLSTATE = '00000';
             Exec SQL  Fetch TRC1 into :RTRSCHD;
             If  SQLSTATE = '00000' and TRORD# <> 0;
               FinishedPick(TRORD#:'*ALL':'*ALL');
             ENDIF;
           ENDDO;

           Exec SQL   Close TRC1;

         On-Error;
           Exec SQL   Close TRC1;
         ENDMON;

         Return;
