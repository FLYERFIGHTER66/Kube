    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *??:````````````````````````````````````````````````````````````:?
      *??:     Assign People to Apply Chemicals                       :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Dec. 2004            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program replaces CHR060.  This program allows      ?:
      *? : the growers to make Chem. Application Assignments to the  ?:
      *? : people spraying.                                          ?:
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

     FFCSECT01FMCF   E             WORKSTN
     F                                     SFILE(SECT0101S:SFLRRN01)
     FFCSECT    UF A E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$ChgPrt
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,$Command

    ? /Copy QFunctDefn,$ErrMsg

      *? Data Structures
     D                SDS
     D $Program          *Proc

      *? Array Definitions

      *? Field Definitions
     D  UserID         S             10A                                        ?
     D  Today          S              6S 0                                      ?
     D  Screen         S              3S 0                                      ?Current Screen
     D  LastScreen     S              3S 0                                      ?Previous Screen
     D  SflRRN01       S              4S 0                                      ?Subfile RRN Scrn01
     D  RRN            S                   Like(SflRRN01)                       ?Loop Counter for SF
     D  X              S              5S 0                                      ?Generic Counter Fld

      *? Indicators
     D  FoundPos2      S               N                                        ?Found Pos2 Search

    ? /Eject
      *?  ...........................................................
      *?  :              C A L C U L A T I O N S                    :
      *?  :.........................................................:

     C                   DoW       *InLR <> *On
    ?C                   Select
    ?C     Screen        WhenEq    01
     C                   ExSr      Edit01
    ?C                   Other
     C                   Eval      *InLR = *On
    ?C                   EndSL
     C                   EndDo


    ? /Eject
      *?  ...........................................................
      *?  :      Load01   - Load Screen 01                          :
      *?  :.........................................................:

     C     Load01        BegSr

     C                   Eval      SflPosTo1 = 1
      *? Clear the Subfile
    ?C                   Eval      *In25 = *Off                                 |Subfile Display
    ?C                   Eval      *In26 = *Off                                 |Subfile No Records
    ?C                   Eval      *In27 = *Off                                 |Subfile End
     C                   Eval      SflRRN01 = 0
    ?C                   Write     SECT0101C

     C                   Eval      SflRcds1 = *Zero

      *? Get the Greenhouse Description records
     C                   Eval      SflRcds1 = *Zero
    ?C     *LoVal        SetLL     FCSECT
    ?C                   Read      FCSECT

     C                   DoW       not %Eof(FCSECT)

     C                   Eval      S1GHOUSE = GHOUSE
     C                   Eval      S1GHSECT = GHSECT
     C                   Eval      S1GHBAY  = GHBAY
     C                   Eval      S1GHNORS = GHNORS
     C                   Eval      S1GHEORW = GHEORW
     C                   Eval      S1GHPOLS = GHPOLS
     C                   Eval      S1GHTRAY = GHTRAY
     C                   Eval      S1GHWIDE = GHWIDE
     C                   Eval      S1GHLNTH = GHLNTH
     C                   Eval      S1GHUSED = GHUSED
     C                   Eval      SHORTNOTE= %SUBST(GHNOTE:1:%Len(SHORTNOTE))
     C                   Eval      S1GHNOTE = GHNOTE

    ?C                   Eval      *In26 = *On                                  |Subfile Has Records
     C                   Eval      SflRRN01 = SflRRN01 + 1
    ?C                   Read      FCSECT
     C                   If        %Found(FCSECT)
WHT  C                   Eval      *In27 = *Off                                 |SFLEND Indicator
     C                   Else
WHT  C                   Eval      *In27 = *On                                  |SFLEND Indicator
     C                   EndIf
     C                   ExSr      Colors

    ?C                   Write     SECT0101S
     C                   Eval      SflRcds1 = SflRcds1 + 1
     C                   EndDo

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Load02   - Load Screen 02                          :
      *?  :.........................................................:

     C     Load02        BegSr

      *? Load the Button Values

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Scrn01   - Display Screen 01                       :
      *?  :.........................................................:

     C     Scrn01        BegSr

     C                   Eval      LastScreen =  Screen                         ?Previous Screen
     C                   Eval      Screen = 01                                  ?Screen  Number

    ?C                   Write     Assume
    ?C                   Write     MSGCTL
    ?C                   Write     SECT0101F
     C                   Eval      *In25 = *On                                  ?SubFile Display
    ?C                   ExFmt     SECT0101C
WHT  C                   ExSr      $ClrError                                    |Clear Error Message
     C                   Eval      *In25 = *Off                                 ?
     C                   If        SFLCSRRRN1 > 0
     C                   Eval      SFLPOSTO1 = SFLCSRRRN1
     C                   EndIf

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Scrn02   - Display Screen 02                       :
      *?  :.........................................................:

     C     Scrn02        BegSr

     C                   Eval      LastScreen =  Screen                         ?Previous Screen
     C                   Eval      Screen = 02                                  ?Screen  Number

    ?C*                  ExFmt     SECT0102

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Edit01   - Edit Screen 01                          :
      *?  :.........................................................:

     C     Edit01        BegSr

    ?C                   Select
      *?  Update
    ?C                   When      *In01
     C                   ExSr      Updates
     C                   ExSr      Load01
     C                   ExSr      Scrn01
      *?  Exit (no update)
    ?C                   When      *In03
     C                   Eval      *InLR = *On
      *?  Refresh
    ?C                   When      *In05
     C                   ExSr      Load01
     C                   ExSr      Scrn01
      *?  Valid Position to:
