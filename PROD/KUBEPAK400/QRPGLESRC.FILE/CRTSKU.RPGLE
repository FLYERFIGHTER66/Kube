    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         GET NEXT AVAILBLE SKU#                             :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2008            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :  *INZSR   -?Initialization Subroutine                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :          ?                                                ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :   Every Kube Pak Item (FMINVT) is assigned a UNIQUE       ?:
      *? :   5 digit SKU#.  The SKU# is used in the creation of      ?:
      *? :   UPC Bar Codes.                                          ?:
      *? :          ?                                                ?:
      *? :      This program generates new SKU#'s for Items          ?:
      *? :    ====================================================   ?:
      *? :      When this program is call with a Kube Pak Item       ?:
      *? :      and Size, it will first check for the existence      ?:
      *? :      of a SKU#.  If the SKU exists, the existing SKU      ?:
      *? :      is returned to the program.  If the SKU does not     ?:
      *? :      exist, one is created using the NXTSKU program       ?:
      *? :      to retrieve a unique SKU number and combining        ?:
      *? :      that with the Item and Size passed in Parms.          :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :  06/05/09 - Added Item/Siz to Desc per Bill Swanekamp      :
      *? :............................................................:
      *
     FFMUPCITEM UF A E           K DISK
     FFMORLSIS  IF   E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User

      *? Field Definitions
     D  Passed_Item    S                   Like(UPCITEM)                        ?KP Item Number
     D  Passed_Size    S                   Like(UPCSIZE)                        ?KP Size Code
     D  Passed_Desc    S             30A                                        ?KP Description
     D  Working_Desc   S             40A                                        ?KP Desc+Item+Size
     D  UPC_Prefix     S                   Like(UPCPREF)                        ?UPC Prefix
     D  Manufacturer   S                   Like(UPCMANF)                        ?UPC Manufacturer
     D  SKU_to_Use     S                   Like(UPCSKU#)                        ?UPC SKU#
     D  Check_Digit    S                   Like(UPCCHKD)                        ?UPC Check Digit
     D  Check_DigitWK  S             +1    Like(UPCCHKD)                        ?UPC Check Digit
     D  Even           S              3S 0                                      ?Check Digit Work FL
     D  Odd            S              3S 0                                      ?Check Digit Work FL
     D  After_Pos      S              2S 0                                      ?1st Blank After Mid
     D  Before_Pos     S              2S 0                                      ?1st Blank B4 Middle
     D  Desc_Len       S              2S 0                                      ?Length of Desc.
     D  Desc_Mid       S              2S 0                                      ?Middle of Desc.
     D  Desc_Break     S              2S 0                                      ?Where to Split Desc
     D  X              S              2S 0                                      ?Working Index Fld
     D  DescWK         S              1A   Dim(40)                              ?Work Description

      *? Data Structures
     D  UPC_DS         DS                  Inz
     D  UPC                          11A                                        ?UPC First 11
     D  UPC_11                        1S 0 Dim(11) Overlay(UPC)                 ?UPC First 11

    ?C     ItemSize      KList
    ?C                   Kfld                    Passed_Item
    ?C                   Kfld                    Passed_Size
    ?C     ItemSize      SetLL     FMUPCITEM
     C                   If        not %Equal(FMUPCITEM)
    ?C                   Call      'NXTSKU'
    ?C                   Parm                    SKU_to_Use
    ?C                   Parm                    UPC_Prefix
    ?C                   Parm                    Manufacturer
     C                   Eval      UPC = %Trim(%EditW(UPC_Prefix:'0 '))
     C                                 + %Trim(%EditW(Manufacturer:'0     '))
     C                                 + %Trim(%EditW(SKU_to_Use:'0     '))
    ?C                   ExSr      CheckDigit
    ?C                   ExSr      Format_Desc
     C                   Eval      UPCSTAT    = 'A'
     C                   Eval      UPCCODE = %Int(
     C                                  %Trim(%EditW(UPC_Prefix:'0 '))
     C                                + %Trim(%EditW(Manufacturer:'0     '))
     C                                + %Trim(%EditW(SKU_to_Use:'0     '))
     C                                + %Trim(%EditW(Check_Digit:'0 '))       )
     C                   Eval      UPCPREF    = UPC_Prefix
     C                   Eval      UPCMANF    = Manufacturer
     C                   Eval      UPCSKU#    = SKU_to_Use
     C                   Eval      UPCCHKD    = Check_Digit
     C                   Eval      UPCITEM    = Passed_Item
     C                   Eval      UPCSIZE    = Passed_Size
     C                   Eval      UPCKPIN    = 'N'
     C                   Time                    UPCCRTD
     C                   Time                    UPCTIME
     C                   Eval      UPCUSER    = $User()
    ?C                   Write     RMUPC
     C                   EndIf
     C                   Eval      *InLR = *On
     C                   Return

      *?  ...........................................................
      *?  :      CheckDigit - Calculate the UPC Check Digit         :
      *?  :.........................................................:
    ?C     CheckDigit    BegSr                                                  ?

     C                   Eval      Odd = 3 *  ( UPC_11(01) +
     C                                          UPC_11(03) +
     C                                          UPC_11(05) +
     C                                          UPC_11(07) +
     C                                          UPC_11(09) +
     C                                          UPC_11(11) )

     C                   Eval      Even =     ( UPC_11(02) +
     C                                          UPC_11(04) +
     C                                          UPC_11(06) +
     C                                          UPC_11(08) +
     C                                          UPC_11(10) )

     C                   Eval      Check_DigitWK = 10 - %Rem((Even + Odd):10)
     C                   If        Check_DigitWK = 10
     C                   Eval      Check_DigitWK = 0
     C                   EndIf
     C                   Eval      Check_Digit = Check_DigitWK

    ?C                   EndSr

      *?  ...........................................................
      *?  :      Format_Desc  Format UPC Description                :
      *?  :.........................................................:
    ?C     Format_Desc   BegSr                                                  ?

     C                   Eval      Working_Desc =%Trim(Passed_Desc)
     C*                                  + ' ' + %Trim(Passed_Item)
     C*                                  + '-' + %Trim(Passed_Size)
     C                   MoveA     Working_Desc  DescWK
     C                   Eval      Desc_Break = *Zero
      *?  If Description is 24 Characters or less Use as is.
     C                   If        %Len(%Trim(Working_Desc)) < 16
     C                   Eval      UPCDES2    = Passed_Desc
     C                   Else
      *?  If Description is 25 Characters or more, Split into 2 lines.
      *?        Determine Length.
     C                   Eval      Desc_Len = %Len(%Trim(Working_Desc))
      *?        Determine the Middle. (This is the first Character of the second half)
     C                   Eval      Desc_Mid = %Int(Desc_Len/2) + 1
      *?        Starting at the middle of the description, find the nearest break position.
      *?           See if middle is Blank
     C                   If        DescWK(Desc_Mid) = ' '
     C                   Eval      Desc_Break = Desc_Mid
     C                   Else
      *?           Check After Middle
     C                   Eval      After_Pos = %Scan(' ':Working_Desc:Desc_Mid)
     C                   If        After_Pos = 0
     C                   Eval      After_Pos = 99
     C                   Else
     C                   Eval      After_Pos = After_Pos - Desc_Mid
     C                   EndIf
      *?           Check Before Middle
     C                   Eval      X = Desc_Mid - 1
     C                   DoU       X = 0 or DescWK(X) = ' '
     C                   Eval      X = X - 1
     C                   EndDo
     C                   Eval      Before_Pos = Desc_Mid - X
     C                   If        X = 0
     C                   Eval      Before_Pos = 99
     C                   EndIf
      *?           Use Whichever is Closer
     C                   If        Before_Pos < After_Pos
     C                   Eval      Desc_Break = Desc_Mid - Before_Pos
     C                   Else
     C                   If        After_Pos <>  99
     C                   Eval      Desc_Break = Desc_Mid + After_Pos
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C                   If        Desc_Break = *Zero
     C                   Eval      Desc_Break = Desc_Mid
     C                   EndIf
      *?        Format the two Description Lines
     C                   Eval      UPCDES1 = %Subst(Working_Desc:1:Desc_Break-1)
     C                   Eval      UPCDES2 =%Trim(%Subst(Working_Desc:Desc_Break
     C                                       :%Len(Working_Desc)-Desc_Break+1))
     C                   EndIf

    ?C                   EndSr

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *ENTRY        PList
    ?C                   Parm                    Passed_Item
    ?C                   Parm                    Passed_Size
    ?C                   Parm                    Passed_Desc
    ?C                   Parm                    SKU_to_Use

    ?C                   EndSr                                                  ?
