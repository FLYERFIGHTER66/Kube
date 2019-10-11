    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*No)                                                           ?
    ?H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
    ?H DatFmt(*Usa)                                                             ?
      *??:````````````````````````````````````````````````````````````:?
      *??:        Employee Master File - Maintenance                  :?
      *??:............................................................:?

     FATT070FM  CF   E             WORKSTN
     FFMEMPLOY  UF A E           K DISK
     FFMEMPLOYF UF A E           K DISK    rename(RMEMPLOY:RMEMPLOYF)
     FFMEMPSUP  UF A E           K DISK
     FFMEMPXREF UF A E           K DISK
     FFMEMPXREFFUF A E           K DISK    rename(RMEMPXREF:RMEMPXREFF)

     D  Authorized     S               N
     D  BadCard        S               N
     D  BadFile        S               N
     D  Called         S               N
     D  $Temp          S             80A
     D  OldFile        S                   Like(NewFile)

    ?D/Copy QFunctDefn,$ERRMSG                                                  ?
    ?D/Copy QFunctDefn,$isDate@                                                 ?
    ?D/Copy QFunctDefn,$MDYDate                                                ?
    ?D/Copy QFunctDefn,$Date                                                    ?
    ?D/Copy QFunctDefn,$User                                                    ?

      *? Data Areas
     D ATT070DS        DS                  DTAARA(ATT070)
     D  NextFile@                     6A                                        ?Next Dft Emp File#

     D  NextFile#      S              6S 0                                      ?Next Dft Emp File#

     C     *INLR         DOUEQ     *ON                                          ?Program Loop

    ?C                   Select                                                 ?
    ?C     Screen        WhenEq    1                                            ?
    ?C                   ExSr      Edit01                                       ?
    ?C     Screen        WhenEq    2                                            ?
    ?C                   ExSr      Edit02                                       ?
    ?C                   EndSl                                                  ?

    ?C                   EndDo                                                  ?


      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C                   Write     Assume                                     ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     ATT07001                                     ?
     C                   ExSr      $ClrError                                     ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *?     Blank out the Class
     C                   Eval      EMFILE = *Zero
     C                   Eval      EMCARD = *Zero
     C                   Eval      Mode = 'Change'

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

      *? P R O C E S S   S C R E E N
     C                   SELECT                                                 ?
    ?C                   When      *In03 or *In07                               ?
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
    ?C                   When      *In05
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In06
     C                   Eval      Mode = 'Add'
     C                   ExSr      Load02
     C                   ExSr      Scrn02
    ?C                   When      EMFILE = *Zeros  and
    ?C                             EMCARD = *Zeros  and
    ?C                             SEARCH = *Blanks
     C                   Eval      $Err_MsgId = 'ATT0071'
     C                   ExSr      $SndError
     C                   ExSr      Scrn01
    ?C                   Other                                                  ?
      *? Edit Fields
     C                   Eval      BadFile = *Off
     C                   Eval      BadCard = *Off
    ?C     EMFILE        SetLL     FMEMPLOY
     C                   If        EMFILE <> *Zero and not %Equal(FMEMPLOY)
     C                   Eval      BadFile = *On
     C                   EndIf
    ?C                   Clear                   RMEMPXREF
    ?C     EMCARD        Chain     FMEMPXREF
    ?C     TXFILE        SetLL     FMEMPLOY
     C                   If        EMCARD <> *Zero and not %Equal(FMEMPLOY)
     C                   Eval      BadCard = *On
     C                   EndIf
    ?C                   Select                                                 ?
    ?C                   When      SEARCH <> *Blanks
     C                   Call      'ATT071'
     C                   Parm                    SEARCH
     C                   Parm                    EMFILE
     C                   Parm                    EMCARD
     C                   Eval      SEARCH = *Blanks
     C                   ExSr      Load02
     C                   ExSr      Scrn02
    ?C                   When      BadFile
     C                   Eval      $Err_MsgData = %Char(EMFILE)
     C                   Eval      $Err_MsgId = 'ATT0072'
     C                   ExSr      $SndError
     C                   ExSr      Scrn01
    ?C                   When      BadCard
     C                   Eval      $Err_MsgData = %Char(EMCARD)
     C                   Eval      $Err_MsgId = 'ATT0073'
     C                   ExSr      $SndError
     C                   ExSr      Scrn01
    ?C                   Other                                                  ?
    ?C                   ExSr      Load02
    ?C                   ExSr      Scrn02
    ?C                   EndSl
    ?C                   EndSl

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
     C                   If        Mode = 'Add'
     C                   Eval      *In26 = *On
     C                   Else
     C                   Eval      *In26 = *Off
     C                   EndIf
     C                   ExSr      LaborRate
    ?C                   Write     Assume                                     ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     ATT07002                                     ?
     C                   ExSr      $ClrError                                     ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

     C                   Eval      *In30 = *Off

     C                   If        Mode = 'Add'
      *?     Initialize the screen for *New Employee
     C                   Eval      EMSTAT = 'A'
     C     *Lock         In        ATT070DS
     C                   Move      NextFile@     NextFile#
     C                   Eval      EMFILE = NextFile#
     C                   Eval      NextFile# = NextFile# + 1
     C                   Move      NextFile#     NextFile@
     C                   Out       ATT070DS
     C                   Eval      *In30 = *On
     C                   Eval      EMCARD = *Zeros
     C                   Eval      EMLAST = *Blanks
     C                   Eval      EMFIRS = *Blanks
     C                   Eval      EMTITL = 'LABORER'
     C                   Eval      EMHIRE = $MDYDate($Date(0))
     C                   Eval      EMRHIR = *Zeros
     C                   Eval      EMCLAS = 'L3'

     C                   Else

     C                   If        EMFILE = *Zero
     C                   Eval      EMFILE = TXFILE
     C                   EndIf
    ?C     EMFILE        Chain     FMEMPLOY
    ?C     EMFILE        Chain     FMEMPSUP
     C                   If        %Found(FMEMPSUP)
     C                   Eval      *In60 = *On
     C                   Else
     C                   Eval      *In60 = *Off
     C                   EndIf
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

      *? P R O C E S S   S C R E E N
     C                   SELECT                                                 ?
    ?C                   When      *In03 or *In07                               ?
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
    ?C                   When      *In04 and not *In26
     C                   If        *In27
     C                   Eval      *In27 = *Off                                 ?
     C                   Eval      NewFile = *Zeros
     C                   Else
     C                   Eval      *In27 = *On                                  ?
     C                   EndIf
     C                   ExSr      Scrn02
    ?C                   When      *In06 and not Called
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In06 and Called
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
    ?C                   When      *In16 and *In60
    ?C                   Delete    RMEMPSUP
     C                   Eval      *In60 = *Off
     C                   ExSr      Scrn02
    ?C                   When      *In16 and not *In60
     C                   Eval      SPFILE = EMFILE
    ?C                   Write     RMEMPSUP
     C                   Eval      *In60 = *On
     C                   ExSr      Scrn02
    ?C                   When      *In23
    ?C                   Delete    RMEMPLOY
     C                   Eval      $Temp = (%Trim(EMLAST) + ', '+ %Trim(EMFIRS))
     C                   Eval      $Err_MsgData = %subst($Temp:1:25)
     C                   Eval      $Err_MsgId = 'ATT0074'
     C                   ExSr      $SndError
     C                   If        not Called
     C                   ExSr      Scrn01
     C                   Else
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
     C                   EndIf
    ?C                   Other                                                  ?
      *? Edit Fields
    ?C     NewFile       SetLL     FMEMPLOYF
    ?C                   Select                                                 ?
    ?C                   When      *In27 and %Equal(FMEMPLOYF)
     C                   Eval      $Err_MsgData = *Blanks
     C                   Eval      $Err_MsgId = 'ATT0075'
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   When      *In27 and NewFile = *Zeros
     C                   Eval      $Err_MsgData = 'New File Number'
     C                   Eval      $Err_MsgId = 'REQ0001'
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   When      EMLAST = *Blanks
     C                   Eval      $Err_MsgData = 'Employee Last Name'
     C                   Eval      $Err_MsgId = 'REQ0001'
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   When      EMFIRS = *Blanks
     C                   Eval      $Err_MsgData = 'Employee First Name'
     C                   Eval      $Err_MsgId = 'REQ0001'
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   When      EMFILE = *Zeros
     C                   Eval      $Err_MsgData = 'Employee File Number'
     C                   Eval      $Err_MsgId = 'REQ0001'
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   When      EMCARD = *Zeros
     C                   Eval      $Err_MsgData = 'Time Card Number'
     C                   Eval      $Err_MsgId = 'REQ0001'
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   When      EMTITL = *Blanks
     C                   Eval      $Err_MsgData = 'Job Title'
     C                   Eval      $Err_MsgId = 'REQ0001'
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   When      EMCLAS = *Blanks
     C                   Eval      $Err_MsgData = 'Job Class'
     C                   Eval      $Err_MsgId = 'REQ0001'
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   When      EMCLAS = '? ' or
    ?C                             EMCLAS = ' ?'
     C                   Call      'ATT051'
     C                   Parm                    EMCLAS
     C                   ExSr      Scrn02
    ?C                   Other                                                  ?
     C                   If        Mode = 'Add'
    ?C                   Write     RMEMPLOY
     C                   Else
     C                   If        *In27
     C                   Eval      OldFile = EMFILE
     C                   Eval      EMFILE = NewFile
     C                   EndIf
    ?C                   Update    RMEMPLOY
     C                   EndIf
    ?C     EMCARD        Chain     FMEMPXREF
     C                   Eval      TXFILE = EMFILE
     C                   Eval      TXUSER = $User()
     C                   Time                    TXDATE
     C                   Time                    TXTIME
     C                   If        not %Found(FMEMPXREF)
     C                   Eval      TXCARD = EMCARD
    ?C                   Write     RMEMPXREF
     C                   Else
    ?C                   Update    RMEMPXREF
     C                   EndIf
     C                   If        *In27
    ?C     OldFile       SetLL     FMEMPXREFF
    ?C     OldFile       ReadE     FMEMPXREFF
     C                   DoW       not %EOF(FMEMPXREFF)
     C                   Eval      TXFILE = NewFile
     C                   Eval      TXUSER = $User()
     C                   Time                    TXDATE
     C                   Time                    TXTIME
    ?C                   Update    RMEMPXREFF
    ?C     OldFile       ReadE     FMEMPXREFF
     C                   EndDo
     C                   EndIf
     C                   If        not Called
     C                   ExSr      Load01
     C                   ExSr      Scrn01
     C                   Else
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
     C                   EndIf
    ?C                   EndSl
    ?C                   EndSl

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      LaborRate                                          :
      *?  :.........................................................:
    ?C     LaborRate     BegSr                                                  ?

      /Free
        Exec SQL //  Get Rate for Labor Class
          Select LCBASE into :LCBASE from FMEMPCLS where LCCLAS = :EMCLAS;
      /End-Free

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      $ClrError - Clear Error Message Subfile            :
      *?  :      $SndError - Send an Error Message to the PGMMSGQ   :
      * ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
      *?  :.........................................................:
    ?C/Copy QFunctDefn,$ERRMSGSR                                                ?


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *Entry        PList                                                  ?
    ?C                   Parm                    EMFILE                         ?
    ?C                   Parm                    EMCARD                         ?

    ?C                   Call      'ATT040'                                     ?
    ?C                   Parm                    Authorized
     C                   If        not Authorized
     C                   Eval      *InH1 = *On
     C                   Return
     C                   EndIF

     C                   Eval      $ERR_PROG  = 'ATT070'                        ?Pgm Msg Queue
     C                   Eval      $ERR_MSGF  = 'KPMSGF'                        ?Message File
     C                   Eval      $ERR_LIBR   = '*LIBL'                        ?Library
     C                   ExSr      $ClrError

     C                   If        EMFILE <> *Zero or
     C                             EMCARD <> *Zero
     C                   Eval      Called = *On
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
     C                   Else
     C                   ExSr      Scrn01                                       ?
     C                   EndIf

    ?C                   EndSr                                                  ?
