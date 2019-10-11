     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:      Center given text in a field of given length          :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May 2004             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :  This program is used center a text string in a field of  ?:
      *? :  a specific length.  The Text and Length are passed in    ?:
      *? :  and the result string is returned.                       ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :............................................................:

      *? Function Prototype(s)
     D/Copy QFunctDefn,$AlignLeft

     P $AlignLeft      B                   Export
     D $AlignLeft      PI           198A
     D   #Text                      198A   Const
     D   #Length                      3S 0 Const

      *? Field Definitions
     D   @Text         S            198A   Inz(*Blanks)                         ?Work Text Field

     C                   Eval      *InLR = *On

     C                   If        %len(%trim(#Text)) >= #Length - 1

     C                   Return    #Text
     C                   Else

     C                   Eval      %Subst(@Text
     C                             :%Int(#Length - %len( %trim(#Text) ) )
     C                             :%len( %trim(#Text) ) ) = #Text

     C                   Return    @Text
     C                   EndIf

     P $AlignLeft      E
