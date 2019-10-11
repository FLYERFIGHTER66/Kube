    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *??:````````````````````````````````````````````````````````````:?
      *??:     Insert Lines / Resequence Orders                       :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Mar. 2005            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program provides the ability to insert new lines   ?:
      *? : into an existing order.  The calling program must pass    ?:
      *? : the Order Number, where to start, and number of lines.    ?:
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

     FFIORDR    UF A E           K DISK
     FFIOROY    UF A E           K DISK
     FFIORDRWK  UF A E           K DISK    Prefix(WK_)
     FFIORESOW  UF A E           K DISK    Prefix(OO_)
     F                                     Rename(RIORESOW:ResowReq)
     FFIORESOWROUF A E           K DISK    Prefix(RO_)
     F                                     Rename(RIORESOW:ResowOrder)
     FFIORDRPARTUF A E           K DISK
     FFALITEM   UF A E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$MDYDate

      *? Data Structures
     D                SDS                                                       ?
     D    ProgID         *PROC                                                  ?Program Name

      *? Array Definitions
     D  OldSeq#        S                   Like(OISEQ#) Dim(900)                ?Original Sequence
     D  NewSeq#        S                   Like(OISEQ#) Dim(900)                ?New Sequence Number

      *? Field Definitions
     D  UserID         S             10A                                        ?
     D  Today          S              6S 0                                      ?
     D  CountSeq       S                   Like(OISEQ#)                         ?
     D  Order          S                   Like(OIORD#)                         ?
     D  StartLine      S                   Like(OISEQ#)                         ?
     D  Insert         S                   Like(OISEQ#)                         ?
     D  Sequence       S                   Like(OISEQ#)                         ?

      *? Indicators
     D  FirstLine      S               N   Inz(*On)                             ?

      *?   Count from the starting Sequence number to the end and
      *?   determine how many Order Detail records need to changed.
      *?   ( The Start Line is the first line included in the resequencing )
    ?C     OrderStart    SetLL     FIORDR
    ?C     Order         ReadE     FIORDR
     C                   DoW       not %EOF(FIORDR)
      *?   Do not include any records whose Seq # > 900 nor = 1
     C                   If        OISEQ# < 900 and OISEQ# <> 1
     C                   If        FirstLine
     C                   Eval      StartLine = OISEQ#
     C                   Eval      FirstLine = *Off
     C                   EndIf
     C                   Eval      CountSeq = CountSeq + 1
     C                   Eval      OldSeq#(CountSeq) = OISEQ#
     C                   Eval      NewSeq#(CountSeq) = OISEQ# + Insert
     C                   EndIf
    ?C     Order         ReadE     FIORDR
     C                   EndDo

      *?   Beginning from the end of the file, renumber all
      *?   Sequence numbers back to and including the Start Line.
     C                   DoW       CountSeq > 0
     C                   Eval      Sequence = OldSeq#(CountSeq)
    ?C     OrderSeq      Chain     FIORDR
     C                   If        %Found(FIORDR)
     C                   Eval      OISEQ# = NewSeq#(CountSeq)
     C                   Eval      Sequence = OISEQ#
    ?C     OrderSeq      SetLL     FIORDR
     C                   If        %Equal(FIORDR)
     C                   Eval      *InH1 = *On
     C                   Else
      *?  This Sequence Number is good to be resequenced...  add logic HERE for other files.
     C                   Eval      Sequence = OldSeq#(CountSeq)
      *?    Chain to File(s)
    ?C     OrderSeq      Chain     FIORDR
    ?C     OrderSeq      Chain     FIOROY                             30
    ?C     OrderSeq      Chain     FIORDRWK                           31
     C                   If        OICUST = 1990
    ?C     OrderSeq      Chain     FIORESOWRO                         32
     C                   Else
    ?C     OrderSeq      Chain     FIORESOW                           32
     C                   EndIf
    ?C     OrderSeq      Chain     FIORDRPART                         33
    ?C     OrderSeq      Chain     FALITEM                            34
      *?    Asign new Sequence Number
     C                   Eval      OISEQ# = NewSeq#(CountSeq)
     C                   Eval      WK_OISEQ# = NewSeq#(CountSeq)
     C                   Eval      ORSEQ# = NewSeq#(CountSeq)
     C                   Eval      AIOSEQ = NewSeq#(CountSeq)
      *?    Update with new Sequence Number
      *?      30 - FIORDR
    ?C  N30              Update    RIOROY
      *?      31 - FIORDRWK
    ?C  N31              Update    RIORDRWK
      *?      32 - FIORESOWRO or FIORESOW
     C                   If        OICUST = 1990
     C                   Eval      RO_OIRSEQ = NewSeq#(CountSeq)
    ?C  N32              Update    ResowOrder
     C                   Else
     C                   Eval      OO_OISEQ# = NewSeq#(CountSeq)
    ?C  N32              Update    ResowReq
     C                   EndIf
    ?C                   Update    RIORDR
      *?      33 - FIORRDPART
    ?C  N33              Update    RIORDRPART
      *?      34 - FALITEM
    ?C  N34              Update    RALITEM
     C                   EndIf
     C                   EndIf
     C                   Eval      CountSeq = CountSeq - 1
     C                   EndDo

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

    ?C     *Entry        PList
    ?C                   Parm                    Order                          Order Number
    ?C                   Parm                    StartLine                      Order Seq# to Start
    ?C                   Parm                    Insert                         Lines to Insert

    ?C     OrderStart    KList
    ?C                   Kfld                    Order                          ?Order Number
    ?C                   KFld                    StartLine                      ?Order Seq# to Start

    ?C     OrderSeq      KList
    ?C                   Kfld                    Order                          ?Order Number
    ?C                   KFld                    Sequence                       ?Order Seq#

     C                   Eval      Today = $MDYDate($Date(0))
     C                   Eval      UserID= $User()

     C                   EndSR
