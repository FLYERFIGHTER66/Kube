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

      *?  LDA
     D                UDS

      *? Data Areas
     D  FutureAVL_DS   DS
     D    ITEM                       12A
     D    SIZE                        3A
     D    DES1                       30A
     D    QTAVW2                      7S 0
     D    QTAVW3                      7S 0
     D    QTAVW4                      7S 0
     D    QTAVW5                      7S 0
     D    BLDDATE                      D
     D    BLDTIME                      T

      *? Fields
     D  ReadyDate7     S              7S 0                                      ?Ready Date7
     D  ReadyDate      S               D                                        ?Ready Date
     D  Col_1          S             16A   Inz('<tr><td><center>')              ?Before Column 01
     D  Col_2          S             26A   Inz('</center></td><td><center>')    ?Before Column 02
     D  Col_2b         S             23A   Inz('<a href="SizeCodes.htm#')       ?Before Column 02
     D  Col_3          S             22A   Inz('</a></center></td><td>')        ?Before Column 03
     D  Col_4          S             17A   Inz('</td><td><center>')             ?Before Column 04
     D  Col_4b         S             26A   Inz('</center></td><td><center>')    ?Before Column 04b
     D  Col_5          S             10A   Inz('</td><td>')                     ?Before Blank Column
     D  Col_6          S             19A   Inz('</center></td></tr>')           ?End the Row
     D  HTMLLINE       S            256A                                        ?HTML code to Write
     D  RightNow       S               Z                                        ?Timestamp Now
     D  DateNow        S               D                                        ?Date Now
     D  TimeNow        S               T   TimFmt(*USA)                         ?Time Now
     D  Sav_SIZED      S             80A
     D  x              S              2S 0
     D  y              S              1S 0
     D  z              S              1S 0
     D  Week           S               D

     D  Weeks          DS
     D  MMDD2                         5A                                        ?Week 2
     D  MMDD3                         5A                                        ?Week 2
     D  MMDD4                         5A                                        ?Week 2
     D  MMDD5                         5A                                        ?Week 2
     D  MMDD                          5A   Dim(4) Overlay(Weeks)                ?Header Dates

      *? Arrays
     D  HTML           S            100A   Dim(15) CtData                       ?HTML source
     D  HDR            S            100A   Dim(10) CtData                       ?HEADER Source
     D  THD            S            100A   Dim(15) CtData                       ?Table HEADER Source

      *? Indicators
     D  EndOfFile      S               N                                        ?End Of File Ind.

      *? Copy Books

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Day
    ?D/COPY QFunctDefn,$Month
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$TimeStamp

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

      *? Open the DataSet
    ?C                   ExSr      ClrData
    ?C                   ExSr      GetData
    ?
      *? Read through SQL cursor and Write HTML
    ?C                   ExSr      ReadData
    ?C                   ExSr      PageDef                                      Do Once
    ?C                   ExSr      TableHDR
    ?C                   DoW       not EndOfFile
     C                   Eval      HTMLLINE = Col_1 + %Trim(ITEM)
     C                                      + Col_2 + Col_2b + SIZE + '">' +SIZE
     C                                      + Col_3 + %Trim(DES1)
     C                                      + Col_4 + %Trim(%Char(%Int(QTAVW2)))
     C                                      + Col_4 + %Trim(%Char(%Int(QTAVW3)))
     C                                      + Col_4 + %Trim(%Char(%Int(QTAVW4)))
     C                                      + Col_4 + %Trim(%Char(%Int(QTAVW5)))
     C                                      + Col_6
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

      *? Write Header Information.
      *?    Define the Table.
     C                   Eval      HTMLLINE = HTML(4)
    ?C                   ExSr      Wrt_HTML
      *?    Write First Line of Table
     C                   Eval      HTMLLINE = %Trim( HTML(5) )
     C                                      + 'ALL'                             SIZE
     C                                      + %Trim( HTML(7) )
     C                                      + %Char(ReadyDate)                  WEEK
     C                                      + %Trim( HTML(9) )
    ?C* DONT DO THIS     ExSr      Wrt_HTML
     C                   Eval      HTMLLINE = *Blanks
      *?    Write the Column Headings
     C                   Eval      HTMLLINE = %Trim(HTML(10))
     C                                      + %Trim(HTML(11))
     C                                      + %Trim(HTML(12))
    ?C                   ExSr      Wrt_HTML

     C                   EndSr

      *?  ...........................................................
      *?  :      TableHDR - Write the Table Header                  :
      *?  :.........................................................:

     C     TableHDR      BegSr

      *? Write the Table Header Stuff
     C                   Eval      x = 0
     C                   Eval      y = 1
     C                   DoW       x < 15
     C                   Eval      x = x + 1
     C                   Eval      HTMLLINE = %Trim( THD(x))

     C                   If        %SCAN('99/99': HTMLLINE) > 0
     C                   Eval      HTMLLINE = %REPLACE(MMDD(Y): HTMLLINE:
     C                             %SCAN('99/99': HTMLLINE): 5)
     C                   Eval      y = y + 1
     C                   EndIf

    ?C                   ExSr      Wrt_HTML
     C                   EndDo

     C                   EndSr

      *?  ...........................................................
      *?  :      PageDef - Write HTML code for Page                 :
      *?  :.........................................................:

     C     PageDef       BegSr

      *? Write the Page Header Stuff
     C                   Eval      x = 0
     C                   DoW       x < 1
     C                   Eval      x = x + 1
     C                   Eval      HTMLLINE = %Trim( HDR(x))
    ?C                   ExSr      Wrt_HTML
     C                   EndDo
      *? Write the "Disclaimer" line.
     C                   Eval      HTMLLINE = %Trim(HTML(14))
    ?C                   ExSr      Wrt_HTML
     C                   Eval      HTMLLINE = %Trim(HTML(15))
    ?C                   ExSr      Wrt_HTML
      *? Write the "Last Updated" line.
     C                   Eval      DateNow = BldDate
     C                   Eval      TimeNow = BldTime
     C                   Eval      HTMLLINE = %Trim( HTML(1))
     C                                      + '  '
     C                                      + %Trim( %Char(DateNow)
     C                                      + ' @ '
     C                                      + %Char(TimeNow) )
     C                                      + %Trim( HTML(3) )
    ?C                   ExSr      Wrt_HTML

     C                   Eval      z = 1
     C                   DoW       z <= 4
     C                   Eval      Week = $AddDate($Monday(BLDDATE:'SAT'):z*7)
     C                   Eval      MMDD(z) = %SubSt(%Char(Week):1:5)
     C                   Eval      z = z + 1
     C                   EndDo

     C                   ExSr      Wrt_COLS

     C                   EndSr

      *?  ...........................................................
      *?  :      Footer - Write HTML code for Page Footer           :
      *?  :.........................................................:

     C     Footer        BegSr

      *? End the Table.
     C                   Eval      HTMLLINE = HTML(13)
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
    ?c+    SELECT     ITEM
    ?c+         ,     SIZE
    ?c+         ,     DES1
    ?c+         ,     QTAVW2
    ?c+         ,     QTAVW3
    ?c+         ,     QTAVW4
    ?c+         ,     QTAVW5
    ?c+         ,     "DATE"
    ?c+         ,     "TIME"
    ?c+
    ?c+    FROM       READYFW
    ?c+
    ?c+    WHERE      QTAVW2 <> 0
    ?c+       or      QTAVW3 <> 0
    ?c+       or      QTAVW4 <> 0
    ?c+       or      QTAVW5 <> 0
    ?c+
    ?c+    ORDER BY  DES1
    ?c+           ,  ITEM
    ?c+           ,  SIZE
    ?c+
    ?c+  For Read only
    ?c+
    ?c/end-exec

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
    ?c+   delete from htmloutf
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+   delete from finishout
    ?c+
    ?c/end-exec

     C                   EndSr

      *?  ...........................................................
      *?  :      Wrt_COLS - Write column descriptions to READYFWDSC :
      *?  :.........................................................:

     C     Wrt_COLS      BegSr

    ?c/exec sql
    ?c+
    ?c+    INSERT INTO   READYFWDSC
    ?c+              (   ITEM
    ?c+              ,   SIZE
    ?c+              ,   DES1
    ?c+              ,   QTAVW2
    ?c+              ,   QTAVW3
    ?c+              ,   QTAVW4
    ?c+              ,   QTAVW5)
    ?c+    VALUES    (   'Item Number'
    ?c+              ,   'Sz'
    ?c+              ,   'Description'
    ?c+              ,   :MMDD2
    ?c+              ,   :MMDD3
    ?c+              ,   :MMDD4
    ?c+              ,   :MMDD5 )
    ?c+
    ?c/end-exec

     C                   EndSr

      *?  ...........................................................
      *?  :      Wrt_HTML - Write records to HTMLOUTF               :
      *?  :.........................................................:

     C     Wrt_HTML      BegSr

     C                   If        HTMLLINE <> ' '
     ?*  Write a line of HTML to the file.
    ?c/exec sql
    ?c+
    ?c+   INSERT INTO HTMLOUTF VALUES(:HTMLLINE)
    ?c+
    ?c/end-exec
     C                   EndIf

     C                   EndSr

      *?  ...........................................................
      *?  :      ReadData - Read Data                               :
      *?  :.........................................................:

     C     ReadData      BegSr

     ?*  Read Sow Schedule Records for Selected Week
    ?c/exec sql
    ?c+ Fetch C1 into :FutureAVL_DS
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

    ?C*    *Entry        PList
    ?C*                  Parm                    #SIZE#            3
    ?C*                  Parm                    #SeasCode1@       2
    ?C*                  Parm                    #SeasCode2@       2
    ?C*                  Parm                    #SeasCode3@       2

     C*                  Move      #SeasCode1@   #SeasCode1#       2 0
     C*                  Move      #SeasCode2@   #SeasCode2#       2 0
     C*                  Move      #SeasCode3@   #SeasCode3#       2 0

     C                   EndSR
