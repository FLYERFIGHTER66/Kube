     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)

     FFMOVCTL   IF   E           K DISK

      *??:````````````````````````````````````````````````````````````:?
      *??:          Purge old records from MOVE System                :?
      *??:............................................................:?

    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$AddDate

     D  Back60         S               D
     D  TestDate       S              6S 0

      /Free

       Back60  = $AddDate($Date(0):-60);

       Setll (*LoVal) FMOVCTL;
       Read FMOVCTL;
       DoW not %EOF(FMOVCTL);
         If MHCRDT = *Zero;
           TestDate = 010101;
         ELSE;
           TestDate = MHCRDT;
         ENDIF;
         If $DateMDY(TestDate) <= Back60;
           ExSr ClearDate;
         ELSE;
           SetGT (MHCRDT) FMOVCTL;
         ENDIF;
       Read FMOVCTL;
       ENDDO;

       *InLR = *On;

       //*?  ...........................................................
       //*?  :      ClearDate - Clear this date from all Files         :
       //*?  :.........................................................:
       BegSr ClearDate;

       Exec sql
        DELETE
        FROM      FMOVCTL
         WHERE    MHCRDT = :MHCRDT ;

       Exec sql
        DELETE
        FROM      FMOVJOB2
         WHERE    MJTDAT = :MHCRDT ;

       Exec sql
        DELETE
        FROM      FMOVTO
         WHERE    M2DATE = :MHCRDT ;

       ENDSR;

      /End-Free
