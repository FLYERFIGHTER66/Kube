    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*No)
    ?H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
    ?H DatFmt(*Usa)

    ?D UPD1521PRC      PR                  ExtPgm('UPD1521PRC')
    ?D UPD1521PRC      PI

    ? /Free

         Exec SQL
           update  fiordr
           Set     oiupri =  0
             ,     oiext$ =  0
             ,     oiover =  'Y'
           where ( oicust = 1521 or oicust = 8077 )
             and   oistat = 'A'
             and   oiityp = ' '
             and ( oiupri <> 0
             or    oiext$ <> 0
             or    oiover <> 'Y' );

         *InLR = *On;
         Return;

    ? /End-Free
