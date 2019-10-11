    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

     FFDLOTRD990UF   E           K DISK    Rename(RDLOTRD:RDLOTRD990)
     F                                     Prefix(L990_)
     FFDLOTRDN90UF   E           K DISK    Rename(RDLOTRD:RDLOTRDN90)
     F                                     Prefix(N990_)

     D QtyFound        S              3S 0 Inz(*Zero)
     D QtyFind         S              3S 0 Inz(*Zero)
      /Free
         SetLL (*LoVal) FDLOTRD990;
         Read FDLOTRD990;
         DoW Not %EOF(FDLOTRD990);
           If L990_LRQTAV < 0;
             QtyFind  = %Abs(L990_LRQTAV);
             QtyFound = FindN990(QtyFind);
             If QtyFound <> 0;
               L990_LRQTAV += QtyFound;
               L990_LRQTOH += QtyFound;
               Update RDLOTRD990;
             EndIf;
           EndIf;
           Read FDLOTRD990;
         EndDo;
         *InLR = *On;
      /End-Free
      //________________________________________________________________________
      //
     P FindN990        B
     D FindN990        PI             3S 0                                      Return QTY Found
     D Qty2Find                       3S 0                                      QTY to find
     D Found           S              3S 0 Inz(*Zero)                           QTY found
      /Free
         Reset Found;
         SetLL (L990_LRITEM:L990_LRSIZE:L990_LRCRDY:L990_LRSOWD) FDLOTRDN90;
         ReadE (L990_LRITEM:L990_LRSIZE:L990_LRCRDY:L990_LRSOWD) FDLOTRDN90;
         DoW Not %EOF(FDLOTRDN90) and Qty2Find > *Zero;
           If N990_LRQTAV > 0 and
              N990_LRCUST <> 999997 and
              N990_LRCUST <> 999990;
             If N990_LRQTAV > Qty2Find;
               Found       += Qty2Find;
               N990_LRQTAV -= Qty2Find;
               N990_LRQTOH -= Qty2Find;
               Qty2Find    -= Qty2Find;
              Else;
               Found       += N990_LRQTAV;
               N990_LRQTOH -= N990_LRQTAV;
               Qty2Find    -= N990_LRQTAV;
               N990_LRQTAV -= N990_LRQTAV;
             Endif;
             Update RDLOTRDN90;
           EndIf;
           ReadE (L990_LRITEM:L990_LRSIZE:L990_LRCRDY:L990_LRSOWD) FDLOTRDN90;
         EndDo;
         Return Found;
      /End-Free
     P FindN990        E
