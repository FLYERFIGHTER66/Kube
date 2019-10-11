    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:         Sow Confirmation Scanning                          :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  DEC. 2005            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program prinnts the Daily R/C Line Production      ?:
      *? : Report.                                                   ?:
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

     F*HTMLOUT   O  A E           K DISK

      *?  LDA
     D                UDS

      *? Data Areas
     D  Available_DS   DS
     D    ALPH                       15A
     D    ITEM                       12A
     D    SIZE                        3A
     D    DESC                       30A
     D    AVAIL                      12S 0

      *? Fields
     D  ReadyDate7     S              7S 0                                      ?Ready Date7
     D  ReadyDate      S               D                                        ?Ready Date
     D  Col_1          S             16A   Inz('<tr><td><center>')              ?Before Column 01
     D  Col_2          S             26A   Inz('</center></td><td><center>')    ?Before Column 02
     D  Col_3          S             18A   Inz('</center></td><td>')            ?Before Column 03
     D  Col_4          S             17A   Inz('</td><td><center>')             ?Before Column 04
     D  Col_5          S             10A   Inz('</td><td>')                     ?Before Blank Column
     D  Col_6          S             19A   Inz('</center></td></tr>')           ?End the Row
     D  HTMLLINE       S            256A                                        ?HTML code to Write
     D  RightNow       S               Z                                        ?Timestamp Now
     D  DateNow        S               D                                        ?Date Now
     D  TimeNow        S               T   TimFmt(*USA)                         ?Time Now

      *? Arrays
     D  HTML           S            100A   Dim(20) CtData                       ?HTML source

      *? Indicators
     D  EndOfFile      S               N                                        ?End Of File Ind.

      *? Copy Books

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$TimeStamp

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

      *? Open the DataSet
    ?C                   ExSr      ClrData
    ?C                   ExSr      GetData
     C                   ExSr      Header
    ?
      *? Read through SQL cursor and Write HTML
    ?C                   ExSr      ReadData
    ?C                   DoW       not EndOfFile
     C                   If        %Scan('P':ITEM) = 0
     C                   Eval      HTMLLINE = Col_1 + %Trim(ITEM)
     C                                      + Col_2 + SIZE
     C                                      + Col_3 + %Trim(DESC)
     C                                      + Col_4 + %Trim(%Char(%Int(AVAIL)))
     C                                      + Col_5 + '__________'
     C                                      + Col_6
    ?C                   Else
     C                   Eval      HTMLLINE = Col_1 + %Trim(ITEM)
     C                                      + Col_2 + SIZE
     C                                      + Col_3 + %Trim(DESC)
     C                                + '<font color="red">-Partial</font>'
     C                                      + Col_4 + %Trim(%Char(AVAIL))+'%'
     C                                      + Col_5 + '__________'
     C                                      + Col_6
    ?C                   EndIf
    ?C                   ExSr      Wrt_HTML
     C                   Eval      *IN26 = *On
    ?C                   ExSr      ReadData
     C                   EndDo

     C                   ExSr      Footer
    ?C                   ExSr      CloseData

      *?  ...........................................................
      *?  :      Header - Write HTML code for Page Header           :
      *?  :.........................................................:

     C     Header        BegSr

      *? Write the "Last Updated" line.
     C                   Eval      RightNow = $TimeStamp()
     C                   Move      RightNow      DateNow
     C                   Move      RightNow      TimeNow
     C                   Eval      HTMLLINE = %Trim( HTML(1))
     C                                      + '  '
     C                                      + %Trim( %Char(DateNow)
     C                                      + ' @ '
     C                                      + %Char(TimeNow) )
     C                                      + %Trim( HTML(3) )
    ?C                   ExSr      Wrt_HTML
      *? Write Header Information.
      *?    Define the Table.
     C                   Eval      HTMLLINE = HTML(4)
    ?C                   ExSr      Wrt_HTML
      *?    Write First Line of Table
     C                   Eval      HTMLLINE = %Trim( HTML(5) )
     C                                      + #SIZE#                            SIZE
     C                                      + %Trim( HTML(7) )
     C                                      + %Char(ReadyDate)                  WEEK
     C                                      + %Trim( HTML(9) )
    ?C                   ExSr      Wrt_HTML
      *?    Write the Column Headings
     C                   Eval      HTMLLINE = HTML(15)
    ?C                   ExSr      Wrt_HTML
     C                   Eval      HTMLLINE = HTML(16)
    ?C                   ExSr      Wrt_HTML
     C                   Eval      HTMLLINE = HTML(17)
    ?C                   ExSr      Wrt_HTML
     C                   Eval      HTMLLINE = HTML(18)
    ?C                   ExSr      Wrt_HTML
     C                   Eval      HTMLLINE = HTML(19)
    ?C                   ExSr      Wrt_HTML
     C                   Eval      HTMLLINE = HTML(20)
    ?C                   ExSr      Wrt_HTML
     C                   Eval      HTMLLINE = HTML(10)
     C                                      + HTML(11)
    ?C                   ExSr      Wrt_HTML

     C                   EndSr

      *?  ...........................................................
      *?  :      Footer - Write HTML code for Page Footer           :
      *?  :.........................................................:

     C     Footer        BegSr

      *? End the Table.
     C                   Eval      HTMLLINE = HTML(12)
    ?C                   ExSr      Wrt_HTML

     C                   EndSr


      *?  ...........................................................
      *?  :      GetData - Get selected A/R Open information        :
      *?  :.........................................................:

     C     GetData       BegSr


    ?c/exec sql
    ?c+
    ?c+  DECLARE      C1 cursor for
    ?c+
    ?c+    SELECT LRALPH
    ?c+         , substr(trim(LRITEM)||'P',1,12) as LRITEM
    ?c+         , LRSIZE
    ?c+         , LRDESC
    ?c+         , LDPRTT * 100
    ?c+    FROM fdlotrd_ar, flosslot
    ?c+    WHERE LRCUST = 999997
    ?c+      and FDLOTRD_AR.LRITEM= FLOSSLOT.LDITEM
    ?c+      and FDLOTRD_AR.LRSIZE= FLOSSLOT.LDSIZE
    ?c+      and FDLOTRD_AR.LRSOWD= FLOSSLOT.LDSOWD
    ?c+      and FDLOTRD_AR.LRCRDY= FLOSSLOT.LDREDY
    ?c+      and (LRSIZE=:#SIZE# or :#SIZE# = 'ALL')
    ?c+
    ?c+           UNION ALL
    ?c+
    ?c+    SELECT LRALPH
    ?c+         , LRITEM
    ?c+         , LRSIZE
    ?c+         , LRDESC
    ?c+         , sum(LRQTAV)
    ?c+    FROM fdlotrd_ar
    ?c+    WHERE LRCUST < 999990
    ?c+      and (LRSIZE=:#SIZE# or :#SIZE# = 'ALL')
    ?c+    GROUP BY LRALPH, LRSIZE, LRITEM, LRDESC
    ?c+
    ?c+    ORDER BY LRALPH, LRSIZE, LRITEM, LRDESC
    ?c+
    ?c+  For Read only
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c*    SELECT     max(LRCRDY)
    ?c*    INTO       :ReadyDate7
    ?c*    FROM       READYOUT
    ?c*    WHERE      LRSIZE=:#SIZE# or :#SIZE# = 'ALL'
    ?c*      AND      AVAIL<>0
    ?c+
    ?c+    SELECT     max(LRCRDY)
    ?c+    INTO       :ReadyDate7
    ?c+    FROM       FDLOTRD_AR
    ?c+    WHERE      LRSIZE=:#SIZE# or :#SIZE# = 'ALL'
    ?c+
    ?c/end-exec

     C                   Eval      ReadyDate = $Date(ReadyDate7)

     ?*  Open the SQL recordset for Screen 01
    ?c/exec sql
    ?c+                  Open      C1
    ?c/end-exec

     C                   EndSr

      *?  ...........................................................
      *?  :      CloseData - Close Data                             :
      *?  :.........................................................:

     C     CloseData     BegSr

     ?*  Close the SQL recordset for Screen 01
    ?c/exec sql
    ?c+                  Close     C1
    ?c/end-exec

     C                   EndSr

      *?  ...........................................................
      *?  :      ClrData - Clear the HTML Output file               :
      *?  :.........................................................:

     C     ClrData       BegSr

     ?*  Insert HTML Code into the HTML Output File
    ?c/exec sql
    ?c+
    ?c+   delete from htmlout
    ?c+
    ?c/end-exec

     C                   EndSr

      *?  ...........................................................
      *?  :      Wrt_HTML - Write records to HTMLOUT                :
      *?  :.........................................................:

     C     Wrt_HTML      BegSr

     ?*  Clear all records from the file
    ?c/exec sql
    ?c+
    ?c+   INSERT INTO HTMLOUT VALUES(:HTMLLINE)
    ?c+
    ?c/end-exec

     C                   EndSr

      *?  ...........................................................
      *?  :      ReadData - Read Data                               :
      *?  :.........................................................:

     C     ReadData      BegSr

     ?*  Read Sow Schedule Records for Selected Week
    ?c/exec sql
    ?c+ Fetch C1 into :Available_DS
    ?c/end-exec

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Eval      *InLR     = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   EndIf

     C                   EndSr

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *InzSr        BegSR

    ?C     *Entry        PList
    ?C                   Parm                    #SIZE#            3

     C                   EndSR
**  HTML Source
<center><font size=4    color="red">LAST UPDATED:
?02?****    Insert update date & time Stamp here   *****
</br></font>
<table border="2" bordercolor="darkblue" CELLPADDING="2" CELLSPACING="0">
<tr><td><font size=6    color="darkblue"><center>
?06?****    Insert Size Code here   *****
</center></font></td><td></td><td><font size=6    color="darkblue"><center>Week of:
?07?****    Insert Ready Week here   *****
</center></font></td><td></td></tr>
<tr><td><center>ITEM<br>NUMBER</center></td><td><center>SIZE</br>CODE</center></td><td>DESCRIPTION
</td><td><center>QTY</BR>AVAIL</center></td><td><center>ORDER</BR>QTY</center></td></tr>
</table></center>
?13?****    Not used yet    ****
?14?****    Not used yet    ****
<center><table border="2" CELLPADDING="2" CELLSPACING="0" bordercolor="darkblue">
<colgroup width="75" align="center"></colgroup>
<colgroup width="50" align="center"></colgroup>
<colgroup width="350" align="left"></colgroup>
<colgroup width="75" align="center"></colgroup>
<colgroup width="100" align="center"></colgroup>
