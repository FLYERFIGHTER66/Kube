     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:                     Ready Bay Check Out                    :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  April 2004           ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? : Adds an Dummy Order to FPUTORD for Ready Bay Additions    ?:
      *? :............................................................:

     FFDLOTRDY  UF   E           K DISK
     FFDLOTRD_S UF A E           K DISK    RENAME(RDLOTRD:S_RECORD)

     D GRS610          PI
     D  Week_Selected                 7S 0

     D  Qty2Move       S                   Like(LRQTOH)

      /Free

         //Move Available Inventory to Location "S" (Selected for RB)

         SetLL Week_Selected FDLOTRDY;
         ReadE Week_Selected FDLOTRDY;
         DoW not( %EOF(FDLOTRDY) );

           If LRGLOC = *Blanks;

             If LRQTOH > LRQTAL;

               Qty2Move = LRQTOH - LRQTAL;
               LRQTOH -= Qty2Move;
               LRQTAV -= Qty2Move;

               Update RDLOTRD;
               Chain (LRITEM:LRSIZE:LRSOWD:LRCRDY:'S  ':LRCUST) FDLOTRD_S;

               If %Found(FDLOTRD_S);
                 LRQTOH += Qty2Move;
                 LRQTAV += Qty2Move;
                 Update S_RECORD;
                 Else;
                 LRGLOC  = 'S'     ;
                 LRQTOH  = Qty2Move;
                 LRQTAV  = Qty2Move;
                 LRQTAL  = 0;
                 Write  S_RECORD;
               ENDIF;

             ENDIF;

           ENDIF;

           ReadE Week_Selected FDLOTRDY;

         EndDo;

         *InLR = *On;


      /End-Free
