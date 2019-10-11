     FFCUTLOT   UF   E           K DISK
     FFMINVT    IF   E           K DISK
      *
     D  SIZE52         S                   Like(IMSIZE) Inz('52 ')
     D  Factor         S              3S 2
      *
     C     *LoVal        Setll     FCUTLOT
     C                   Read      FCUTLOT
     C                   DoW       not %EOF(FCUTLOT  )
     C                   If        CLSIZE = 'CUT'

     C     ItemKey       SetLL     FMINVT
     C                   If        %Equal(FMINVT)
     C                   Eval      CLSIZE = '52 '
     C                   Eval      Factor = 1.04
     C                   Else
     C                   Eval      CLSIZE = '105'
     C                   Eval      Factor = 1.05
     C                   EndIf

     C                   MoveA     '0000'        *In(51)
     C     CLQTSL        Comp      *Zeros                                 51
     C     CLQTOH        Comp      *Zeros                                 52
     C     CLQTOO        Comp      *Zeros                                 54
     C  N51CLQTSL        Div       Factor        CLQTSL
     C                   Move      CLQTOH        CLQTOH2           2 0
     C                   If        not *In52 and CLQTOH2 <> 0
     C     CLQTOH        Div       1.05          CLQTOH
     C                   EndIf
     C  N54CLQTOO        Div       1.05          CLQTOO
     C                   Eval      CLQTAV = CLQTOO + CLQTOH - CLQTSL

     C                   Update    RCUTLOT
     C                   EndIf
     C                   Read      FCUTLOT
     C                   EndDo

     C     ItemKey       KList
     C                   KFld                    CLITEM
     C                   KFld                    SIZE52

     C                   Eval      *InLR = *On
