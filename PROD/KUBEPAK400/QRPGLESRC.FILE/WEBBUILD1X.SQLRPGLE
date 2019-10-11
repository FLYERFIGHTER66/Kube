    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      /Free

         Exec SQL
           delete from readyplug;

         Exec SQL
           insert into readyplug

           SELECT LRALPH
           , substr(trim(LRITEM)||'P',1,12) as LRITEM
           , LRSIZE
           , LRDESC
           , sum(LDPRTT)
           , current timestamp
           FROM fdlotrd_ar, flosslot
           WHERE LRCUST = 999997
           and FDLOTRD_AR.LRITEM= FLOSSLOT.LDITEM
           and FDLOTRD_AR.LRSIZE= FLOSSLOT.LDSIZE
           and FDLOTRD_AR.LRSOWD= FLOSSLOT.LDSOWD
           and FDLOTRD_AR.LRCRDY= FLOSSLOT.LDREDY
           GROUP BY LRALPH, LRSIZE, LRITEM, LRDESC

             UNION ALL

           SELECT LRALPH
           , LRITEM
           , LRSIZE
           , LRDESC
           , sum(LRQTAV)
           , current timestamp
           FROM fdlotrd_ar
           WHERE LRCUST < 999990
           GROUP BY LRALPH, LRSIZE, LRITEM, LRDESC

           ORDER BY LRALPH, LRSIZE, LRITEM, LRDESC;

         Return;

      /End-Free
