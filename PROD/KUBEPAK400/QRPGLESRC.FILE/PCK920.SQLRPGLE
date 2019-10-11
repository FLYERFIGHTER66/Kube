     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
        //
       //    SUMMARY PICKS FOR FINISHED TRUCKING FOR GIVEN TRUCK
      //

      //  Main procedure prototype & interface
     D PCK920          PR                  ExtPgm('PCK920')
     D  #ThisDate                     6P 0 Const
     D  #ThisTruck                    4A   Const
     D PCK920          PI
     D  #ThisDate                     6P 0 Const
     D  #ThisTruck                    4A   Const

     D PCK900          PR                  ExtPgm('PCK900')
     D  #ThisDate                     6P 0 Const
     D  #ThisOrder                    6P 0 Const
     D  #Unprinted                     N   Const                                Unprinted Only

     D GetOrder        PR
     D FinishedPick    PR
     D  #Order#                       6S 0 Const

     D/COPY QFunctDefn,$_Dates
     D/COPY QFunctDefn,$Monday

     D RTRSCHD       E DS                  Inz EXTNAME(FTRSCHD)

     D  ThisDate7      S              7P 0
     D  ThisTruck      S              4A

      /Free

         ThisTruck = #ThisTruck;
         ThisDate7 = $Date7($DateMDY(#ThisDate));

         Exec SQL
           Declare C1 Cursor for
           Select  *
           from    FTRSCHD
           Where   TRTRK# = :ThisTruck
             and  TRSHDT = :ThisDate7
           For Read Only;

         Exec SQL Close C1;
         Exec SQL Open  C1;

         DoW SQLSTATE = '00000';
           Exec SQL  Fetch C1 into :RTRSCHD;
           If  SQLSTATE = '00000' and TRORD# <> 0;
             FinishedPick(TRORD#);
           ENDIF;
         ENDDO;

         Exec SQL Close C1;
         *InLR = *On;
         Return;

      /End-Free


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Print Finished Pick                                              :
      // :..................................................................:
     P FinishedPick    B
     D FinishedPick    PI
     D  #Order#                       6S 0 Const
      /Free

        CallP PCK900 (0:#Order#:*Off);

      /End-Free
     P FinishedPick    E
