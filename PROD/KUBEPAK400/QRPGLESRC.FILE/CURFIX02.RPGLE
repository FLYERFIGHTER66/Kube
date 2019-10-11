     FFCUTNEED  UF   E           K DISK
     FFMINVT    IF   E           K DISK
      *
     D  SIZE52         S                   Like(IMSIZE) Inz('52 ')
      *
     C     *LoVal        Setll     FCUTNEED
     C                   Read      FCUTNEED
     C                   DoW       not %EOF(FCUTNEED )
     C                   If        CNSIZE = 'CUT'

     C     ItemKey       SetLL     FMINVT
     C     ItemKey       KList
     C                   KFld                    CNITEM
     C                   KFld                    SIZE52

     C                   If        %Equal(FMINVT)
     C                   Eval      CNSIZE = '52 '
     C                   Else
     C                   Eval      CNSIZE = '105'
     C                   EndIf

     C                   MoveA     '0000'        *In(51)
     C     CNQTSL        Comp      *Zeros                                 51
     C     CNQTSH        Comp      *Zeros                                 53

     C                   If        CNSIZE = '52 '
     C  N51CNQTSL        Div       1.04          CNQTSL
     C                   Else
     C  N51CNQTSL        Div       1.05          CNQTSL
     C                   EndIf

     C  N53CNQTSH        Div       1.05          CNQTSH

     C                   Update    RCUTNEED
     C                   EndIf
     C                   Read      FCUTNEED
     C                   EndDo

     C                   Eval      *InLR = *On
