      /COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      //? Program Prototype
     D RB2014ADD       PR                  ExtPgm('RB2014ADD ')                     Prototype
     D Dim_FILENAME                  10A                                        Order Number
      //? Program Interface
     D RB2014ADD       PI                                                       Procedure Interface
     D FILENAME                      10A                                        Order Number
      /FREE
       Exec SQL  Delete from RB2014FILE Where PROJFILE = :FILENAME;
       Exec SQL  Insert into RB2014FILE (PROJFILE) VALUES(:FILENAME);
       *InLR = *On;
      /END-FREE
