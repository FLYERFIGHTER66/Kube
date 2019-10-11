     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      /Free
    ?
       //?Delete FIORDRPART record if non-partial allocation

         EXEC SQL
         DELETE FROM FIORDRPART
          WHERE OIORD#||OISEQ# in
                (select AIORD#||AIOSEQ from falitem where aicust <> 999997);

         *INLR = *On;

      /End-Free
