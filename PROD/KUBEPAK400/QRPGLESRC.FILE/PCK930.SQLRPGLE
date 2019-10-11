     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
        //
       //    SUMMARY PICKS FOR FINISHED TRUCKING FOR GIVEN TRUCK
      //

      //  Main procedure prototype & interface
     D PCK930          PR                  ExtPgm('PCK930')
     D  #FromOrd#                     6P 0 Const
     D  #ToOrd#                       6P 0 Const
     D PCK930          PI
     D  #FromOrd#                     6P 0 Const
     D  #ToOrd#                       6P 0 Const

     D PCK900          PR                  ExtPgm('PCK900')
     D  #ThisDate                     6P 0 Const
     D  #ThisOrder                    6P 0 Const
     D  #Unprinted                     N   Const                                Unprinted Only

     D GetOrder        PR
     D TruckPick       PR
     D  #Order#                       6S 0 Const

     D/COPY QFunctDefn,$_Dates
     D/COPY QFunctDefn,$Monday

     D RHORDR        E DS                  Inz EXTNAME(FHORDR)

     D  FromOrd#       S              6P 0
     D  ToOrd#         S              6P 0

      /Free

         FromOrd# = #FromOrd#;
         ToOrd# = #ToOrd#;

         Exec SQL
           Declare C1 Cursor for
           Select  *
           from    FHORDR
           Where   OHORD# between :FromOrd# and :ToOrd#
           For Read Only;

         Exec SQL Close C1;
         Exec SQL Open  C1;

         DoW SQLSTATE = '00000';
           Exec SQL  Fetch C1 into :RHORDR;
           If  SQLSTATE = '00000' and OHORD# <> 0;
             TruckPick(OHORD#);
           ENDIF;
         ENDDO;

         Exec SQL Close C1;
         *InLR = *On;
         Return;

      /End-Free


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Print Truck Pick                                                 :
      // :..................................................................:
     P TruckPick       B
     D TruckPick       PI
     D  #Order#                       6S 0 Const
      /Free

        CallP PCK900 (0:#Order#:*Off);

      /End-Free
     P TruckPick       E
