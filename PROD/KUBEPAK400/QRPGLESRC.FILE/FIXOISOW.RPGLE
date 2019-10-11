     FFIORDRSP  UP   E           K DISK

     C                   If        OISOW > 0
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf

     C                   If        OILOT# = 'CustomOrdr'
     C                   Call      'GETGERM'
     C                   PARM                    OIITEM
     C                   PARM                    OISIZE
     C                   PARM                    OIWHSE
     C                   PARM                    OIRVDT
     C                   PARM                    OISOW
     C                   Update    RIORDR
     C                   EndIf
