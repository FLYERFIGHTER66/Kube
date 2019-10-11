    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *?                                                              ?
      *??|                                                            |?
      *??|     Add Lot Inventory for Entire Day (ADDLOTINVP)          |?
      *?|                                                            |?

      *? :````````````````````````````````````````````````````````````:
      *? : Created:  October, 2005        ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :  Program Description?                                    ?:
      *? : This program add an entire weeks worth of sowing to        :
      *? : inventory.  It basically passes each tag number to the    ?:
      *? : ADDLOTINV program.                                        ?:
      *? :                                                           ?:
      *? : NOTE:  This is an infrequently used program ! ! !         ?:
      *? :        Do Not mistake it for obsolete.                    ?:
      *? :............................................................:
      *?                                                              ?
      *? |?  Subroutine Usage                                        ?|
      *? |                                                           ?|
      *? | *InzSr     ?- Must I explain this ?!?!?                   ?|
      *?|                                                            |?
      *?                                                              ?
      *? |?  Function Usage                                          ?|
      *? |                                                           ?|
      *? | $MDYDate   ?- Return MDY Date from Date Field             ?|
      *? | $Date      ?- Return Date field from Number               ?|
      *? | $User      ?- Return Current User I.D.                    ?|
      *? | $Now       ?- Return Current Time as Number               ?|
      *?|                                                            |?
      *?                                                              ?
      *? |?  Indicator Usage                                         ?|
      *? |                                                           ?|
      *? |  LR      ?Does this really need a description ?           ?|
      *?|                                                            |?
      *?                                                              ?
      *? |?  Edit Log                                                ?|
      *? |                                                           ?|
      *? |WJB10/27/05?-Initial Programming                        ?|
      *? |   mm/dd/yy?-                                           ?|
      *?|                                                            |?

      *? Field Definitions
     D  EndOfFile      S               N                                        ?End Of File Ind.
     D  Tray_to_Post   S              8S 0                                      ?Tray to Post
     D  SowDate7       S              7S 0                                      ?Sow Date CYYMMDD
     D  item5          S              5A                                        ?Item
     D  Size           S              3A                                        ?Size
     D  Screen         S              3S 0                                      ?Screen
     D  TraysAdded     S              6S 0                                      ?Trays Added to Lot

      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

     C                   ExSr      PostLot

      *?  ...........................................................
      *?  :      PostLot - Post Selected Trays to Lot Inventory     :
      *?  :.........................................................:

     C     PostLot       BegSr

    ?C                   ExSr      GetData
    ?
      *? Read through SQL cursor and Print
    ?C                   ExSr      ReadData
     C                   DoW       not EndOfFile
     C                   Call      'ADDLOTINV'
     C                   Parm                    Tray_to_Post
     C                   Parm                    Tray_to_Post
    ?C                   ExSr      ReadData
     C                   EndDo

     C                   ExSr      CloseData

     C                   EndSr

      *?  ...........................................................
      *?  :      GetData - Get selected A/R Open information        :
      *?  :.........................................................:

     C     GetData       BegSr

     C                   If        Screen = 1
    ?c/exec sql
    ?c+
    ?c+  DECLARE   C1 cursor for
    ?c+
    ?c+  SELECT      TRTAG#
    ?c+  FROM        FTRAY
    ?c+  WHERE       TRSCYM = :SowDate7
    ?c+    and       TRSTAT = 'A'
    ?c+    and       TRCNTD <> 'Y'
    ?c+  ORDER BY    TRTAG#
    ?c+
    ?c+  For Read only
    ?c+
    ?c/end-exec

     ?*  Open the SQL recordset for Screen 01
    ?c/exec sql
    ?c+                  Open      C1
    ?c/end-exec

     C                   Else

    ?c/exec sql
    ?c+
    ?c+  DECLARE   C2 cursor for
    ?c+
    ?c+  SELECT      TRTAG#
    ?c+  FROM        FTRAY
    ?c+  WHERE       TRSCYM = :SowDate7
    ?c+    and       TRITEM = :Item5
    ?c+    and       TRSIZE = :Size
    ?c+    and       TRSTAT = 'A'
    ?c+    and       TRCNTD <> 'Y'
    ?c+  ORDER BY    TRTAG#
    ?c+
    ?c+  For Read only
    ?c+
    ?c/end-exec

     ?*  Open the SQL recordset for Screen 02
    ?c/exec sql
    ?c+                  Open      C2
    ?c/end-exec

     C                   EndIf

     C                   EndSr

      *?  ...........................................................
      *?  :      CloseDate - Close the Data Set                     :
      *?  :.........................................................:

     C     CloseData     BegSr

     C                   If        Screen = 1
     ?*  Close the SQL recordset for Screen 01
    ?c/exec sql
    ?c+ Close C1
    ?c/end-exec

     C                   Else
     ?*  Close the SQL recordset for Screen 02
    ?c/exec sql
    ?c+ Close C2
    ?c/end-exec
     C                   EndIf

     C                   EndSr

      *?  ...........................................................
      *?  :      ReadData - Read Data                               :
      *?  :.........................................................:

     C     ReadData      BegSr

     C                   If        Screen = 1
     ?*  Read Sow Schedule Records for Selected Week
    ?c/exec sql
    ?c+ Fetch C1 into :Tray_to_Post
    ?c/end-exec
     C                   Else
     ?*  Read Sow Schedule Records for Selected Week and Item
    ?c/exec sql
    ?c+ Fetch C2 into :Tray_to_Post
    ?c/end-exec
     C                   EndIf

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Eval      *InLr = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Eval      TraysAdded = TraysAdded + 1
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      ExitSR - Exit Subroutine                           :
      *?  :.........................................................:

     C     ExitSR        BegSr

     C                   Eval      *InLr = *On
     C                   Return

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

    ?C     *Entry        PList
    ?C                   Parm                    SowDate7
    ?C                   Parm                    Item5
    ?C                   Parm                    Size
    ?C                   Parm                    Screen
    ?C                   Parm                    TraysAdded

     C                   Eval      TraysAdded = *Zero

     C                   EndSR