WHT ?C                   When      Pos2Sect  <> 0 or                            |
WHT ?C                             Pos2House <> 0 or                            |
WHT ?C                             Pos2Sect  <> 0 and Pos2Bay <> 0 or           |
WHT ?C                             Pos2House <> 0 and Pos2Bay <> 0              |
     C                   ExSr      Position2
     C                   ExSr      Scrn01
      *?  Invalid Position to:
WHT ?C                   When      Pos2Bay <> 0 and Pos2Sect  = 0 or            |
WHT ?C                             Pos2Bay <> 0 and Pos2House = 0               |
     C                   Eval      $ERR_MsgId   = 'MFM0101'
     C                   Eval      $ERR_MsgData = *Blanks
     C                   ExSr      $SndError
     C                   ExSr      Scrn01
    ?C                   Other
     C                   ExSr      Scrn01
    ?C                   EndSl

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Edit02   - Edit Screen 02                          :
      *?  :.........................................................:

     C     Edit02        BegSr

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Colors - Set Display colors for Subfile Records    :
      *?  :.........................................................:

     C     Colors        BegSr

     C                   SetOff                                       505152
     C                   If        S1GHUSED <> 'Y'
     C                   Eval      *In51 = *On                                  ?Pnk - Low % Rate
     C                   EndIf

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Position2 - Position the subfile to selected place :
      *?  :.........................................................:

     C     Position2     BegSr

     C                   Eval      FoundPos2 = *Off
      *?  Read through all subfile records to find selected
     C                   Eval      RRN = 1
    ?C     RRN           Chain     SECT0101S
     C                   DoW       %Found(FCSECT01FM)
     C                             and not FoundPos2

    ?C                   Select
    ?C                   When
      *?  Position to Greenhouse, Section and Bay
    ?C                             Pos2House <> 0 and
    ?C                             Pos2Sect  <> 0 and
    ?C                             Pos2Bay   <> 0 and
    ?C                             Pos2House =  S1GHOUSE and
    ?C                             Pos2Sect  =  S1GHSECT and
    ?C                             Pos2Bay   =  S1GHBAY
    ?C                             or
      *?  Position to Greenhouse and Bay
    ?C                             Pos2House <> 0 and
    ?C                             Pos2Sect  =  0 and
    ?C                             Pos2Bay   <> 0 and
    ?C                             Pos2House =  S1GHOUSE and
    ?C                             Pos2Bay   =  S1GHBAY
    ?C                             or
      *?  Position to Section and Bay
    ?C                             Pos2House =  0 and
    ?C                             Pos2Sect  <> 0 and
    ?C                             Pos2Bay   <> 0 and
    ?C                             Pos2Sect  =  S1GHSECT and
    ?C                             Pos2Bay   =  S1GHBAY
    ?C                             or
      *?  Position to Greenhouse
    ?C                             Pos2House <> 0 and
    ?C                             Pos2Sect  =  0 and
    ?C                             Pos2Bay   =  0 and
    ?C                             Pos2House =  S1GHOUSE
    ?C                             or
      *?  Position to Section
    ?C                             Pos2House =  0 and
    ?C                             Pos2Sect  <> 0 and
    ?C                             Pos2Bay   =  0 and
    ?C                             Pos2Sect  =  S1GHSECT
     C                   Eval      FoundPos2 = *On
     C                   Eval      SFLPOSTO1 = RRN

    ?C                   Other
     C                   Eval      RRN = RRN + 1
    ?C     RRN           Chain     SECT0101S
    ?C                   EndSl
     C                   EndDo

     C                   If        not FoundPos2
     C                   ExSr      $ClrError
     C                   Eval      $ERR_MsgId   = 'MFM0102'
     C                   Eval      $ERR_MsgData = *Blanks
     C                   ExSr      $SndError
     C                   EndIf

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Updates  - Update the Chemical Application File    :
      *?  :.........................................................:

     C     Updates       BegSr

      *?  Read through all changed subfile records
     C                   ReadC     SECT0101S
     C                   DoW       not %EOF(FCSECT01FM)

      *?  Update the Greenhouse Dsecriptions
    ?C     SectKey       Chain     FCSECT
     C                   Eval      GHOUSE = S1GHOUSE
     C                   Eval      GHSECT = S1GHSECT
     C                   Eval      GHBAY  = S1GHBAY
     C                   Eval      GHNORS = S1GHNORS
     C                   Eval      GHEORW = S1GHEORW
     C                   Eval      GHPOLS = S1GHPOLS
     C                   Eval      GHTRAY = S1GHTRAY
     C                   Eval      GHWIDE = S1GHWIDE
     C                   Eval      GHLNTH = S1GHLNTH
     C                   Eval      GHUSED = S1GHUSED
     C                   Eval      GHNOTE = S1GHNOTE
     C                   If        %Found(FCSECT)
    ?C                   Update    RMSECT
     C                   Else
    ?C                   Write     RMSECT
     C                   EndIf

     C                   ReadC     SECT0101S
     C                   EndDo

     C                   EndSr

    ? /Eject
    ?C/COPY QFunctDefn,$CommandSR


    ? /Eject
      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

    ?C     SectKey       KLIST
    ?C                   KFLD                    S1GHSECT
    ?C                   KFLD                    S1GHBAY
    ?C                   KFLD                    S1GHNORS
    ?C                   KFLD                    S1GHEORW

     C                   Eval      Today = $MDYDate($Date(0))
     C                   Eval      UserID= $User()
     C                   Eval      $ERR_Prog = $Program
     C                   Eval      $ERR_Libr = '*LIBL'
     C                   Eval      $ERR_MsgF = 'KPMSGF'
     C                   ExSr      Load01
     C                   ExSr      Scrn01

     C                   EndSR
    ? /Copy QFunctDefn,$ErrMsgSR
