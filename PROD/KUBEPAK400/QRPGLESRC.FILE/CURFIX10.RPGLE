     FFCUTORDIO IF   E           K DISK
     FFCUTLOT   UF A E           K DISK
     FFMINVT    IF   E           K DISK
      *
    ?C     *LoVal        Setll     FCUTORDIO
    ?C                   Read      FCUTORDIO

     C                   DoW       not %EOF(FCUTORDIO)

     C     LotKey        Chain     FCUTLOT
     C                   Eval      CLQTOO = *Zero
     C                   Eval      CLQTOH = *Zero

    ?C     LotKey        SetLL     FCUTORDIO
    ?C     LotKey        ReadE     FCUTORDIO

     C                   DoW       not %EOF(FCUTORDIO)

    ?C                   Select
    ?C                   When      COSTAT = ' '
     C                   Eval      CLQTOO = CLQTOO + COQTOO
    ?C                   When         COSTAT = 'C'
    ?C                             or COSTAT = 'M'
    ?C                             or COSTAT = '9'
    ?C                             or COSTAT = 'P'
     C                   Eval      CLQTOH = CLQTOH + COQTRC
    ?C                   EndSl

    ?C     LotKey        ReadE     FCUTORDIO
     C                   EndDo

     C                   If        CLQTOH < 0
     C                   Eval      CLQTOH = 0
     C                   EndIf

     C                   If        %Found(FCUTLOT)
    ?C                   Update    RCUTLOT
     C                   Else
     C                   Eval      CLVEND = COVEND                              VENDOR #
     C                   Eval      CLSTAT = COSTAT                              STATUS
     C                   Eval      CLITEM = COITEM                              ITEM #
     C                   Eval      CLSIZE = COSIZE                              SIZE CODE
     C                   Eval      CLUSEC = COUSEC                              USE CODE
     C                   Eval      CLSOWD = COSOWD                              SOW DATE CYMD
     C                   Eval      CLRDYD = CORDYD                              READY DATE CYMD
     C                   Eval      CLLOOK = COLOOK                              APLHA SEARCH
     C                   Eval      CLQTTS = 0                                   QUANTITY TRAYS SOLD
     C                   Eval      CLQTSP = 0                                   QUANTITY TRAYS SPEC
     C                   Eval      CLQTTF = 0                                   QUANTITY FIXERS
     C                   Eval      CLQTSL = 0                                   QUANTITY CUTS SOLD
     C                   Eval      CLQTAV = 0                                   QTY. AVAILABLE
     C                   Write     RCUTLOT
     C                   EndIf

    ?C     LotKey        SetGT     FCUTORDIO
    ?C                   Read      FCUTORDIO
     C                   EndDo

    ?C     LotKey        KList
    ?C                   KFld                    COVEND
    ?C                   KFld                    COITEM
    ?C                   KFld                    COSIZE
    ?C                   KFld                    COSOWD

     C                   Eval      *InLR = *On
