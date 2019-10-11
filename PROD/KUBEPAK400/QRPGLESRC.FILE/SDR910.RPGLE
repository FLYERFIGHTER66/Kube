    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *??:````````````````````````````````````````````````````````````:?
      *??:     Update Series prices from Upload File                  :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Jun. 2005            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program updates the Series Cost file FSERPRC       ?:
      *? : based on the uploaded data from FSERPRCUP.  This completes :
      *? : the automated seed pricing process.                       ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? : Subroutine ?-Subroutine Description                  ?  ?:
      *? :  *INZSR      -?Initialization Subroutine                  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? : Function   ?-Function Description                    ?  ?:
      *? :  $Date        ?Get Date Value                             ?:
      *? :  $DateMDY     ?Get Date Number in MM/DD/YY                ?:
      *? :  $Monday      ?Get Monday Date Value                      ?:
      *? :  $AddDate     ?Add/Subtract Days from Date                ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFSERPRCUP IP   E           K DISK
     FFSERPRC   UF A E           K DISK
     FFMVEND    IF   E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Now

      *? Data Structures

      *? Program Data Structure
     D                SDS
     D  PROGID                 1     10                                         ?PROGRAM NAME
     D  RLIBR                 81     90                                         ?RUN LIBRARY
     D  USERID               254    263                                         ?USER I.D.
     D  SLIBR                314    323                                         ?SOURCE LIBRARY

      *? Field Definitions
     D  CurrentKey     S             16A   Inz(*Blanks)
     D  LastKey        S             16A   Inz(*Blanks)

      *?  ...........................................................
      *?  :      C A L C U L A T I O N S                            :
      *?  :.........................................................:

     C                   Eval      CurrentKey = %Char(UPVEND) + UPCODE
    ?C     PriceKey      KList
    ?C                   KFld                    UPVEND
    ?C                   KFld                    UPCODE
    ?C     PriceKey      Chain     FSERPRC
     C                   If        CurrentKey <> LastKey
     C                             or not %Found(FSERPRC)
     C                   Clear                   RSERPRC
     C                   Eval      SPSTAT = 'A'                                 ?STATUS
     C                   Eval      SPCODE = UPCODE                              ?SERIES CODE
     C                   Eval      SPVEND = UPVEND                              ?VENDOR #
    ?C     UPVEND        Chain     FMVEND
     C                   Eval      SPVALP = VMLOOK                              ?VENDOR ALPHA
     C                   Eval      SPDTLA = $MDYDate($Date(0))                  ?DATE LAST UPDATE
     C                   Eval      SPTIME = $Now()                              ?TIME LAST UPDATE
     C                   Eval      SPUSER = $User()                             ?USER ID
     C                   Eval      LastKey = CurrentKey
     C                   EndIf
    ?C                   Select
      *?  Update Form 1
    ?C                   When      UPFORM = 1
     C                   Eval      SPPRC1 = UPRICE                              ?PRICE
     C                   Eval      SPPRO1 = UPPROZ                              ?PRICE PER/OZ
     C                   Eval      SPQTO1 = UPQTOZ                              ?QTY. PER/OZ
      *?  Update Form 2
    ?C                   When      UPFORM = 2
     C                   Eval      SPPRC2 = UPRICE                              ?PRICE
     C                   Eval      SPPRO2 = UPPROZ                              ?PRICE PER/OZ
     C                   Eval      SPQTO2 = UPQTOZ                              ?QTY. PER/OZ
      *?  Update Form 3
    ?C                   When      UPFORM = 3
     C                   Eval      SPPRC3 = UPRICE                              ?PRICE
     C                   Eval      SPPRO3 = UPPROZ                              ?PRICE PER/OZ
     C                   Eval      SPQTO3 = UPQTOZ                              ?QTY. PER/OZ
    ?C                   EndSL
     C                   Call      'SDR700'
     C                   Parm                    SPCODE
     C                   If        %Found(FSERPRC)
    ?C                   Update    RSERPRC
     C                   Else
    ?C                   Write     RSERPRC
     C                   EndIf
