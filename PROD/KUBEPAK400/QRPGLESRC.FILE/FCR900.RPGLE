    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *?                                                              ?
      *??|                                                            |?
      *??|       Chemical Mixture Calculations                        |?
      *?|                                                            |?

      **PROGRAM NAME-------- FCR900
      **PROGRAMMER---------- WJB
      *
      *            CHANGE--DATE-------DESCRIPTION
      *   9/26/08  WJB  Initial Programming
      *
      *
     FFFCMPPM   IF   E           K DISK
      *
      ** CONTROL FILE ARRAYS
     D PM              S              7  2 DIM(45) CTDATA ASCEND                PPM
     D OZ              S              7  3 DIM(45)                              OZ/GAL
     D ML              S              7  3 DIM(45)                              ML/GAL
      *

      * PROG DATA STRUCTURE *
     D                SDS
     D  PROGID                 1     10
     D  RLIBR                 81     90
     D  USERID               254    263
     D  SLIBR                314    323

     D  X              S              2S 0

      * PROG DATA STRUCTURE *
     D CMOZDS          DS
     D  CMOZ1
     D  CMOZ2
     D  CMOZ3
     D  CMOZ4
     D  CMOZ5
     D  CMOZ6
     D  CMOZ7
     D  CMOZ8
     D  CMOZ9
     D  CMOZ10
     D  CMOZ11
     D  CMOZ12
     D  CMOZ13
     D  CMOZ14
     D  CMOZ15
     D  CMOZ16
     D  CMOZ17
     D  CMOZ18
     D  CMOZ19
     D  CMOZ20
     D  CMOZ21
     D  CMOZ22
     D  CMOZ23
     D  CMOZ24
     D  CMOZ25
     D  CMOZ26
     D  CMOZ27
     D  CMOZ28
     D  CMOZ29
     D  CMOZ30
     D  CMOZ31
     D  CMOZ32
     D  CMOZ33
     D  CMOZ34
     D  CMOZ35
     D  CMOZ36
     D  CMOZ37
     D  CMOZ38
     D  CMOZ39
     D  CMOZ40
     D  CMOZ41
     D  CMOZ42
     D  CMOZ43
     D  CMOZ44
     D  CMOZ45
     D  CMOZ                               Dim(45) Like(CMOZ1) OverLay(CMOZDS)

     D CMMLDS          DS
     D  CMML1
     D  CMML2
     D  CMML3
     D  CMML4
     D  CMML5
     D  CMML6
     D  CMML7
     D  CMML8
     D  CMML9
     D  CMML10
     D  CMML11
     D  CMML12
     D  CMML13
     D  CMML14
     D  CMML15
     D  CMML16
     D  CMML17
     D  CMML18
     D  CMML19
     D  CMML20
     D  CMML21
     D  CMML22
     D  CMML23
     D  CMML24
     D  CMML25
     D  CMML26
     D  CMML27
     D  CMML28
     D  CMML29
     D  CMML30
     D  CMML31
     D  CMML32
     D  CMML33
     D  CMML34
     D  CMML35
     D  CMML36
     D  CMML37
     D  CMML38
     D  CMML39
     D  CMML40
     D  CMML41
     D  CMML42
     D  CMML43
     D  CMML44
     D  CMML45
     D  CMML                               Dim(45) Like(CMML1) OverLay(CMMLDS)

    ?C     *Entry        PList
    ?C                   Parm                    PItem            12             Chemical Item #
    ?C                   Parm                    PSize             3             Chemical Size (700)
    ?C                   Parm                    PPPM              7 2           Concentration
    ?C                   Parm                    PGAL              6 2           Number of Gallons
    ?C                   Parm                    POZ               9 3           OZ of Chemical
    ?C                   Parm                    POZG              7 3           OZ/Gallon
    ?C                   Parm                    PML               9 3           ML of Chemical
    ?C                   Parm                    PMLG              7 3           ML/Gallon

    ?C     ChemItem      KList
    ?C                   KFld                    PItem
    ?C                   KFld                    PSize

    ?C     ChemItem      Chain     FFCMPPM

     C                   If        Not %Found(FFCMPPM)
     C                   Eval      POZ    = *Zero
     C                   Eval      POZG   = *Zero
     C                   Eval      PML    = *Zero
     C                   Eval      PMLG   = *Zero
     C                   Else

      *? If exact PPM is found, use that
     C                   Eval      X = 1
    ?C     PPPM          Lookup    PM(X)                                  90
     C                   If        %Equal()
     C                   Eval      POZ  = CMOZ(X) * PGAL
     C                   Eval      POZG = CMOZ(X)
     C                   Eval      PML  = CMML(X) * PGAL
     C                   Eval      PMLG = CMML(X)
     C                   Else
      *? If exact PPM is not found, use highest PPM found and do the math.
     C                   Eval      X = 45
     C                   DoU       CMOZ(X) > 0 or
     C                             CMML(X) > 0

     C                   Eval      POZ  = CMOZ(X) * PGAL * (PPPM/PM(X))
     C                   Eval      POZG = CMOZ(X)        * (PPPM/PM(X))
     C                   Eval      PML  = CMML(X) * PGAL * (PPPM/PM(X))
     C                   Eval      PMLG = CMML(X)        * (PPPM/PM(X))

     C                   Eval      X = X - 1
     C                   EndDo
     C                   EndIf

     C                   EndIf

     C                   Eval      *InLR = *On
     C                   Return
**
0000100
0000200
0000300
0000400
0000500
0000600
0000700
0000800
0000900
0001000
0001500
0002000
0002500
0003000
0003500
0004000
0004500
0005000
0010000
0015000
0020000
0025000
0030000
0035000
0040000
0045000
0050000
0055000
0060000
0065000
0070000
0075000
0080000
0085000
0090000
0095000
0100000
0150000
0200000
0250000
0300000
0350000
0400000
0450000
0500000
