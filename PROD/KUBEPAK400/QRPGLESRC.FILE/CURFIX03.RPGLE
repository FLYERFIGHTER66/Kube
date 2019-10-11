     FFCUTORD   UF   E           K DISK
     FFMINVT    IF   E           K DISK
      *
     D  SIZE52         S                   Like(IMSIZE) Inz('52 ')
      *
     C     *LoVal        Setll     FCUTORD
     C                   Read      FCUTORD
     C                   DoW       not %EOF(FCUTORD  )
     C                   If        COSIZE = 'CUT'
     C                   MoveA     '0000'        *In(51)
     C     COQTOO        Comp      *Zeros                                 51
     C     COQTRC        Comp      *Zeros                                 52
     C  N51COQTOO        Div       1.05          COQTOO
     C  N52COQTRC        Div       1.05          COQTRC

     C     ItemKey       SetLL     FMINVT
     C     ItemKey       KList
     C                   KFld                    COITEM
     C                   KFld                    SIZE52

     C                   If        %Equal(FMINVT)
     C                   Eval      COSIZE = '52 '
     C                   Else
     C                   Eval      COSIZE = '105'
     C                   EndIf

     C                   Update    RCUTORD
     C                   EndIf
     C                   Read      FCUTORD
     C                   EndDo

     C                   Eval      *InLR = *On
