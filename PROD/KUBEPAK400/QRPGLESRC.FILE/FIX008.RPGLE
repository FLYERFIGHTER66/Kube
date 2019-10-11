    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*no)
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Fix Plug Descriptions (Remove Saleable Cells)      :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  JUN 2005             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :  Reads through                                            ?:
      *? :............................................................:
     FFMINVT    UP   E             DISK

     D  x              S              2S 0
     D  Length         S              3S 0
     D  xxx            S              3A
     D  Found@         S              3S 0
     D  Search         S              8A
     D  BLANKS         S              8A   Inz(*Blanks)
     D  Formats        S              8A   DIM(14) CTDATA PERRCD(1)
     D  NewDesc        S                   Like(IMDES1)

    ?C                   Select
    ?C                   When      IMSIZE = '105'
     C                   Eval      xxx = '100'
     C                   ExSr      FixDesc
    ?C                   When      IMSIZE = '288'
     C                   Eval      xxx = '250'
     C                   ExSr      FixDesc
    ?C                   When      IMSIZE = '162'
     C                   Eval      xxx = '150'
     C                   ExSr      FixDesc
    ?C                   When      IMSIZE = '512'
     C                   Eval      xxx = '450'
     C                   ExSr      FixDesc
    ?C                   Other
     C*                  Do        Nothing
    ?C                   EndSl

      *?  ...........................................................
      *?  :      FixDesc - Fix the Description                      :
      *?  :.........................................................:

     C     FixDesc       BegSr
     C                   Eval      X = 0
     C                   DoW       X < 14
     C                   Eval      X = X + 1
     C                   Eval      Search = %Replace(xxx:Formats(X):1:3)
     C                   Eval      Length = %Len(%TrimR(Search))
     C                   Eval      Found@ = %Scan(%TrimR(Search):IMDES1)
     C                   If        Found@ > 0
     C                   Eval      IMDES1 = %Replace(%Subst(Blanks:1:Length):
     C                                       IMDES1:Found@:Length)
     C                   Update    RMINVT
     C                   Eval      X = 15
     C                   EndIf
     C                   EndDo
     C                   EndSr

** ?Formats
xxx/TRAY   01 8
xxx TRAY   02 8
xxxTRAY    03 7
xxx/TRA    04 7
xxx TRA    05 7
xxxTRA     06 6
xxx/TR     07 6
xxx TR     08 6
xxxTR      09 5
xxx/T      10 5
xxx T      11 5
xxxT       12 4
xxx/       13 4
xxx        14 3
