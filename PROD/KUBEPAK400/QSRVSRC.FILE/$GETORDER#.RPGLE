     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

     FFOECTL    UF   E           K DISK    UsrOpn

      *? Function Prototype(s)
     D/Copy QFunctDefn,$getOrder#

     ?*   ..................................................................
     ?*   :  $GetOrder#                                           function :
     ?*   :................................................................:

     P  $GetOrder#     B                        Export

     D  $GetOrder#     PI             6S 0
     D     #Company                   2S 0      const

?    ?*  The $GetOrder# function gets the Next available Kube-Pak Order Number from the
?    ?*  FOECTL file and updates the file, incrementing the invoice number by one

     D     NextInv#    S              6S 0

     C                   Open      FOECTL
     C     #Company      Chain     FOECTL
     C                   If        %found(FOECTL)
     C                   eval      NextInv# = OCNORD
     C                   eval      OCNORD = OCNORD + 1
     C                   Update    ROECTL
     C                   Close     FOECTL
     C                   return    NextInv#
     C                   Else
     C                   UnLock    FOECTL
     C                   Close     FOECTL
     C                   return    999999
     C                   EndIf

     P  $GetOrder#     E
