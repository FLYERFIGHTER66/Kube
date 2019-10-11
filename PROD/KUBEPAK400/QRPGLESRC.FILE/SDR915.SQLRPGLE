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
     D SDR915          PR                  ExtPgm('SDR915')
     D SDR915          PI

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCMDEXC
    ?D/COPY QFunctDefn,$Today
    ?D/COPY QFunctDefn,$Now

      *? Fields
     D  Command        S            256A   inz(*Blanks)
     D  Today          S              6S 0 inz(0)
     D  Now            S              6S 0 inz(0)

      /Free

         Exec SQL
           DROP TABLE   QTEMP/FSEDPRCUP2;

         Command = 'XLPARSE2/XLSTABLE ' +
                   'XLS(''/KUBE PAK/XLSIMPORT/SEDVDRMRG.XLSX'') ' +
                   'FILE(QTEMP/FSEDVDRUP2) ' +
                   'CRTFILE(*YES) '+
                   'SRCFILE(TGMSDATA/QDDSSRC) ' +
                   'HLINES(1) ' ;
         QCmdExc(Command:%Len(%Trim(Command)));

         Exec SQL
           DELETE FROM FSERVDRUP;

         Today = $Today();
         Now = $Now();

         Exec SQL
           insert into FSERVDRUP ( Select
             FLD1
           , FLD2
           , FLD3
           , :Today
           , :Now
           , 'PCUPLOAD'
             from FSEDVDRUP2 );

         *InLR = *On;

       /End-Free
