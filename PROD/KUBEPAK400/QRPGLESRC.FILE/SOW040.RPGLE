    ?H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:         Sow Confirmation Scanning                          :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Sep. 2004            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program allows item sow on the recip machines to   ?:
      *? : be scanned as having been sow.  Formerly, recip type trays?:
      *? : where marked as sown as soon as they were prefilled.      ?:
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
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FSOW040FM  CF   E             WORKSTN
     FFMEMPLOY  IF   E           K DISK

      *?  LDA
     D                UDS

      *? Fields
     D  Scan#          S              8S 0
     D  LabCnt         S              3S 0 Inz(75)

      *? Indicators

      *? Function Prototypes
    ?D/COPY QFunctDefn,$PrtUsrLab
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date8
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

    ?
     C                   DoW       not *InLr
    ?C                   ExSr      Edit01
     C                   EndDo


      *?  ...........................................................
      *?  :      SCRN01 - Display Screen 01                         :
      *?  :.........................................................:

     C     SCRN01        BegSR

    ?C                   Write     MSGCTL                                       ?
     C                   ExFmt     SOW04001
    ?C                   ExSr      ClrError

     C                   EndSr


      *?  ...........................................................
      *?  :      Load01     - Load Screen 1                         :
      *?  :.........................................................:

     C     Load01        BegSr

     C                   Eval      SCANREAD = *Zero

     C                   EndSr


      *?  ...........................................................
      *?  :      ClrS01     - Clear Screen 01                       :
      *?  :.........................................................:

     C     Clrs01        BegSr

     C                   Eval      SCANREAD = *Zero

     C                   EndSr


      *?  ...........................................................
      *?  :      EDIT01 - Edit Screen 01                            :
      *?  :.........................................................:

     C     EDIT01        BegSR

    ?C                   Select
    ?C                   When      *In03 or *In07
     C                   Eval      *InLr = *On

    ?C                   When      SCANREAD > 1000000
     C                   Eval      MessageID   = 'SOW0401'
      *? The User I.D. Number must be less than 1,000,000.
     C                   ExSr      SndError
     C                   ExSr      Scrn01

    ?C                   When      SCANREAD = *Zero
     C                   Eval      MessageID   = 'SOW0403'
      *? The user I.D. cannot be zero.
     C                   ExSr      SndError
     C                   ExSr      Scrn01

    ?C                   When      LabCnt < *Zero or
    ?C                             LabCnt > 150                                 Max Labels
     C                   Eval      MessageID   = 'SOW0404'
     C                   Eval      MessageDta  = '150'                          Max Labels
      *? The number of Tags to print must be greater than zero and less than &1.
     C                   ExSr      SndError
     C                   ExSr      Scrn01

    ?C                   Other
     C                   Eval      Scan# = ScanRead
     C                   CallP     $PrtUsrLab(Scan#:LabCnt)
     C                   Eval      MessageID   = 'SOW0402'
      *? User Labels Printed.
     C                   ExSr      SndError
     C                   ExSr      ClrS01
     C                   ExSr      Scrn01
    ?C                   EndSl


     C                   EndSr


      *?  ...........................................................
      *?  :      ClrError - Clear Error Message Subfile             :
      *?  :.........................................................:
    ?C     ClrError      BegSr                                                  ?

     C                   MOVE      'C'           SndClr
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      *In50 = *Off                                 ?Error Indicator

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      SndError - Send an Error Message to the PGMMSGQ    :
      *?  :.........................................................:
    ?C     SndError      BegSr                                                  ?

     C                   MOVE      'S'           SndClr
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      *In50 = *On                                  ?Error Indicator

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      * ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
      *?  :.........................................................:
    ?C     SRMSGF        BegSr                                                  ?

      *? Define Parameter List - define variables         ?

     C     MessageParm   PLIST                                                  ?
     C                   Parm      'SOW040'      PgmQ             10            ?Pgm Msg Queue
     C                   Parm      'KPMSGF'      MsgFile          10            ?Message File
     C                   Parm      '*LIBL'       MsgfLib          10            ?Library
     C                   Parm                    MessageID         7            ?Message Id
     C                   Parm                    MessageDta      100            ?Message Data
     C                   Parm                    MsgKey            4            ?Message Key
     C                   Parm                    SndClr            1            ?Send or Clear

      *? Call Msg processing CL                           ?

     C                   CALL      'XAMSFC'      MessageParm                    ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *InzSr        BegSR

     C                   ExSr      Load01
     C                   ExSr      ClrError
    ?C                   Write     Assume
     C                   ExSr      Scrn01

     C                   EndSR
