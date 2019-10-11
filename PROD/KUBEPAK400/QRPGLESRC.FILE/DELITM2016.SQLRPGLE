     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      //? :````````````````````````````````````````````````````````````:?
      //? :   Title:  Purge Items no longer needed 2016                :?
      //? :............................................................:?
      //? :````````````````````````````````````````````````````````````:
      //? : Created:  July    2016         ? Kube-Pak Corporation ?    :
      //? :      by:  William J. Behr                                  :
      //? :............................................................:
      //? Main procedure prototype & interface
     D DELITM2016      PR                  ExtPgm('DELITM2016')
     D DELITM2016      PI

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
           Delete from FMINVT     where IMITEM in (SELECT FLD1 FROM DELITM2016);
         Exec SQL
           Delete from FTINVT     where ITITEM in (SELECT FLD1 FROM DELITM2016);
         Exec SQL
           Delete from KPITMWHS   where IWPITM in (SELECT FLD1 FROM DELITM2016);
         Exec SQL
           Delete from FMINVTDESC where IRITEM in (SELECT FLD1 FROM DELITM2016);
         Exec SQL
           Delete from FMINSER    where ISITEM in (SELECT FLD1 FROM DELITM2016);
         Exec SQL
           Delete from FMINVT_TAG where IMITEM in (SELECT FLD1 FROM DELITM2016);
         Exec SQL
           Delete from FMINVTDESC where IDITEM in (SELECT FLD1 FROM DELITM2016);
         Exec SQL
           Delete from FMINVTECKE where IFITEM in (SELECT FLD1 FROM DELITM2016);
         Exec SQL
           Delete from FMINVTECK2 where IFITEM in (SELECT FLD1 FROM DELITM2016);
         Exec SQL
           Delete from FMINVTVEND where VIITEM in (SELECT FLD1 FROM DELITM2016);
         Exec SQL
           Delete from FMUPC   where   UPCITEM in (SELECT FLD1 FROM DELITM2016);

         *InLR = *On;

       /End-Free
