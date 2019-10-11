     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format

      //  Main procedure prototype & interface
     D PCK050          PR                  ExtPgm('PCK050')
     D  #SelDate                      6P 0 Const
     D  #SelMast                      2P 0 Const
     D  #SelGrup                     10A   Const
     D  #SelTruk                      4A   Const
     D  #SelList                      6A   Const
     D  #Printer                     10A   Const
     D PCK050          PI
     D  #SelDate                      6P 0 Const
     D  #SelMast                      2P 0 Const
     D  #SelGrup                     10A   Const
     D  #SelTruk                      4A   Const
     D  #SelList                      6A   Const
     D  #Printer                     10A   Const

     D FinishedPick    PR                  ExtPgm('PCK010')
     D  #Order                        6P 0 Const
     D  #ThisGroup                   10A   Const
     D  #ThisList                     6A   Const

     DPrintTruckCover  PR                  ExtPgm('PCK021CL')
     D  #Truck                        4A   Const
     D  #ThisDate7                    7P 0 Const
     D  #ThisGroup                   10A   Const
     D  #Printer                     10A   Const


     D/COPY QFunctDefn,$_Dates

     D FTRSCHD       E DS                  ExtName(FTRSCHD  )
     D FIORDR        E DS                  ExtName(FIORDR   )
     D FMORLS        E DS                  ExtName(FMORLS   )
     D FMANUALD      E DS                  ExtName(FMANUALD )
     D FMORLHCFG     E DS                  ExtName(FMORLHCFG)

     D PrintOrdDS      DS
     D ThisDate                            Inz Like(TRSHDT)
     D ThisMast                            Inz Like(MNSEQ#)
     D ThisGrup                            Inz Like(HCGRUP)
     D ThisTruk                            Inz Like(TRTRK#)
     D ThisStop                            Inz Like(TRSTP#)
     D ThisOrd#                            Inz Like(TRORD#)
     D ThisList                            Inz Like(HCLIST)

     D SelDate         S                   Inz Like(#SelDate)
     D SelDate7        S                   Inz Like(TRSHDT)
     D SelMast         S                   Inz Like(MNSEQ#)
     D SelGrup         S                   Inz Like(HCGRUP)
     D SelTruk         S                   Inz Like(TRTRK#)
     D SelList         S                   Inz Like(HCLIST)

     D ThisDate7       S              7S 0 Inz
     D ThisMaster      S              2S 0 Inz
     D ThisPrinter     S             10A   Inz

     D LastTruk        S                   Inz Like(ThisTruk)
     D LastOrd#        S                   Inz Like(ThisOrd#)
     D LastGrup        S                   Inz Like(ThisGrup)

      /Free

         Monitor;
           SelDate  = #SelDate;
           SelDate7 = $Date7($DateMDY(SelDate));
           SelMast  = #SelMast;
           SelGrup  = #SelGrup;
           SelTruk  = #SelTruk;
           SelList  = #SelList;
           ThisPrinter  = #Printer;
         On-Error;
           Return;
         ENDMON;

         Monitor;
           SQLSTATE = '00000';

           Exec SQL    DECLARE C1 Cursor for
             SELECT    DISTINCT
                       FTRSCHD.TRSHDT
                  ,    FMANUALD.MNSEQ#
                  ,    FMORLHCFG.HCGRUP
                  ,    FTRSCHD.TRTRK#
                  ,    FTRSCHD.TRSTP#
                  ,    FTRSCHD.TRORD#
                  ,    FMORLHCFG.HCLIST
             FROM      FTRSCHD
                  ,    FIORDR
                  ,    FMORLS
                  ,    FMANUALD
                  ,    FMORLHCFG
             WHERE     FTRSCHD.TRORD#   = FIORDR.OIORD#
               and     FTRSCHD.TRORD#   = FMANUALD.MNORD#
               and     FTRSCHD.TRSHDT   = FMANUALD.MNDATE
               and     FIORDR.OIITEM    = FMORLS.OLITEM
               and     FIORDR.OISIZE    = FMORLS.OLSIZE
               and     FMORLS.OLLIST    = FMORLHCFG.HCLIST
               and     FTRSCHD.TRSHDT   = :SelDate7
               and   ( FMANUALD.MNSEQ#  = :SelMast
                          or :SelMast   = 0            )
               and   ( FMORLHCFG.HCGRUP = :SelGrup
                          or :SelGrup   = '*ALL'       )
               and   ( FTRSCHD.TRTRK#   = :SelTruk
                          or :SelTruk   = '*ALL'       )
               and   ( FMORLS.OLLIST    = :SelList
                          or :SelList   = '*ALL'       )

             GROUP BY
                       FTRSCHD.TRSHDT
                  ,    FMANUALD.MNSEQ#
                  ,    FMORLHCFG.HCGRUP
                  ,    FTRSCHD.TRTRK#
                  ,    FTRSCHD.TRSTP#
                  ,    FTRSCHD.TRORD#
                  ,    FMORLHCFG.HCLIST

             ORDER BY
                       FTRSCHD.TRSHDT
                  ,    FMANUALD.MNSEQ#
                  ,    FMORLHCFG.HCGRUP
                  ,    FTRSCHD.TRTRK#
                  ,    FTRSCHD.TRSTP#
                  ,    FTRSCHD.TRORD#
                  ,    FMORLHCFG.HCLIST

             For Read Only;

           Exec SQL   Close C1;
           Exec SQL   Open C1;

           DoW SQLSTATE = '00000';
             Exec SQL  Fetch C1 into :PrintOrdDS;
             If  SQLSTATE = '00000' and ThisOrd# <> 0;
               If ThisTruk <> LastTruk;
                 LastTruk = ThisTruk;
               // Remove Truck Covers per Rob Sr. 4/16/2016
               //PrintTruckCover(ThisTruk:ThisDate:ThisGrup:ThisPrinter);
               EndIf;
               If SelList = '*ALL';
                 If ThisOrd# <> LastOrd# or ThisGrup <> LastGrup;
                   FinishedPick(ThisOrd#:ThisGrup:'*ALL');
                 EndIf;
                 LastOrd# = ThisOrd#;
                 LastGrup = ThisGrup;
                Else;
                 FinishedPick(ThisOrd#:ThisGrup:SelList);
               EndIf;
             ENDIF;
           ENDDO;

           Exec SQL   Close C1;

         On-Error;
           Exec SQL   Close C1;
         ENDMON;

         Return;
