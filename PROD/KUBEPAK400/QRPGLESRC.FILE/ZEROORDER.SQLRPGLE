     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      //? :````````````````````````````````````````````````````````````:?
      //? :   Title:  Zero Out Pricing from Order                      :?
      //? :............................................................:?
      //? :````````````````````````````````````````````````````````````:
      //? : Created:  March 2016           ? Kube-Pak Corporation ?    :
      //? :      by:  William J. Behr                                  :
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :   Program Description                                     ?:
      //? : ```````````````````````                                   ?:
      //? :                                                           ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Edit Log                                                ?:
      //? :                                                           ?:
      //? :  WJB    -? 1/22/16 - Initial Programming                  ?:
      //? :         -?  /  /   - _____________________________________?:
      //? :............................................................:

     FZEROORDFM CF   E             WORKSTN

      //? Main procedure prototype & interface
     D ZEROORDER       PR                  ExtPgm('ZEROORDER')
     D  #Order@                       6A   const
     D ZEROORDER       PI
     D  #Order@                       6A   const

     D  Order#         S              6S 0

      /Free

         Eval Order# = %Int(%Trim(#Order@));

         DoW not *In03 and not *In21;
           Exfmt Zero01;
         EndDo;

         If *In21;

           Exec SQL
             update fiordr
             SET    OIUPRI=0
                 ,  OIEXT$=0
                 ,  OIOVER='Y'
             WHERE  oiord# = :Order#
               and  oistat = 'A'
               and  oiityp = ' ';

         EndIf;

         *InLR = *On;

       /End-Free
