    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Fin. Inventory Master Inquiry                      :?
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
      *? :  Scrn01   -?Display Screen 01                             ?:
      *? :  Load01   -?Load Screen 01                                ?:
      *? :  Edit01   -?EDIT Screen 01                                ?:
      *? :  ClrError -?Clear Error MEssage Subfile                   ?:
      *? :  SndError -?Send an Error Message to the PGMMSGQ          ?:
      *? :  SRMSGF   -?Clear or send messages to Pgm msg queue       ?:
      *? :  *INZSR   -?Initialization Subroutine                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  01 - 24 ?Return Screen Functions                         ?:
      *? :  03      ?Exit                                            ?:
      *? :  06      ?Restart                                         ?:
      *? :          ?                                                ?:
      *? :  25      ?SFLDSP, SFLDSPCTL, SFLCLR(N)                    ?:
      *? :  26      ?SFLDSP (Subfile has Data)                       ?:
      *? :  27      ?SFLEND                                          ?:
      *? :  28      ?SFLNXTCHG                                       ?:
      *? :  40      ?RollDn Indicator                                ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FFPR055FM  CF   E             WORKSTN
     F                                     SFILE(FPR05501:RRN01)
     F                                     DEVID(WSID)

     FFFINLOC   IF   E           K Disk
     FFMINVT    IF   E             Disk

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Center
    ?D/COPY QFunctDefn,QCmdExc

     D  Inventory      DS                  Inz
     D   C1_TAG#                           Like(FLTAG#)                         ?Batch_Number
     D   C1_ITEM                           Like(FLITEM)                         ?Item_Number
     D   C1_SIZE                           Like(FLSIZE)                         ?Size_Code
     D   C1_GHSE                           Like(FLGHSE)                         ?Green_House
     D   C1_SECT                           Like(FLSECT)                         ?Section
     D   C1_BAY                            Like(FLBAY )                         ?Bay
     D   C1_NORS                           Like(FLNORS)                         ?North_or_South
     D   C1_EORW                           Like(FLEORW)                         ?East_or_West
     D   C1_SRTP                           Like(FLSRTP)                         ?Starting_Pole
     D   C1_ENDP                           Like(FLENDP)                         ?Ending_Pole
     D   C1_TOTP                           Like(FLTOTP)                         ?Total_Poles
     D   C1_QTY                            Like(FLQTY )                         ?Total_Quantity
     D   C1_PLTG                           Like(FLPLTG)                         ?Planting_Number
     D   C1_CUST                           Like(FLCUST)                         ?Customer_Number
     D   C1_DES1                           Like(IMDES1)                         ?Description1
     D   C1_DES2                           Like(IMDES2)                         ?Description2
     D   C1_DES3                           Like(IMDES3)                         ?Description3
     D   C1_DES4                           Like(IMDES4)                         ?Description4
     D   C1_LOOK                           Like(IMLOOK)                         ?Item_Alpha_Sort

      *? Field Definitions
     D   User          S             10A                                        ?Current User ID
     D   Today         S               D                                        ?Todays Date MDY
     D   Now           S               T                                        ?The Time at *Init
     D   Program       S             10A                                        ?Program
     D   FileName      S             10A                                        ?File Name for Label

     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   StopRRN01     S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   Step01        S              4  0 Inz(0)                               ?SFLRRN 01 Increment
     D   ErrorCount    S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount01  S              3S 0 Inz(0)                               ?Error Count
     D   RecordCount   S              5S 0 INZ(0)
     D   ChainRRN01    S              4S 0 Inz(*Zero)                           ?Key by RRN

     D   SAVLook4      S                   Like(Look4)                          ?What to Look For
     D   Look4@        S             +2    Like(Look4)                          ?What to Look For

      *? Indicators
     D   EndOfFile     S               N

      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
    ?C                   ExSr      ClrError                                     ?
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01                                       ?

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    01                                           ?
    ?C                   ExSr      Edit01                                       ?
    ?C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   If        Screen <> 01
     C                   Z-Add     Screen        PrevScreen        3 0          ?Prev. Screen
     C                   EndIf
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     FPR05501F                                   ?
     C                   If        ErrorCount01 <> *Zero                        ?Error Count
    ?C                   Write     MSGCTL                                       ?
     C                   EndIf
     C                   If        StartRRN01 = *Zero
     C                   Eval      StartRRN01 = 1
     C                   EndIf
     C                   If        RRN01 = *Zero
     C                   Eval      *In26 = *Off                                 ?
     C                   EndIf
    ?C                   ExFmt     FPR05501C                                    ?
    ?C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount01 = *Zero                         ?Error Count
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   Eval      SAVLook4   =  Look4
     C                   Eval      Step01 = 21 * ( 1 )
     C                   Eval      EndOfFile = *Off
      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
     C                   Eval      *In81 = *Off
     C                   Eval      StartRRN01 = *Zero
    ?C                   Write     FPR05501C                                    ?

      *? Load the Subfile

    ?C                   ExSr      OpenData

     C                   Z-add     *Zero         RRN01                          ?

     C                   Eval      StopRRN01 = Step01

     C                   If        *In83
     C                   Eval      StopRRN01 = 9999
     C                   EndIf

    ?C                   ExSr      ReadData
     C                   DoW       not EndOfFile and RRN01 < StopRRN01
    ?C                   ExSr      Load01Fld
    ?C                   ExSr      ReadData
     C                   EndDo                                                  ?

     C                   If        not *In26
     C                   Clear                   FPR05501
     C                   Eval      RRN01 = 1
     C                   Eval      DESC = 'No Data Found'
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Write     FPR05501                                     ?
     C                   EndIf

     C                   IF        *In26 = *On and EndOfFile                    ?
    ?C     RRN01         Chain     FPR05501                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    FPR05501                                     ?
     C                   EndIF                                                  ?
     C                   Clear                   FPR05501                                     ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      More01 - Load Screen 01 w/ More records            :
      *?  :.........................................................:
    ?C     More01        BegSr                                                  ?

     C                   If        not EndOfFile

     C                   Eval      StartRRN01= RRN01 + 1
     C                   Eval      StopRRN01 = RRN01 + Step01

    ?C                   ExSr      ReadData
     C                   DoW       not EndOfFile and RRN01 < StopRRN01
      *? Load screen fields
    ?C                   ExSr      Load01Fld
    ?C                   ExSr      ReadData

     C                   EndDo                                                  ?

     C                   IF        *In26 = *On and EndOfFile                    ?
    ?C     RRN01         Chain     FPR05501                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    FPR05501                                     ?
     C                   EndIF                                                  ?
     C                   EndIf                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01Fld - Load Screen 01 Fields                  :
      *?  :.........................................................:
    ?C     Load01Fld     BegSr                                                  ?

      *? Load screen fields

      *? Write Subfile Record
     C                   Add       1             RRN01                          ?

      *?     Check to see if this is the starting screen
     C                   If        StartRRN01 = 0
     C                   Eval      *In81 = *On                                   Position Cursor
     C                   Eval      StartRRN01 = RRN01
     C                   EndIf

      *?  :````````````````````````````````````````````````````````````:
      *?  :              Load SFL Fields here ! ! !                    :
      *?  :............................................................:
     C                   Eval      FLNSEW  = FLNORS + FLEORW                    ?N, S, E, W.
     C                   Eval      FLITEM5 = %Subst(FLITEM:1:5)                 ?Item
    ?C                   Write     FPR05501                                     ?
     C                   Eval      *In26 = *On                                  ?Have Data Indicator
     C                   Eval      *In81 = *Off                                  Position Cursor

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

     C                   If        Look4   <> *Blanks
     C                   Eval      Look4@   = '%' + %Trim(Look4) + '%'
     C                   Else
     C                   Eval      Look4@   = *Blanks
     C                   EndIf

      *? Process pre-edit Functions F3, F6, F7 & F9
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
    ?C                             or *In07
    ?C                   ExSr      CloseData
     C                   MOVE      *ON           *INLR                          ?
      *? RollDown Requested
    ?C                   When         *In40 and not EndOfFile
    ?C                   ExSr      More01
    ?C                   ExSr      Scrn01
      *? RollDown Requested past end
    ?C                   When         *In40
     C                   Eval      ErrorCount01 = ErrorCount01 + 1              ?Error Count
     C                   Eval      MessageID = 'SFL0102'
     C                   Eval      MessageDta = *Blanks
    ?C                   ExSr      SndError
    ?C                   ExSr      Scrn01
      *? Refresh Requested
    ?C                   When         *In05
    ?C                   ExSr      CloseData
     C                   Time                    Now
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Selection Changed
    ?C                   When      Look4  <> SAVLook4
     C                   ExSr      CloseData
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? If no Functions, Check for Options.
    ?C                   OTHER                                                  ?
    ?C*                  No Options Available
      *? Redisplay
    ?C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ExitSR - Exit Subroutine                           :
      *?  :.........................................................:
    ?C     ExitSR        BegSr                                                  ?

     C                   ExSr      CloseData
     C                   Eval      *InLR = *On
     C                   Return

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ClrError - Clear Error Message Subfile             :
      *?  :.........................................................:
    ?C     ClrError      BegSr                                                  ?

     C                   MOVE      'C'           SndClr
    ?C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrorCount = *Zero                           ?Error Count
     C                   Eval      *In50 = *Off                                 ?Error Indicator

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      SndError - Send an Error Message to the PGMMSGQ    :
      *?  :.........................................................:
    ?C     SndError      BegSr                                                  ?

     C                   MOVE      'S'           SndClr
    ?C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrorCount = ErrorCount + 1                  ?Error Count
     C                   Eval      *In50 = *On                                  ?Error Indicator

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      * ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
      *?  :.........................................................:
    ?C     SRMSGF        BegSr                                                  ?

      *? Define Parameter List - define variables         ?

     C     MessageParm   PLIST                                                  ?
     C                   Parm      'FPR055'      PgmQ             10            ?Pgm Msg Queue
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
      *?  :      OpenData - Open Data Source                        :
      *?  :.........................................................:
    ?C     OpenData      BegSr                                                  ?

    ?c/exec sql
    ?c+
    ?c+    DECLARE  C1 cursor for
    ?c+
    ?c+    SELECT FFINLOC03.FLTAG# as Batch_Number
    ?c+         , FFINLOC03.FLITEM as Item_Number
    ?c+         , FFINLOC03.FLSIZE as Size_Code
    ?c+         , FFINLOC03.FLGHSE as Green_House
    ?c+         , FFINLOC03.FLSECT as Section
    ?c+         , FFINLOC03.FLBAY  as Bay
    ?c+         , FFINLOC03.FLNORS as North_or_South
    ?c+         , FFINLOC03.FLEORW as East_or_West
    ?c+         , FFINLOC03.FLSRTP as Starting_Pole
    ?c+         , FFINLOC03.FLENDP as Ending_Pole
    ?c+         , FFINLOC03.FLTOTP as Total_Poles
    ?c+         , FFINLOC03.FLQTY  as Total_Quantity
    ?c+         , FFINLOC03.FLPLTG as Planting_Number
    ?c+         , FFINLOC03.FLCUST as Customer_Number
    ?c+         , FMINVT.IMDES1  as Description1
    ?c+         , FMINVT.IMDES2  as Description2
    ?c+         , FMINVT.IMDES3  as Description3
    ?c+         , FMINVT.IMDES4  as Description4
    ?c+         , FMINVT.IMLOOK  as Item_Alpha_Sort
    ?c+    FROM   FFINLOC03, FMINVT
    ?c+    WHERE  FLITEM = IMITEM
    ?c+      and  FLSIZE = IMSIZE
    ?c+      and  (
    ?c+              (   IMLOOK                               like Trim(:LOOK4@)
    ?c+              or  FLITEM                               like Trim(:LOOK4@)
    ?c+              or  'ITEM ' || Substr(FLITEM,1,4) ||
    ?c+                      ' ' ||        FLSIZE             like Trim(:LOOK4@)
    ?c+              or  'SIZE ' || FLSIZE                    like Trim(:LOOK4@)
    ?c+              or  'CUST ' || Trim(char(FLCUST))        like Trim(:LOOK4@)
    ?c+              or  FLSIZE                               like Trim(:LOOK4@)
    ?c+              or  IMDES1                               like Trim(:LOOK4@)
    ?c+              or  IMDES4                               like Trim(:LOOK4@)
    ?c+              or  Trim(char(FLTAG#))                   like Trim(:LOOK4@)
    ?c+              or  Trim(
    ?c+                  Trim(FLITEM) || ' ' ||
    ?c+                  Trim(FLSIZE) || ' ' ||
    ?c+                  Trim(char(FLPLTG)) || ' ' ||
    ?c+                  Trim(char(FLCUST)))           like Trim(:LOOK4@)
    ?c+              or  Trim(
    ?c+                  Trim(FLITEM) || ' ' ||
    ?c+                  Trim(FLSIZE) || ' ' ||
    ?c+                  Trim(char(FLCUST)))           like Trim(:LOOK4@)
    ?c+              )
    ?c+           OR :LOOK4@ = '' )
    ?c+    ORDER BY IMLOOK
    ?c+         , FMINVT.IMLOOK
    ?c+         , FFINLOC03.FLCUST
    ?c+         , FFINLOC03.FLGHSE
    ?c+         , FFINLOC03.FLSECT
    ?c+         , FFINLOC03.FLBAY
    ?c+         , FFINLOC03.FLNORS
    ?c+         , FFINLOC03.FLEORW
    ?c+         , FFINLOC03.FLSRTP
    ?c+         , FFINLOC03.FLENDP
    ?c+
    ?c+    For Read only
    ?c+
    ?c/end-exec

     ?*  Open the SQL recordset
    ?c/exec sql
    ?c+                  Open      C1
    ?c/end-exec

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ReadData - Read Data                               :
      *?  :.........................................................:

     C     ReadData      BegSr

     ?*  Read Sow Schedule Records
    ?c/exec sql
    ?c+ Fetch C1 into :Inventory
    ?c/end-exec

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Clear                   RFINLOC
    ?C     C1_TAG#       Chain     FFINLOC
     C                   Eval      FLTAG#      = C1_TAG#
     C                   Eval      FLITEM      = C1_ITEM
     C                   Eval      FLSIZE      = C1_SIZE
     C                   Eval      FLGHSE      = C1_GHSE
     C                   Eval      FLSECT      = C1_SECT
     C                   Eval      FLBAY       = C1_BAY
     C                   Eval      FLNORS      = C1_NORS
     C                   Eval      FLEORW      = C1_EORW
     C                   Eval      FLSRTP      = C1_SRTP
     C                   Eval      FLENDP      = C1_ENDP
     C                   Eval      FLTOTP      = C1_TOTP
     C                   Eval      FLQTY       = C1_QTY
     C                   Eval      FLPLTG      = C1_PLTG
     C                   Eval      FLCUST      = C1_CUST
     C                   Eval      IMDES1      = C1_DES1
     C                   Eval      DESC        = %Subst(C1_DES1:1:%Len(DESC))
     C                   Eval      IMDES2      = C1_DES2
     C                   Eval      IMDES3      = C1_DES3
     C                   Eval      IMDES4      = C1_DES4
     C                   Eval      IMLOOK      = C1_LOOK
     C                   EndIf

     C                   EndSr

      *?  ...........................................................
      *?  :      CloseDate - Close the Data Set                     :
      *?  :.........................................................:

     C     CloseData     BegSr

     ?*  Close the SQL recordset
    ?c/exec sql
    ?c+ Close C1
    ?c/end-exec

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *Entry        PList                                                  ?
    ?C                   Parm                    Look4                          ?

     C                   If        Look4   <> *Blanks
     C                   Eval      Look4@   = '%' + %Trim(Look4) + '%'
     C                   Else
     C                   Eval      Look4@   = *Blanks
     C                   EndIf

     C                   Eval      *In83 = *Off
     C                   Time                    Today
     C                   Time                    Now

    ?C                   EndSr                                                  ?
