     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:    Stage 1 Move Report                                     :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Jan. 2005            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program generates a report which shows the Move    ?:
      *? : Requirements for Stage 1 Moving.                          ?:
      *? :                                                           ?:
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
      *? :  11      ?Overflow indicator                              ?:
      *? :  12      ?First Page indicator                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FMOV503P   O    E             PRINTER OFLIND(*IN12)
     FFMOVTO    IF   E           K DISK
     FFMOVDEST  IF   E           K DISK
     FFMOVJBL0A IF   E           K DISK
     FFMINVT    IF   E           K DISK

      *?  LDA
     D                UDS

      *? Query 1 Data Structure
     D  Q1_DS          DS                  Inz
01   D Q1_MJTDAT                      6S 0                                      ?Move Date
02   D Q1_MJMOVE                      2S 0                                      ?Move Number
03   D Q1_DESNAM                      8                                         ?Destination Name
04   D Q1_DESDSC                     20                                         ?Dest. Description
05   D Q1_DESLOC                     30                                         ?Dest. Location
06   D Q1_ITEM5                       5                                         ?Item #
07   D Q1_SIZE                        3                                         ?Size
08   D Q1_MJHSE                       2S 0                                      ?Green House
09   D Q1_MJSECT                      2S 0                                      ?Section
10   D Q1_MJBAY                       2S 0                                      ?Bay
11   D Q1_MJNOS                       1                                         ?North or South
12   D Q1_MJSPOL                      2S 0                                      ?Starting Pole
13   D Q1_MJSLOR                      1                                         ?Left or Right
14   D Q1_IMDES1                     30                                         ?Item Description
15   D Q1_MJTRAY                      5S 0                                      ?Qty. Trays
16   D*Q1_MJPOLE                      3S 2                                      ?Qty. Poles
17   D Q1_MJRDYD                      6S 0                                      ?Ready Date

      *? Report Data Structure
     D  RP_DS          DS                  Inz
01   D  MJTDAT                                                                  ?Move Date
02   D  MJMOVE                                                                  ?Move Number
03   D  DESNAM                                                                  ?Destination Name
04   D  DESDSC                                                                  ?Dest. Description
05   D  DESLOC                                                                  ?Dest. Location
06   D  ITEM5                                                                   ?Item #
07   D  SIZE                                                                    ?Size
08   D  GHSE                                                                    ?Green House
09   D  SECT                                                                    ?Section
10   D  BAY                                                                     ?Bay
11   D  NORS                                                                    ?North or South
12   D  POLE                                                                    ?Starting Pole
13   D  LORR                                                                    ?Left or Right
14   D  DESC                                                                    ?Item Description
15   D  TRAYS                                                                   ?Qty. Trays
16   D* POLES                                                                   ?Qty. Poles
17   D  SHIPDT                                                                  ?Ready Date

      *? Tables / Arrays
     D  MoveType       S             30A   Dim(10) CTData PerRcd(1)

      *? Fields
     D  BaseDate       S              7S 0
     D  RecordCount    S              5S 0 INZ(0)
     D  SaveDest       S                   Like(DESNAM)
     D  SaveDecr       S                   Like(DESDSC)

      *? Indicators
     D  First_Time     S               N   INZ(*On)
     D  EndOfFile      S               N   INZ(*Off)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User

      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

    ?C                   ExSr      GetData
    ?
      *? Read through SQL cursor and Print
    ?C                   ExSr      ReadData

      *? Process First Record
     C                   If        not EndOfFile
     C                   Eval      SaveDest  = Q1_DESNAM
     C                   Eval      SaveDesc  = Q1_DESDSC
     C                   Eval      DestPage = 1
     C                   Eval      RP_DS = Q1_DS
    ?C                   WRITE     HEADER
    ?C                   WRITE     COLUMNS
     C                   EndIf

      *? Process Remaining Records
     C                   DoW       not EndOfFile
    ?C                   ExSr      PrintData
    ?C                   ExSr      ReadData
     C                   EndDo

     C                   Eval      *InLR = *On
    ?C                   ExSr      PrintData
    ?C                   ExSr      CloseData


      *?  ...........................................................
      *?  :      GetData - Get selected A/R Open information        :
      *?  :.........................................................:

     C     GetData       BegSr

    ?c/exec sql
    ?c+
    ?c+                  DECLARE   C1 cursor for
    ?c+
