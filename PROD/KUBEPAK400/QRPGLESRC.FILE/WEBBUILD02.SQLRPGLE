    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      //??:````````````````````````````````````````````````````````````:?
      //??:                                                            :?
      //??:............................................................:?
      //? :````````````````````````````````````````````````````````````:
      //? : Created:  DEC. 2005            ? Kube-Pak Corporation ?    :
      //? :      by:  William J. Behr                                  :
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Program Description                                     ?:
      //? :                                                           ?:
      //? :                                                           ?:
      //? :                                                           ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Subroutine Usage                                        ?:
      //? :                                                           ?:
      //? : Subroutine ?-Subroutine Description                  ?  ?:
      //? :  *INZSR      -?Initialization Subroutine                  ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Function Usage                                          ?:
      //? :                                                           ?:
      //? : Function   ?-Function Description                    ?  ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Indicator Usage                                         ?:
      //? :                                                           ?:
      //? : *IND  ?-Indicator Usage                              ?  ?:
      //? :  LR      ?Does this really need a description ?           ?:
      //? :............................................................:

     FXATABE1   IF   E           K DISK

      //?  LDA
     D                UDS

      //? Data Areas
     D  Available_DS   DS
     D    HSSNCD                      2A
     D    HSSEAS                     15A
     D    HSLIST                      6A
     D    HLDESC                     30A
     D    ITEM                       12A
     D    SIZE                        3A
     D    DESC                       30A
     D    AVAIL                      12S 1
     D    PRICE                       9S 4
     D    SIZED                      80A
     D    RDYC                        5A
     D    RDYClong                   15A

     D  Search_DS      DS
     D    SIPLNT                     30A
     D    SISERN                     35A
     D    IMDES4                     30A

     D  ListDS         DS
     D    ThisList                   21A                                        Order Lists
     D    ListHTML                  256A                                        Order Lists

      //? Fields
     D  ReadyDate7     S              7S 0                                      ?Ready Date7
     D  ReadyDate      S               D                                        ?Ready Date
     D  Col_1          S              8A   Inz('<tr><td>')                      ?Before Column 01
     D*  Col_1l1        S             30A   Inz('<a href="')                     ?Before Column 01
     D*  Col_1l2        S             30A   Inz('c.sharepoint.com/SiteAssets/It')
     D*  Col_1l3        S             12A   Inz('em_Pictures/')
     D  Col_2          S             13A   Inz('</a></td><td>')                 ?Before Column 02
     D  Col_2b         S             23A   Inz('<a href="SizeCodes.htm#')       ?Before Column 02
     D  Col_3          S             13A   Inz('</a></td><td>')                 ?Before Column 03
     D  Col_4          S             09A   Inz('</td><td>')                     ?Before Column 04
     D  Col_4b         S             09A   Inz('</td><td>')                     ?Before Column 04b
     D  Col_5          S             09A   Inz('</td><td>')                     ?Before Blank Column
     D  Col_6          S             10A   Inz('</td></tr>')                    ?End the Row
     D  HTMLLINE       S            256A                                        ?HTML code to Write
     D  RightNow       S               Z                                        ?Timestamp Now
     D  DateNow        S               D                                        ?Date Now
     D  TimeNow        S               T   TimFmt(*USA)                         ?Time Now
     D  Sav_SIZED      S             80A
     D  Sav_HLDESC     S             30A
     D  x              S              2S 0
     D  LastList       S             21A                                        Order Lists
     D  WebSearch      S            256A
     D  PictureFile    S            256A
     D  PicturePath    S            256A
     D  Color          S             25A
     D  EndColor       S             25A
     D  foundPicture   S               N

      //? Arrays
     D  HTML           S            100A   Dim(15) CtData                       ?HTML source
     D  HDR            S            100A   Dim(10) CtData                       ?HEADER Source
     D  THD            S            100A   Dim(16) CtData                       ?Table HEADER Source

      //? Indicators
     D  EndOfFile      S               N                                        ?End Of File Ind.

      //? Copy Books

      //? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$isIFSObj

    ?D $RmvDupWrd      PR           256A   ExtProc('$RmvDupWrd')
    ?D   #dupString#                256A   const

      //?  ...........................................................
      //?  :    M A I N   C A L C U L A T I O N S                    :
      //?  :.........................................................:

      //? Open the DataSet
      /FREE

       //PicturePath =
       //'https://kubepak-public.sharepoint.com/SiteAssets/Item_Pictures/';
       PicturePath =
       'http://www.kubepak.net/images/KP_Items/';

       ExSr ClrData;
       ExSr GetData;
       ExSr PageDef;

       Exec SQL Delete from ITEM_WITH_MISSING_PIC;

       //? Read through SQL cursor and Write HTML
       ExSr ReadData;
       DoW not EndOfFile;
         //  New Order Form....
         If HLDESC <> Sav_HLDESC;
           HTMLLINE = '</table></br></br><hr></br>'
               + '<P><h1><a name="'+HSLIST+'">'
               + %Trim(HSSEAS) + ' Order Forms - '
               + %Trim(HLDESC)
               + '</a></h1></P>';
           ExSr Wrt_HTML;
           HTMLLINE = '</p align="left"><a href="#Top">'
               + '...back to Top'
               + '</a></P>';
           ExSr Wrt_HTML;
           HTMLLINE = '</br></br>'
               + '<Font Size=3    Color="Red">'
               + Col_2b + SIZE + '"'
               + ' target="_blank"'
               + ' rel="nofollow"'
               + '>(' + SIZE
               + ') -  '+%Trim(SIZED)+'</A></Font>';
           ExSr Wrt_HTML;
           ExSr TableHDR;
           Sav_HLDESC = HLDESC;
           Sav_SIZED = SIZED;
         Else;
           If SIZED <> Sav_SIZED;
             //  New Size Code....
             HTMLLINE = '</table></br>'
                 + '<Font Size=3    Color="Red">'
                 + Col_2b + SIZE + '"'
                 + ' target="_blank"'
                 + ' rel="nofollow"'
                 + '>(' + SIZE
                 + ') -  '+%Trim(SIZED)+'</A></Font>';
             ExSr Wrt_HTML;
             ExSr TableHDR;
             Sav_SIZED = SIZED;
           EndIf;
         EndIf;

         TableCd = RDYC;
         Chain TableKey XATABE1;                                              //?
         If %Found(XATABE1);
           RDYClong = TBSHRT;
         Else;
           RDYClong = RDYC;
         EndIf;

         //? Write Table Rows...

         Clear Search_DS;

         Exec SQL  //  Get Search Fields
           SELECT   SIPLNT, SISERN, IMDES4
           INTO    :Search_DS
           FROM     FMINVT, FMINSER, FSERINF
           WHERE    FMINVT.IMITEM = FMINSER.ISITEM
           and      FMINSER.ISCODE =FSERINF.SICODE
           and      FMINVT.IMSIZE = :SIZE
           and      FMINVT.IMITEM = :ITEM;

         WebSearch = $RMVDUPWRD(
                   %Trim(SIPLNT) +' '+ %Trim(SISERN) +' '+ %Trim(IMDES4));

         PictureFile = %trim(ITEM) + '-' + %Trim(SIZE) + '.jpg';
         If $isIFSObj(
            '/www/zendphp7/htdocs/PICTURES/' + PictureFile);
           foundPicture = *On;
          else;
           PictureFile = %trim(ITEM) + '.jpg';
           foundPicture = $isIFSObj(
                          '/www/zendphp7/htdocs/PICTURES/' + PictureFile);
         ENDIF;

         If foundPicture;
           HTMLLINE =
             Col_1 + '<a href="' + %Trim(PicturePath) + %Trim(PictureFile)
             + '" Target="blank">' + '<center>' + %Trim(ITEM) + '</center>'
             + Col_2 + Col_2b + SIZE + '">'
             + '<center>' + %Trim(SIZE) + '</center>' + Col_3;
           ExSr Wrt_HTML;

           HTMLLINE =    // Write KP Image Here
               '<a href="' + %trim(PicturePath) + %Trim(PictureFile)
                           + '" Target="blank">';
           ExSr Wrt_HTML;
           HTMLLINE =
             '<img onmouseover="ItemImg(this)"'
             +    ' onmouseout="normalImg(this)" '
             + 'border="0" src="' + %trim(PicturePath) + %Trim(PictureFile)
             + '" alt="Item Image" width="10"></a>';
           ExSr Wrt_HTML;
          else;  // $isIFSObj
            Exec SQL
              INSERT INTO TGMSDATA/ITEM_WITH_MISSING_PIC
               (ITEM_NUMBER, SIZE_CODE, WEB_SEARCH)
                 VALUES(:ITEM, :SIZE, :WebSearch);
           HTMLLINE =
             Col_1 + '<center>' + %Trim(ITEM) + '</center>' +
             '</td><td>' + Col_2b + SIZE + '">'
             + '<center>' + %Trim(SIZE) + '</center>' + Col_3;
           ExSr Wrt_HTML;
         EndIf; // $isIFSObj

         HTMLLINE =    // Write Google Search Here
             '<a href="https://www.google.com/search?q='
           +  %Trim(WebSearch)
           + '"  Target="blank">'
           + '<img src="images/google_search_icon.png" '
           + 'alt="Google Search" height="17" width="17"></a>';
         ExSr Wrt_HTML;

         HTMLLINE =    // Write Bing Search Here
             '<a href="http://www.bing.com/search?q='
           +  %Trim(WebSearch)
           + '" Target="blank">'
           + '<img src="images/bing_search_icon.png" '
           + 'alt="Bing Search" height="17" width="17"></a>';
         ExSr Wrt_HTML;

         If AVAIL > 0;
           Color = '';
           EndColor = '';
          Else;
           Color = '<font color="grey">';
           EndColor = '</font>';
         EndIf;

         HTMLLINE =
             %Trim(Color) + %Trim(DESC) + %Trim(EndColor)
           + Col_4 + '<center>' +%Trim(%Char(%Int(AVAIL))) + '</center>'
           + Col_4b + '<center>' +%Trim(RDYClong) + '</center>'
           + Col_5 + '__________'
           + Col_6 ;
         ExSr Wrt_HTML;
         *IN26 = *On;
         ExSr ReadData;
       EndDo;

       ExSr Footer;
       ExSr CloseData;

       //?  ...........................................................
       //?  :      Header - Write HTML code for Page Header           :
       //?  :.........................................................:

       BegSr Header;

         //? Write Header Information.
         //?    Define the Table.
         HTMLLINE = HTML(4);
         ExSr Wrt_HTML;
         //?    Write First Line of Table
         HTMLLINE = %Trim( HTML(5) )
             + #SIZE#                                                         //SIZE
             + %Trim( HTML(7) )
             + %Char(ReadyDate)                                               //WEEK
             + %Trim( HTML(9) );
         // DONT DO THIS     ExSr      Wrt_HTML
         HTMLLINE = *Blanks;
         //?    Write the Column Headings
         HTMLLINE = %Trim(HTML(10))
             + %Trim(HTML(11))
             + %Trim(HTML(12));
         ExSr Wrt_HTML;

       EndSr;

       //?  ...........................................................
       //?  :      TableHDR - Write the Table Header                  :
       //?  :.........................................................:

       BegSr TableHDR;

         //? Write the Table Header Stuff
         x = 0;
         DoW x < %Elem(THD);
           x = x + 1;
           HTMLLINE = %Trim( THD(x));
           ExSr Wrt_HTML;
         EndDo;
       EndSr;

       //?  ...........................................................
       //?  :      PageDef - Write HTML code for Page                 :
       //?  :.........................................................:

       BegSr PageDef;
         w('<!DOCTYPE html>                                                  ');
         w('<html>                                                           ');
         w('    <head>                                                       ');
         w('    </head>                                                      ');
         w(' <style>                                                         ');
         w('   .fixedContainer {                                             ');
         w('     position: fixed;                                            ');
         w('     padding: 2px;                                               ');
         w('     right: 0px;                                                 ');
         w('     top: 0px;                                                   ');
         w('     width: 300px;                                               ');
         w('     transform: translate(-5px, +5px);                           ');
         w('   }                                                             ');
         w(' </style>                                                        ');

         w(' <script>                                                        ');
         w('   function ItemImg(x) {                                         ');
         w('     x.style.width = "15px";                                     ');
         w('     imageContainer.src = x.src;                                 ');
         w('     imageContainer.opacity = "1";                               ');
         w('     imageContainer.style.width = "500px";                       ');
         w('     imageContainer.style.top = x.stlye.top;                     ');
         w('   }                                                             ');

         w('   function normalImg(x) {                                       ');
         w('     x.style.width = "10px"                                      ');
         w('     imageContainer.src = "";                                    ');
         w('     imageContainer.opacity = "0";                               ');
         w('     imageContainer.style.width = "25px";                        ');
         w('     imageContainer.style.top = "0px";                           ');
         w('   }                                                             ');
         w(' </script>                                                       ');


      //? Write the Page Header Stuff
         w(' <body gproperties="fixed">                                      ');
         w(' <div class="imageContainer">                                    ');
         w('   <img src="" name="imageContainer" class="fixedContainer" '
               + 'style="width:100px">                                       ');
         w(' </div>                                                          ');

       //  x = 0;
       //  DoW x < 1;
       //    x = x + 1;
       //    HTMLLINE = %Trim( HDR(x));
       //    ExSr Wrt_HTML;
       //  EndDo;
         //? Write the "Last Updated" line.
         RightNow = $TimeStamp();
      /END-FREE
     C                   Move      RightNow      DateNow
     C                   Move      RightNow      TimeNow
      /FREE
         HTMLLINE = %Trim( HTML(1))
             + '  '
             + %Trim( %Char(DateNow)
             + ' @ '
             + %Char(TimeNow) )
             + %Trim( HTML(3) );
         ExSr Wrt_HTML;

        HTMLLINE = '<ul style="list-style-type:circle">';
        ExSr      Wrt_HTML;

        ThisList = 'First One';
        DoW ThisList <> ' ';
          ThisList = *Blanks;
          Exec SQL // Get Valid Order Forms
            SELECT     FMORLSEAS.HSSEAS||FMORLSEAS.HSLIST
                 ,     '<li><h4><a href="#'||FMORLH.HLLIST||'">'
                        ||trim(FMORLSEAS.HSSEAS)||' Order Forms - '||
                        trim(FMORLH.HLDESC) || '</a></h4></li>'
            INTO      :ListDS
            FROM       FMINVT     as FMINVT
               ,       FMORLS     as FMORLS
               ,       FMORLH     as FMORLH
               ,       FMORLSEAS  as FMORLSEAS
            WHERE      FMORLSEAS.HSLIST = FMORLS.OLLIST
              AND      FMORLS.OLLIST    = FMORLH.HLLIST
              AND      FMINVT.IMITEM    = FMORLS.OLITEM
              AND      FMINVT.IMSIZE    = FMORLS.OLSIZE
              AND      FMINVT.IMSTAT    = 'A'
              AND      FMORLSEAS.HSSNCD in
                            (:#SeasCode1# , :#SeasCode2#, :#SeasCode3#)
              AND      FMORLSEAS.HSSEAS || FMORLSEAS.HSLIST >
                       :LastList
            ORDER BY   FMORLSEAS.HSSEAS
                 ,     FMORLSEAS.HSLIST
            FETCH FIRST ROW ONLY;
          if ThisList <> ' ';
            LastList = ThisList;
            HTMLLINE = ListHTML;
            ExSr      Wrt_HTML;
          endif;
        enddo;

        HTMLLINE = '</ul></p>';
        ExSr      Wrt_HTML;

        HTMLLINE = '</br></br></br></br></br></br></br></br></br></br></br>';
        ExSr      Wrt_HTML;

       EndSr;

       //?  ...........................................................
       //?  :      Footer - Write HTML code for Page Footer           :
       //?  :.........................................................:

       BegSr Footer;

         //? End the Table.
         w('</table></center>');
         //? End the body and html
         w('</body></html>');

       EndSr;


       //?  ...........................................................
       //?  :      GetData - Get selected A/R Open information        :
       //?  :.........................................................:

       BegSr GetData;

         Exec SQL
            DECLARE      C1 cursor for

            SELECT     FMORLSEAS.HSSNCD
                 ,     FMORLSEAS.HSSEAS
                 ,     FMORLSEAS.HSLIST
                 ,     FMORLH.HLDESC
                 ,     FMINVT.IMITEM
                 ,     FMINVT.IMSIZE
                 ,     FMINVT.IMDES1
                 ,     FMINVT.IMQTAV
                 ,     FMINVT.IMSEL1
                 ,     FMSIZD.SZLONG
                 ,     FMORLS.OLRDYC

            FROM       FMINVT     as FMINVT
               ,       FMORLH     as FMORLH
               ,       FMORLS     as FMORLS
               ,       FMORLSEAS  as FMORLSEAS
               ,       FMSIZD     as FMSIZD

            WHERE      FMORLSEAS.HSLIST = FMORLS.OLLIST
              AND      FMINVT.IMITEM    = FMORLS.OLITEM
              AND      FMINVT.IMSIZE    = FMORLS.OLSIZE
              AND      FMORLH.HLLIST    = FMORLS.OLLIST
              AND      FMINVT.IMSIZE    = FMSIZD.SZCODE
              AND      FMINVT.IMSTAT    = 'A'
              AND      FMORLSEAS.HSSNCD in
                             (:#SeasCode1# , :#SeasCode2#, :#SeasCode3#)

            ORDER BY  FMORLSEAS.HSSNCD
                   ,  FMORLSEAS.HSSEAS
                   ,  FMORLSEAS.HSLIST
                   ,  FMORLS.OLSEQ#
                   ,  FMORLS.OLLOOK

            FOR READ ONLY;

      /End-Free

      //  Open the SQL recordset for Screen 01
      /FREE
       exec sql
                         Open      C1;

       exec sql

           INSERT INTO FINISHOUT

           SELECT     FMINVT.IMITEM
                ,     FMINVT.IMSIZE
                ,     FMINVT.IMDES1
                ,     FMINVT.IMQTAV
                ,     FMSIZD.SZLONG
                ,     Current DATE
                ,     Current TIME
                ,     FMORLS.OLRDYC
           FROM       FMINVT     as FMINVT
              ,       FMORLS     as FMORLS
              ,       FMORLSEAS  as FMORLSEAS
              ,       FMSIZD     as FMSIZD
           WHERE      FMINVT.IMQTAV    > 0
             AND      FMORLSEAS.HSLIST = FMORLS.OLLIST
             AND      FMINVT.IMITEM    = FMORLS.OLITEM
             AND      FMINVT.IMSIZE    = FMORLS.OLSIZE
             AND      FMINVT.IMSIZE    = FMSIZD.SZCODE
             AND      FMINVT.IMSTAT    = 'A'
             AND      FMORLSEAS.HSSNCD in
                                   (:#SeasCode1# , :#SeasCode2#, :#SeasCode3#);


       EndSr;

       //?  ...........................................................
       //?  :      CloseData - Close Data                             :
       //?  :.........................................................:

       BegSr CloseData;

         //  Close the SQL recordset for Screen 01
       exec sql
                         Close     C1;

       EndSr;

       //?  ...........................................................
       //?  :      ClrData - Clear the HTML Output file               :
       //?  :.........................................................:

       BegSr ClrData;

         //  Insert HTML Code into the HTML Output File
       exec sql

          delete from htmloutf;

       exec sql

          delete from finishout;

       EndSr;

       //?  ...........................................................
       //?  :      Wrt_HTML - Write records to HTMLOUTF               :
       //?  :.........................................................:

       BegSr Wrt_HTML;

         //  Clear all records from the file
       exec sql

          INSERT INTO HTMLOUTF VALUES(:HTMLLINE);

       EndSr;

       //?  ...........................................................
       //?  :      ReadData - Read Data                               :
       //?  :.........................................................:

       BegSr ReadData;

         //  Read Sow Schedule Records for Selected Week
       exec sql
        Fetch C1 into :Available_DS;

         If SQLSTT = '02000';                                                 //?Read until EOF
           EndOfFile = *On;
           *InLR     = *On;
         Else;
           EndOfFile = *Off;
           If AVAIL < 0;
             AVAIL = 0;
           EndIf;
         EndIf;

       EndSr;


       //?  ...........................................................
       //?  :      *INZSR - Initialization Subroutine                 :
       //?  :.........................................................:

       BegSR *InzSr;

      /END-FREE
     C     *Entry        PList
     C                   Parm                    #SIZE#            3
     C                   Parm                    #SeasCode1@       2
     C                   Parm                    #SeasCode2@       2
     C                   Parm                    #SeasCode3@       2

     C                   Move      #SeasCode1@   #SeasCode1#       2 0
     C                   Move      #SeasCode2@   #SeasCode2#       2 0
     C                   Move      #SeasCode3@   #SeasCode3#       2 0

     C     TableKey      KList
     C                   KFld                    Table             2
     C                   KFld                    TableCd           6

      /FREE
         Table   = 'RC';
       EndSR;
      /END-FREE

       DCL-PROC W;
         DCL-PI *n;
           HtmlLine Char(256) value;
         END-PI;

         If HTMLLINE <> ' '; //  Write a line of HTML to file.
           Exec SQL INSERT INTO HTMLOUTF VALUES(:HTMLLINE);
         EndIf;

       END-PROC;
**  HTML Source
<center><Font Size=4    color="red">LAST UPDATED:
?02 ****    Insert update date & time Stamp here   *****
</br></font>
<table border="1" bordercolor="darkblue" CELLPADDING="2" CELLSPACING="0">
<tr><td><font size=6    color="darkblue"><center>
?06 ****    Insert Size Code here   *****
</center></font></td><td></td><td><font size=6    color="darkblue"><center>Week of:
?07 ****    Insert Ready Week here   *****
</center></font></td><td></td></tr>
<tr><td><center>ITEM<br>NUMBER</center></td><td><center>SIZE</br>CODE</center></td><td>DESCRIPTION
</td><td><center>QTY</BR>AVAIL</center></td><td><center>READY</BR>COLOR</center></td>
<td><center>ORDER</BR>QTY</center></td></tr>
</table></center>
?14 ****    Not used yet    ****
?15 ****    Not used yet    ****
**  PAGE HEADER STUFF
<body gproperties="fixed">









**  TABLE HEADER ROW
<table border="1" bordercolor="darkblue" CELLPADDING="2" CELLSPACING="0">
<center><table border="2" CELLPADDING="2" CELLSPACING="0" bordercolor="darkblue">
<colgroup width="8%" align="center"></colgroup>
<colgroup width="6%" align="center"></colgroup>
<colgroup width="49%" align="left"></colgroup>
<colgroup width="8%" align="center"></colgroup>
<colgroup width="16%" align="center"></colgroup>
<colgroup width="10%" align="center"></colgroup>
<tr>
 <td width="8%"><center>ITEM<br>NUMBER</center></td>
 <td width="6%"><center>SIZE</br>CODE</center></td>
 <td width="49%">DESCRIPTION</td>
 <td width="8%"><center>QTY</BR>AVAIL</center></td>
 <td width="16%"><center>READY</BR>COLOR</center></td>
 <td width="10%"><center>ORDER</BR>QTY</center></td>
</tr>
