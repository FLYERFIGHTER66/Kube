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

     FERR010P   O    E             PRINTER OFLIND(*IN12)

      *?  LDA
     D                UDS

      *? Query 1 Data Structure
     D  Q1_DS          DS                  Inz
     D  IMITEM                       12                                         ?Item
     D  IMSIZE                        3                                         ?Size
     D  IMDES1                       30                                         ?Description
     D  IMUCST                        9S 4                                      ?Unit Cost
     D  IMLCST                        9S 4                                      ?Last Cost

      *? Fields
     D  RecordCount    S              5S 0 INZ(0)

      *? Indicators
     D  First_Time     S               N   INZ(*On)
     D  EndOfFile      S               N   INZ(*Off)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

    ?C                   ExSr      GetData
    ?
      *? Read through SQL cursor and Print
    ?C                   ExSr      ReadData

      *? Process First Record
     C                   If        not EndOfFile
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
    ?c+    SELECT    IMITEM
    ?c+         ,    IMSIZE
    ?c+         ,    IMDES1
    ?c+         ,    IMUCST
    ?c+         ,    IMLCST
    ?c+    FROM      FMINVT
    ?c+    WHERE     IMSIZE <>'SED'
    ?c+      and   ( IMUCST <> 0 or IMLCST <> 0 )
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
     C                   Eval      EndOfFile = *Off
     C                   Eval      RecordCount = RecordCount + 1                ?Record Count
     C                   EndIf

     C                   EndSr

      *?  ...........................................................
      *?  :      PrintData - Print Soubroutine                      :
      *?  :.........................................................:

     C     PrintData     BegSr

     C                   If        not EndOfFile
      *? Write the record that has a cost.
    ?C                   ExSr      Wrt_Detl

      *?   Print Totals for Last Record
     C                   Else
    ?C*                  Write     TOTALS
     C                   EndIF

     C                   EndSr


      *?  ...........................................................
      *?  :      Wrt_Detl    - Write Detail Record                  :
      *?  :.........................................................:

     C     Wrt_Detl      BEGSR

      *? If it's not the first page write the Continuation Header on OverFlow
     C                   If        *In12
    ?C                   WRITE     HEADER
    ?C                   WRITE     COLUMNS
     C                   Eval      *In12 = *Off
     C                   EndIf

    ?C                   WRITE     DETAILS

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C                   Eval      *IN11 = *On                                  ?1st Page of Report
     C                   Eval      *In99 = *Off
     C                   Eval      UserID = $User()

     C                   EndSR