01  ?c+  SELECT    MJTDAT             as C1_MJTDAT
02  ?c+       ,    MJMOVE             as C1_MJMOVE
03  ?c+       ,    DESNAM             as C1_DESNAM
04  ?c+       ,    DESDSC             as C1_DESDSC
05  ?c+       ,    DESLOC             as C1_DESLOC
06  ?c+       ,    Substr(IMITEM,1,5) as C1_ITEM5
07  ?c+       ,    IMSIZE             as C1_IMSIZE
08  ?c+       ,    MJHSE              as C1_MJHSE
09  ?c+       ,    MJSECT             as C1_MJSECT
10  ?c+       ,    MJBAY              as C1_MJBAY
11  ?c+       ,    MJNOS              as C1_MJNOS
12  ?c+       ,    MJSPOL             as C1_MJSPOL
13  ?c+       ,    MJSLOR             as C1_MJSLOR
14  ?c+       ,    IMDES1             as C1_IMDES1
15  ?c+       ,    MJTRAY             as C1_MJTRAY
16  ?c*       ,    MJPOLE             as C1_MJPOLE
17  ?c+       ,    MJRDYD             as C1_MJRDYD
    ?c+  FROM      FMOVTO
    ?c+     ,      FMOVDEST
    ?c+     ,      FMOVJOB
    ?c+     ,      FMINVT
    ?c+  WHERE     M2DATE=MJTDAT
    ?c+    and     M2MOVE=MJMOVE
    ?c+    and     M2ITEM=MJITEM
    ?c+    and     M2SIZE=MJSIZE
    ?c+    and     M2JOB#=MJJOB#
    ?c+    and     M2DSID=DESTID
    ?c+    and     M2ITEM=IMITEM
    ?c+    and     M2SIZE=IMSIZE
    ?c+    and     M2DATE=:SelDate
    ?c+    and     M2MOVE=:SelMove
    ?c+  ORDER BY  DESNAM
    ?c+         ,  MJHSE
    ?c+         ,  MJSECT
    ?c+         ,  MJBAY
    ?c+         ,  MJNOS
    ?c+         ,  MJSPKY
    ?c+
    ?c+                  For Read only
    ?c+
    ?c/end-exec

     ?*  Open the SQL recordset
    ?c/exec sql
    ?c+                  Open      C1
    ?c/end-exec

     C                   EndSr

      *?  ...........................................................
      *?  :      CloseDate - Close the Data Set                     :
      *?  :.........................................................:

     C     CloseData     BegSr

     ?*  Close the SQL recordset
    ?c/exec sql
    ?c+                  Close     C1
    ?c/end-exec

     C                   EndSr

      *?  ...........................................................
      *?  :      ReadData - Read Data                               :
      *?  :.........................................................:

     C     ReadData      BegSr

     ?*  Read Sow Schedule Records for Selected Week
    ?c/exec sql
    ?c+ Fetch C1 into :Q1_DS
    ?c/end-exec

     C                   If        SQLCOD = 111111111
     C                   EndIf
     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      POLES = Q1_MJTRAY / 55
     C                   Eval      EndOfFile = *Off
     C                   Eval      RecordCount = RecordCount + 1                ?Record Count
     C                   EndIf

     C                   EndSr

      *?  ...........................................................
      *?  :      PrintData - Print Soubroutine                      :
      *?  :.........................................................:

     C     PrintData     BegSr

     C                   If        not EndOfFile
      *? If the Destination has changed, write the totals for the previous Destination.
     C                   If        SaveDest <> Q1_DESNAM
    ?C                   ExSr      Wrt_NewDest
     C                   Eval      SaveDest =  Q1_DESNAM
     C                   Else
    ?C                   ExSr      Wrt_MovDetl
     C                   EndIf

      *?   Summary function for each Destination
     C                   Eval      TotalTrays = TotalTrays + TRAYS
     C                   Eval      TotalPoles = TotalPoles + POLES

      *?   Print Totals for Last Record
     C                   Else
    ?C                   Write     TOTALS
     C                   EndIF

     C                   EndSr


      *?  ...........................................................
      *?  :      Wrt_NewDest - Write Report Records for New Dest.   :
      *?  :.........................................................:

     C     Wrt_NewDest   BEGSR

      *? If it's not the first page for a Destination write the Continuation Header on OverFlow
     C                   If        *In12
     C                   Eval      DestPage = DestPage + 1
    ?C                   WRITE     CONTINUE
    ?C                   WRITE     COLUMNS
     C                   EndIf

    ?C                   WRITE     Totals
     C                   Eval      *In12 = *Off

     C                   If        not EndOfFile
     C                   Eval      SaveDest = Q1_DESNAM
     C                   Eval      SaveDesc = Q1_DESDSC
     C                   Eval      DestPage = 1
     C                   Eval      TotalTrays = *Zero
     C                   Eval      TotalPoles = *Zero
     C                   Eval      RP_DS = Q1_DS
    ?C                   WRITE     HEADER
    ?C                   WRITE     COLUMNS
    ?C                   WRITE     DETAILS
     C                   EndIF

     C                   EndSr


      *?  ...........................................................
      *?  :      Wrt_MovDetl - Write Move Detail Record             :
      *?  :.........................................................:

     C     Wrt_MovDetl   BEGSR

      *? If it's not the first page for a Destination write the Continuation Header on OverFlow
     C                   If        *In12
     C                   Eval      DestPage = DestPage + 1
    ?C                   WRITE     CONTINUE
    ?C                   WRITE     COLUMNS
     C                   Eval      *In12 = *Off
     C                   EndIf

     C                   Eval      RP_DS = Q1_DS
    ?C                   WRITE     DETAILS

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C     *Entry        PList
     C                   Parm                    SelDATE           6 0
     C                   Parm                    SelMOVE           2 0

     C                   Eval      RptTitle = MoveType(SelMOVE)

     C                   Eval      *IN11 = *On                                  ?1st Page of Report
     C                   Eval      *In99 = *Off
     C                   Eval      UserID = $User()

     C                   If        *In99
     C     kFMOVTO       Chain     FMOVTO
     C     kFMOVDEST     Chain     FMOVDEST
     C     kFMOVJBL0A    Chain     FMOVJBL0A
     C     kFMINVT       Chain     FMINVT

     C     kFMOVTO       KLIST
     C                   KFLD                    M2DATE
     C                   KFLD                    M2MOVE
     C                   KFLD                    M2ITEM
     C                   KFLD                    M2SIZE
     C                   KFLD                    M2JOB#
     C     kFMOVDEST     KLIST
     C                   KFLD                    DESTID
     C     kFMOVJBL0A    KLIST
     C                   KFLD                    MJTDAT
     C                   KFLD                    MJMOVE
     C                   KFLD                    MJHSE
     C                   KFLD                    MJSECT
     C                   KFLD                    MJBAY
     C                   KFLD                    MJNOS
     C                   KFLD                    MJSPKY
     C     kFMINVT       KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE

     C                   EndIf
     C                   EndSR
**                            |
    Stage 1 Moving Report     |
    Stage 2 Moving Report     |
    Stage 3 Moving Report     |
    Fixing Moving Report      |
   Extra 05 Moving Report     |
   Extra 06 Moving Report     |
   Extra 07 Moving Report     |
   Extra 08 Moving Report     |
   Extra 09 Moving Report     |
   Extra 10 Moving Report     |
