     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      //? :````````````````````````````````````````````````````````````:?
      //? :   Title:  Upload Finished Production Schedule Info         :?
      //? :............................................................:?
      //? :````````````````````````````````````````````````````````````:
      //? : Created:  January 2016         ? Kube-Pak Corporation ?    :
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

      //? Main procedure prototype & interface
     D SDR916          PR                  ExtPgm('SDR916')
     D SDR916          PI

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCMDEXC
    ?D/COPY QFunctDefn,$Today
    ?D/COPY QFunctDefn,$Now

      *? Fields
     D  Command        S            256A   inz(*Blanks)
     D  Today          S              6S 0 inz(0)
     D  Now            S              6S 0 inz(0)

      /Free

         Today = $Today();

         Exec SQL
           update fseries
           set SEVND = (Select SVVEND from FSERVDRUP where SVCODE = SECODE)
           where SECODE in (Select SVCODE from FSERVDRUP);

         Exec SQL
           update fseries
           set SEPRC = (Select SVPRC1 from FSERVDRUP where SVCODE = SECODE)
           where SECODE in (Select SVCODE from FSERVDRUP);

         Exec SQL
           update fseries
           set SEDTLA = :Today
           where SECODE in (Select SVCODE from FSERVDRUP);

         *InLR = *On;

       /End-Free
