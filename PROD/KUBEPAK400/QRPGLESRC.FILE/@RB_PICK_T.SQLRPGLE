     H BndDir('*LIBL/KPFUNCTION')
     H DftActGrp(*No)

     D  #Order#        S              6P 0

     C     *Entry        PList
     C                   Parm                    #Order            6
     C                   Eval      #Order# = %int(#Order)
     C                   Call      '@RB_PICK'
     C                   Parm                    #Order#
     C                   Eval      *InLR = *On