**  HTML Source
<center><Font Size=4    color="red">LAST UPDATED:
?02?****    Insert update date & time Stamp here   *****
</br></font>
<table border="1" bordercolor="darkblue" CELLPADDING="2" CELLSPACING="0">
<tr><td><font size=6    color="darkblue"><center>
?06?****    Insert Size Code here   *****
</center></font></td><td></td><td><font size=6    color="darkblue"><center>Week of:
?07?****    Insert Ready Week here   *****
</center></font></td><td></td></tr>
<tr><td><center>ITEM<br>NUMBER</center></td><td><center>SIZE</br>CODE</center></td><td>DESCRIPTION
</td><td><center>QTY</BR>AVAIL</center></td><td><center>UNIT</BR>PRICE</center></td>
<td><center>ORDER</BR>QTY</center></td></tr>
</table></center>
<center><font size=4    color=red>These are projected values and are subject to losses.
</br>All orders for this material is <b>SUBJECT TO AVAILABILITY!</b></font></center></br>
** ?PAGE HEADER STUFF
<body gproperties="fixed" background="images/Logo_Image-transparent4.jpg">









**  TABLE HEADER ROW

<table border="1" bordercolor="darkblue" CELLPADDING="2" CELLSPACING="0">
<tr>
 <td width="10%"><center>ITEM</br>NBR</center></td>
 <td width="8%"><center>SIZE</br>CODE</center></td>
 <td width="42%">DESCRIPTION</td>
 <td width="10%"><center>99/99</center></td>
 <td width="10%"><center>99/99</center></td>
 <td width="10%"><center>99/99</center></td>
 <td width="10%"><center>99/99</center></td>
</tr>




