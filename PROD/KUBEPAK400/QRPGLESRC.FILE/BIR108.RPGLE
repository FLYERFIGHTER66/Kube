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
      *? :  60      ?Color Blue - Already on this Order              ?:
      *? :  61      ?Color Red  - Order Deleted                      ?:
      *? :  63      ?DSPATR(HI) - Record matches Resow Ship Date     ?:
      *? :  70      ?Position Cursor                                 ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : Date    Int  Change Description                         ?:
      *? : 03/23/05 WB01 ?Add Ounces to Print Function               ?:
      *? :............................................................:

     FBIR108FM  CF   E             WORKSTN
     F                                     SFILE(BIR10801S:SFLRRN01)
     FFIORESOWSDIF   E           K DISK    Rename(RIORESOW:RIORESOWSD)
     FFIORESOWH IF   E           K DISK    Rename(RIORESOW:RIORESOWH )
     FFHORDR    IF   E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$AddDate

      *? Copy Book Features
    ?D/COPY QFunctDefn,$ErrMsg

      *? Program Data Structure
     D                SDS
     D   PgmID           *PROC

      *? Data Structures

      *? Field Definitions
     D  UserID         S             10A
     D  Temp           S                   like(OIRVDT)
     D  SelectDate     S                   like(OIRVDT)
     D  SelectOSDate   S                   like(OIOSDT)
     D  SelectFrom     S                   like(OIRVDT)
     D  SelectTo       S                   like(OIRVDT)
     D  Order#         S              6S 0
     D  Today          S              6S 0
     D  Monday         S               D
     D  ThisMonday     S               D
     D  MondayCYMD     S              7S 0
     D  SflRRN01       S              4S 0
     D  Errors         S               N
     D  InclHistory    S               N   Inz(*Off)
     D  X              S              5S 0
     D  PPMLkUp        S              4S 0
     D  Colors         S              5A
     D  Actions        C                   CONST('1=Display Order, 2=Change Ord-
     D                                     er')

      *? Arrays

      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
      *?  ...........................................................
      *?  :      M A I N   C A L C S                                :
      *?  :.........................................................:

     C                   ExSr      Load01
     C                   ExSr      Scrn01

     C                   DoW       *InLR <> *On
    ?C                   Select
    ?C     Screen        WhenEq    01
     C                   ExSr      Edit01
    ?C                   Other
     C                   Eval      *InLR = *On
    ?C                   EndSL
     C                   EndDo

      *?  ...........................................................
      *?  :      Load01   - Load Screen 01                          :
      *?  :.........................................................:

     C     Load01        BegSr

      *?  Clear the Subfile
    ?C                   Eval      *In25 = *Off                                 |Subfile Display
    ?C                   Eval      *In26 = *Off                                 |Subfile No Records
    ?C                   Eval      *In27 = *Off                                 |Subfile End
     C                   Eval      SflRRN01 = 0
     C                   Eval      SflRcds = *Zero
    ?C                   Write     BIR10801C

      *?  Load the Subfile
     C                   If        SELSHPDATE <> *Zeros
     C                   Eval      SelectDate =
     C                             $Date7($Monday($DateMDY(SELSHPDATE):'SAT'))
     C                   Eval      SELSHPDATE =
     C                             $MDYDate($Monday($DateMDY(SELSHPDATE):'SAT'))
     C                   Else
     C                   Eval      SelectDate = *Zeros
     C                   EndIf

     C                   If        SELORGDATE <> *Zeros
     C                   Eval      SelectOSDate =
     C                             $Date7($Monday($DateMDY(SELORGDATE):'SAT'))
     C                   Eval      SELORGDATE =
     C                             $MDYDate($Monday($DateMDY(SELORGDATE):'SAT'))
     C                   Else
     C                   Eval      SelectOSDate = *Zeros
     C                   EndIf

     C                   If        SelFrDATE <> *Zeros
     C                   Eval      SelectFrom = $Date7($DateMDY(SelFrDate))
     C                   Else
     C                   Eval      SelectFrom = *Zeros
     C                   EndIf

     C                   If        SELTODATE <> *Zeros
     C                   Eval      SelectTo   = $Date7($DateMDY(SELTODATE))
     C                   Else
     C                   Eval      SelectTo   = *Zeros
     C                   EndIf

     C                   If        InclHistory
    ?C     SelectOSDate  SetLL     FIORESOWH
    ?C                   Read      FIORESOWH
     C                   Else
    ?C     SelectOSDate  SetLL     FIORESOWSD
    ?C                   Read      FIORESOWSD
     C                   EndIf

     C                   DoW       not %Eof()

     C                   Eval      Temp =
     C                                $Date7($Monday($Date(OIRVDT):'SAT'))
      *?  Selection Criteria...  Omit these:
     C                   If
     C                                SelectDate <> 0                        and
     C                                SelectDate <>
     C                                $Date7($Monday($Date(OIRVDT):'SAT'))
     C                             or SelectOSDate <> 0                      and
     C                                SelectOSDate <>
     C                                $Date7($Monday($Date(OIOSDT):'SAT'))
     C                             or SelectFrom <> 0                        and
     C                                SelectFrom >  $Date7($Date(OIOSDT))
     C                             or SelectTo   <> 0                        and
     C                                SelectTo   <  $Date7($Date(OIOSDT))
     C                             or SELITEM <> *Blanks                     and
     C                                SELITEM <> %SUBST(OIITEM:1:5)
     C                             or SELSIZE <> *Blanks                     and
     C                                SELSIZE <> OISIZE
     C                             or SELALPHA <> *Blanks                    and
     C                                SELALPHA <> %SUBST(OIITMA:1:
     C                                %LEN(%TRIM(SELALPHA)))
     C                             or SELCUST <> *Zeros                      and
     C                                SELCUST <> OICUST
     C                             or SELORDER <> *Zeros                     and
     C                                SELORDER <> OIORD#

     C                   Else
     C                   Eval      *In61 = *Off
     C                   Eval      GoodOrder = 'Y'
    ?C     OIORD#        Chain     FHORDR
     C                   If        not %Found(FHORDR) or OHSTAT <> 'A'
     C                   Eval      *In61 = *On
     C                   Eval      GoodOrder = 'N'
     C                   EndIf
     C                   Eval      *In70    = *Off
     C                   Eval      ACTION   = *Blanks
     C                   Eval      ORGDATE  = $MDYDate($Date(OIOSDT))
     C                   Eval      SHPDATE  = $MDYDate($Date(OIRVDT))
     C                   Eval      ITEM5    = %SUBST(OIITEM:1:5)
     C                   Eval      DESC15   = OIITMA
     C                   If        OISTAT <> 'A'
     C                   Eval      *In60 = *On
     C                   Else
     C                   Eval      *In60 = *Off
     C                   EndIf

     C                   Eval      *In26 = *On                                  ?Subfile Has Records
     C                   Eval      SflRRN01 = SflRRN01 + 1
     C                   Eval      SflRcds = SflRRN01
    ?C                   Write     BIR10801S
     C                   EndIf
     C                   If        InclHistory
    ?C                   Read      FIORESOWH
     C                   Else
    ?C                   Read      FIORESOWSD
     C                   EndIf
     C                   EndDo

     C                   EndSr


      *?  ...........................................................
      *?  :      Scrn01   - Display Screen 01                       :
      *?  :.........................................................:

     C     Scrn01        BegSr

     C                   Z-Add     01            Screen            3 0          ?Screen  Number

    ?C                   Write     Assume                                       ?Clear Err Messages
    ?C                   Write     MSGCTL                                       ?Error Messages
    ?C                   Write     BIR10801F                                    ?Subfile Footer Rcd.
     C                   Eval      *In25 = *On                                  ?SubFile Display Ind
    ?C                   ExFmt     BIR10801C                                    ?Subfile Control Rcd
     C                   ExSr      $ClrError
     C                   Eval      *In25 = *Off                                 ?
     C                   If        SFLCSRRRN > 0
     C                   Eval      SFLPOSTO1 = SFLCSRRRN
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      Edit01   - Edit Screen 01                          :
      *?  :.........................................................:

     C     Edit01        BegSr

      *?  Pre Subfile Edit Functions (Does not redisplay Screen)
    ?C                   Select
    ?C                   When      *In12 or *In03
     C                   ExSr      ExitSR
    ?C                   Other
      *?  Edit Subfile Options (Check Options)
     C                   ExSr      EdtS01
      *?  Post Subfile Edit Functions (Redisplay Screen after Edits)
    ?C                   Select
    ?C                   When      Errors
     C                   ExSr      Scrn01
    ?C                   When      *In08
     C                   If        InclHistory
     C                   Eval      InclHistory = *Off
     C                   Eval      *In30       = *Off
     C                   Else
     C                   Eval      InclHistory = *On
     C                   Eval      *In30       = *On
     C                   EndIf
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In09
     C                   If        SELORGDATE = *Zeros
     C                   Eval      SELORGDATE = $MDYDate(Monday)
     C                   Else
     C                   Eval      SELORGDATE =
     C                             $MDYDate($AddDate($DateMDY(SELORGDATE):-7))
     C                   EndIf
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In10
     C                   If        SELORGDATE = *Zeros
     C                   Eval      SELORGDATE = $MDYDate(Monday)
     C                   Else
     C                   Eval      SELORGDATE =
     C                             $MDYDate($AddDate($DateMDY(SELORGDATE):7))
     C                   EndIf
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   Other
      *?  No Function Keys used ==> User Pressed Enter ==> Update file
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   EndSL
    ?C                   EndSL

     C                   EndSr


      *?  ...........................................................
      *?  :      EdtS01 - Edit Subfile 01                           :
      *?  :.........................................................:

     C     EdtS01        BegSr

     C                   Eval      Errors = *Off
     C                   If        *In26
    ?C                   ReadC     BIR10801S                                    ?Changed Records
     C                   DoW       not %EOF(BIR108FM)
     C                   Eval      *In70 = *Off
    ?C                   Select
    ?C                   When      Action <> ' ' and
    ?C                             Action <> '1' and
    ?C                             Action <> '2'
     C                   Eval      $ERR_MsgID = 'SFL0001'
     C                   Eval      $ERR_MsgData = Action + ' ' + Actions
     C                   ExSr      $SndError
     C                   Eval      Errors = *On
     C                   Eval      *In70 = *On
     C                   Eval      *In51 = *On
    ?C                   When      Action = '1' and GoodOrder = 'N' or
    ?C                             Action = '2' and GoodOrder = 'N'
     C                   Eval      Order# = OIORD#
     C                   Eval      $ERR_MsgID = 'OE10802'
     C                   Eval      $ERR_MsgData = *Blanks
     C                   MoveL     Order#        $ERR_MsgData
     C                   ExSr      $SndError
     C                   Eval      Errors = *On
WHT  C                   Eval      *In70 = *On                                  |Position Cursor
WHT  C                   Eval      *In51 = *On                                  |Error Indicator
WHT  C                   Eval      *In61 = *On                                  |Color RED
    ?C                   When      Action = '1'
     C                   Call      'BIR255CLO'
     C                   Parm                    OIORD#
    ?C                   When      Action = '2'
     C                   Call      'BIR100CLO'
     C                   Parm                    OIORD#
     C                   Parm                    OISEQ#
    ?C                   EndSL
     C                   If        not *In70
     C                   Eval      Action = *Blanks
     C                   Else
     C                   Eval      *In28 = *On
     C                   EndIf
    ?C                   Update    BIR10801S
    ?C                   ReadC     BIR10801S                                    ?Changed Records
     C                   EndDo
     C                   EndIf

     C                   EndSr


    ? /Eject
    ?C*COPY QFunctDefn,$CommandSR
    ?D/COPY QFunctDefn,$ErrMsgSr


      *?  ...........................................................
      *?  :      ExitSR   - Exit Subroutine                         :
      *?  :.........................................................:

     C     ExitSr        BegSr

     C                   Eval      *InLR = *On
     C                   Return

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C                   Eval      Today = $MDYDate($Date(0))
     C                   Eval      UserID= $User()
     C                   Eval      Monday = $Monday($Date(0):'SAT')
     C                   Eval      ThisMonday = Monday
     C                   Eval      SFLPOSTO1 = 1
     C*                  Eval      SELSHPDATE = $MDYDate(Monday)
     C                   Eval      SELORGDATE = $MDYDate(Monday)

     C                   Eval      $ERR_PROG  = 'BIR108'                        ?Pgm Msg Queue
     C                   Eval      $ERR_MSGF  = 'KPMSGF'                        ?Message File
     C                   Eval      $ERR_LIBR   = '*LIBL'                        ?Library

     C                   EndSR
