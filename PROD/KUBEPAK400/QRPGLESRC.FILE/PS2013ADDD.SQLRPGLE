      /COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
?     // ?:````````````````````````````````````````````````````````````:?
?     // ?:         PS2013ADDD
?     // ?:............................................................:?
?     //  :````````````````````````````````````````````````````````````:
?     //  : Created:  Mar. 2013            ? Kube-Pak Corporation ?    :
?     //  :      by:  William J. Behr                                  :
?     //  :............................................................:
?     //  :````````````````````````````````````````````````````````````:
?     //  :   Program Description                                      :
?     //  : ```````````````````````                                    :
?     //  :............................................................:


      //? Function Prototypes
    ?D*COPY QFunctDefn,$Date

      //? Program Prototype
     D PS2013ADDD      PR                  ExtPgm('PS2013ADDD')                     Prototype
     D Dim_FILENAME                  10A                                        Order Number
      //? Program Interface
     D PS2013ADDD      PI                                                       Procedure Interface
     D FILENAME                      10A                                        Order Number


      /FREE

       Exec SQL
         Delete from PS2013FILE Where PROJFILE = :FILENAME;

       Exec SQL
         Insert into PS2013FILE (PROJFILE) VALUES(:FILENAME);

       *InLR = *On;

      /END-FREE
