    ?H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DATFMT(*USA)
    ?H NOMAIN

     FFMINVT    IF   E           K DISK    UsrOpn
     FFMSIZE    IF   E           K DISK    UsrOpn

      *? Function Prototype(s)
    ?D/Copy QFunctDefn,$SeedSown

     ?*   ..................................................................
     ?*   :  $SeedSown                                            function :
     ?*   :................................................................:

     P  $SeedSown      B                        Export

     D  $SeedSown      PI            15S 0
     D     #Item                     12         const
     D     #Size                      3         const
     D     #Trays                     7S 0      const

?    ?*  The $SeedSown  function uses the standard calculation for determining how many
?    ?*  seeds to deduct from inventory for the number of trays sown.

     D     #SeedSown   S             15S 0
     D     #Seed       S              3A   Inz('SED')
     D     Factor      S              5S 4

    ?C                   Open      FMINVT
    ?C                   Open      FMSIZE

    ?C     ItemSeed      Chain     FMINVT

     C                   Eval      Factor = 1 + ( IMMULT / 100 )

    ?C     #Size         Chain     FMSIZE
    ?C     ItemKey       Chain     FMINVT

     C                   Eval      #SeedSown =
     C                             %Int( #Trays * SZCELL * IM#SED * Factor )

    ?C                   Close     FMINVT
    ?C                   Close     FMSIZE

     C                   return    #SeedSown

    ?C     ItemKey       KList
    ?C                   KFld                    #Item
    ?C                   KFld                    #Size

    ?C     ItemSeed      KList
    ?C                   KFld                    #Item
    ?C                   KFld                    #Seed

     P  $SeedSown      E
