    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

     FFMCUSTZC  UP   E           K DISK
     FFMZIPSZC  IF   E           K DISK

     D  ZipKey         S                   like(ZMZIP)
     D  SAV_CMZIP      S                   like(CMZIP)
     D  TestZip        S                   like(CMZIP)
     D  NewFreightZn   S                   like(CMUPSZ)
     D  OvrFreightZn   S                   like(CMUPSZ)

     C                   Eval      OvrFreightZn = ' '
    ?C                   Select
    ?C                   When      CMUPSZ = '1'
     C                   Eval      OvrFreightZn = 'Z'
    ?C                   When      CMUPSZ = '2'
     C                   Eval      OvrFreightZn = '1'
    ?C                   When      CMUPSZ = '3'
     C                   Eval      OvrFreightZn = '2'
    ?C                   When      CMUPSZ = '4'
     C                   Eval      OvrFreightZn = '3'
    ?C                   When      CMUPSZ = '5'
     C                   Eval      OvrFreightZn = '4'
    ?C                   Other
      *? If Processing New Zip, First Calculate 'New Freight Zone'

     C                   If        CMZIP <> Sav_CMZIP
     C                   Eval      NewFreightZn = 'W'                           ?Blank Zip Code
     C                   Eval      Sav_CMZIP = CMZIP

     C                   Eval      TestZip = *Blanks
     C                   Eval      %Subst(TestZip:10-%Len(%Trim(CMZIP)):
     C                                      %Len(%Trim(CMZIP))) = %Trim(CMZIP)
     C                   TESTN                   TestZip              6060

     C                   If        *In60 = *On                                  ?i.e. Zip is Numeric

     C                   If        %Int(%trim(CMZIP)) <= 99999
     C                   Eval      ZipKey = %Int(%trim(CMZIP))
     C                   Else
     C                   Eval      ZipKey = %Int(%trim(%Subst(CMZIP:1:5)))
     C                   EndIf

     C                   Else
     C                   Eval      ZipKey = 99999
     C                   EndIf

    ?C     ZipKey        Chain     FMZIPSZC
     C                   If        %Found(FMZIPSZC)
    ?C                   Select
    ?C                   When      ZMMILE >=   0 and ZMMILE <  26
     C                   Eval      NewFreightZn = 'A'                           ?  0 to  26
    ?C                   When      ZMMILE >=  26 and ZMMILE <  51
     C                   Eval      NewFreightZn = 'B'                           ? 26 to  51
    ?C                   When      ZMMILE >=  51 and ZMMILE <  76
     C                   Eval      NewFreightZn = 'C'                           ? 51 to  76
    ?C                   When      ZMMILE >=  76 and ZMMILE < 101
     C                   Eval      NewFreightZn = 'D'                           ? 76 to 101
    ?C                   When      ZMMILE >= 101 and ZMMILE < 126
     C                   Eval      NewFreightZn = 'E'                           ?101 to 126
    ?C                   When      ZMMILE >= 126 and ZMMILE < 151
     C                   Eval      NewFreightZn = 'F'                           ?126 to 151
    ?C                   When      ZMMILE >= 151 and ZMMILE < 176
     C                   Eval      NewFreightZn = 'G'                           ?151 to 176
    ?C                   When      ZMMILE >= 176 and ZMMILE < 201
     C                   Eval      NewFreightZn = 'H'                           ?176 to 201
    ?C                   When      ZMMILE >= 201 and ZMMILE < 226
     C                   Eval      NewFreightZn = 'I'                           ?201 to 226
    ?C                   When      ZMMILE >= 226 and ZMMILE < 251
     C                   Eval      NewFreightZn = 'J'                           ?226 to 251
    ?C                   When      ZMMILE >= 251 and ZMMILE < 276
     C                   Eval      NewFreightZn = 'K'                           ?251 to 276
    ?C                   When      ZMMILE >= 276 and ZMMILE < 301
     C                   Eval      NewFreightZn = 'L'                           ?276 to 301
    ?C                   When      ZMMILE >= 301 and ZMMILE < 326
     C                   Eval      NewFreightZn = 'M'                           ?301 to 326
    ?C                   When      ZMMILE >= 326 and ZMMILE < 351
     C                   Eval      NewFreightZn = 'N'                           ?326 to 351
    ?C                   When      ZMMILE >= 351 and ZMMILE < 376
     C                   Eval      NewFreightZn = 'O'                           ?351 to 376
    ?C                   When      ZMMILE >= 376 and ZMMILE < 401
     C                   Eval      NewFreightZn = 'P'                           ?376 to 401
    ?C                   When      ZMMILE >= 401 and ZMMILE < 426
     C                   Eval      NewFreightZn = 'Q'                           ?401 to 426
    ?C                   When      ZMMILE >= 426 and ZMMILE < 501
     C                   Eval      NewFreightZn = 'R'                           ?426 to 501
    ?C                   When      ZMMILE >= 501 and ZMMILE < 600
     C                   Eval      NewFreightZn = 'S'                           ?501 to 600
    ?C                   Other
     C                   Eval      NewFreightZn = 'X'                           ?Out of Range
    ?C                   EndSl
     C                   Else
     C                   Eval      NewFreightZn = 'Y'                           ?Zip Not Found
     C                   EndIf


     C                   EndIf
      *? Next, update all customer master records with appropriate Freight Zone
    ?C                   EndSl
     C                   If        CMUPSZ <> NewFreightZn or
     C                             CMUPSZ <> OvrFreightZn
     C                   Eval      CMUPSZ =  NewFreightZn
     C                   If        OvrFreightZn <> ' '
     C                   Eval      CMUPSZ =  OvrFreightZn
     C                   EndIf
    ?C                   Update    RMCUST
     C                   EndIf
