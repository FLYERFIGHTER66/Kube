      //Free
      // :````````````````````````````````````````````````````````````:
      // :         Future Plug Availability                           :
      // :............................................................:
      // :````````````````````````````````````````````````````````````:
      // : Created:  DEC. 2005              Kube-Pak Corporation      :
      // :      by:  William J. Behr                                  :
      // : Re-written 1/25/17 by William J. Behr                      :
      // :............................................................:
      // :````````````````````````````````````````````````````````````:
      // :   Program Description                                      :
      // :                                                            :
      // :   This program generates the HTML code for Future Plug     :
      // : Availablility.                                             :
      // :............................................................:
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI WEBBUILD03;
         END-PI;


         dcl-ds PgmInfoDs    //System Data Structure
             psds
         end-ds ;

      //  Function Prototypes
      /COPY QFunctFree,$_Dates

         dcl-pr w;
             *n char(256) value ;
         end-pr ;

         dcl-pr o;
             *n char(256) value ;
         end-pr ;

       // Definitions
         DCL-DS  FutureAVL_DS;
           ITEM                 char(12);
           SIZE                 char(03);
           DES1                 char(30);
           QTAVW1               zoned(7:0);
           QTAVW2               zoned(7:0);
           QTAVW3               zoned(7:0);
           QTAVW4               zoned(7:0);
           QTAVW5               zoned(7:0);
           BLDDATE              date;
           BLDTIME              time;
         END-DS;

         DCL-DS  RB_OPEN_DS     DTAARA('RB_OPEN');
           RB_Open_YN           char(1);
           RB_Open_Rest         char(31);
         END-DS;

         DCL-DS  Weeks;
           MMDD1  Char(5);  //Week 1
           MMDD2  Char(5);  //Week 2
           MMDD3  Char(5);  //Week 3
           MMDD4  Char(5);  //Week 4
           MMDD5  Char(5);  //Week 5
           MMDD   Char(5) Dim(5) POS(1);  //Header Dates
         END-DS;

      //  Fields
         DCL-S Stamp         TIMESTAMP Inz(*SYS);
         DCL-S ReadyDate7    zoned(7:0);        //Ready Date7
         DCL-S ReadyDate     date;              //Ready Date
         DCL-S RightNow      timestamp;         //Timestamp Now
         DCL-S DateNow       date;              //Date Now
         DCL-S Monday        date;              //Monday Date
         DCL-S Day_Of_Week   zoned(1:0);        //Day of the Week MON=0-->SUN=6
         DCL-S TimeNow       time;              //Time Now
         DCL-S Sav_SIZED     char(80);
         DCL-S x             zoned(2:0);
         DCL-S y             zoned(1:0);
         DCL-S z             zoned(1:0);
         DCL-S Week          date;
         DCL-S Desc          char(100);
         DCL-S CellVal01     char(50);
         DCL-S CellVal02     char(50);
         DCL-S CellVal03     char(50);
         DCL-S CellVal04     char(50);
         DCL-S CellVal05     char(50);
         DCL-S CellSuffix    char(1);

       //  Indicators
         DCL-S  EndOfFile  Ind;           // End Of File Ind.
         DCL-S  RB_Closed  Ind;           // Ready Bay Closed


      //   ...........................................................
      //   :    M A I N   C A L C U L A T I O N S                    :
      //   :.........................................................:

         In RB_OPEN_DS;

         If RB_Open_YN = '0';
           RB_Closed = *On;
          Else;
           RB_Closed = *Off;
         EndIf;

       //  Clear HTML Code from the HTML Output File
         exec sql delete from HTMLOUTN;
         exec sql delete from HTMLOUTNP;
         exec sql delete from READYFWDSC;
       //exec sql delete from HTMLOUTNH;
         ExSr GetData;  // Establish SQL Cursor

       //  Read through SQL cursor and Write HTML
         ExSr ReadData;   // Prime Read - Fetch Cursor for First Record

       //  Populate Variables
         BldDate = %date();
         BldTime = %Time();
         Day_Of_Week = %rem(%diff(%date():d'01/01/0001':*days):7); // *Mon=0 ... Sun=6
         Monday = %date() - %days(Day_Of_Week);
         If Day_Of_Week >= 4;   // If it's Friday or Later, add one week
           Monday += %Days(7);
         ENDIF;
         For z = 1 by 1 to 5;         // Get Weeks
           MMDD(z) = %subst(%char(Monday + %days(Z*7):*USA):1:5);
         EndFor;

         ExSr Wrt_COLS;   // Create Column headings for file output NOT html.

       // Start Writing HTML
         //  Write the Page Header Stuff
         w('<!DOCTYPE html>');
         w('<html>');
         w('  <head>');
         w('    <title>Future Plug Availablility</title>');
         w('  </head>');
         w('<body>');
         w('<!-- Created on IBM i with all-free RPG by William Behr -->');

         //  Write Floating Header Table Division
         w('<div id=FloatHeader style="width:710px; align:center" ><center>');
         w('  <table id="tableHeader" border="1" bordercolor="darkgreen" +
                  CELLPADDING="0" CELLSPACING="0">');
         w('   <colgroup width="75" align="center"></colgroup>');
         w('   <colgroup width="50" align="center"></colgroup>');
         w('   <colgroup width="300" align="left"></colgroup>');
         w('   <colgroup width="50" align="center"></colgroup>');
         w('   <colgroup width="50" align="center"></colgroup>');
         w('   <colgroup width="50" align="center"></colgroup>');
         w('   <colgroup width="50" align="center"></colgroup>');
         w('   <colgroup width="50" align="center"></colgroup>');
         w('   <colgroup width="18" align="center"></colgroup>');
         w('    <tr>');
         w('      <td><center>ITEM</br>NUMBER</center></td>');
         w('      <td><center>SIZE</br>CODE</center></td>');
         w('      <td>DESCRIPTION</td>');
         w('      <td><center>' + MMDD1 + '</center></td>');
         w('      <td><center>' + MMDD2 + '</center></td>');
         w('      <td><center>' + MMDD3 + '</center></td>');
         w('      <td><center>' + MMDD4 + '</center></td>');
         w('      <td><center>' + MMDD5 + '</center></td>');
         w('      <td><center> </center></td>');
         w('    </tr>');
         w('  </table>');
         o('</div>');

         //  Write Last Updated Division
         o('<div id=LastUpdate style="width:860px; align:center" >');
         w('  <Font Size=4 color="red"><center>LAST UPDATED:  ' +
                %Trim( %Char(%date():*USA) + ' @ '+ %Char(%time():*USA) ) +
               '</center></font>');
         o('</div>');

         //  Write Page Details Division
         o('<div id=DetailsTable align="center" +
                 style="height:550px; overflow:auto; width:710px">');
         w('<table id="tableDetails" border="1" bordercolor="darkgreen" +
                 CELLPADDING="0" CELLSPACING="0">');
         w('  <colgroup width="75" align="center"></colgroup>');
         w('  <colgroup width="50" align="center"></colgroup>');
         w('  <colgroup width="300" align="left"></colgroup>');
         w('  <colgroup width="50" align="center"></colgroup>');
         w('  <colgroup width="50" align="center"></colgroup>');
         w('  <colgroup width="50" align="center"></colgroup>');
         w('  <colgroup width="50" align="center"></colgroup>');
         w('  <colgroup width="50" align="center"></colgroup>');

       DoW not EndOfFile;
         w('<tr align="center"><td>'     +  %Trim(ITEM)       + '</td>'
           + '<td><a href="SizeCodes.htm#' + SIZE + '">' + SIZE + '</a></td>'
           + '<td align="left">'           +  %Trim(DESC)       + '</td>'
           + '<td>'                        +  %Trim(CellVal01)  + '</td>'
           + '<td>'                        +  %Trim(CellVal02)  + '</td>'
           + '<td>'                        +  %Trim(CellVal03)  + '</td>'
           + '<td>'                        +  %Trim(CellVal04)  + '</td>'
           + '<td>'                        +  %Trim(CellVal05)  + '</td></tr>');
         ExSr ReadData;
       EndDo;

       w('</table></center></div>');
       exec sql Close C1;

       //   ...........................................................
       //   :      GetData - Get selected A/R Open information        :
       //   :.........................................................:

       BegSr GetData;

         exec sql
           DECLARE      C1 cursor for
             SELECT     ITEM
                  ,     SIZE
                  ,     DES1
                  ,     QTAVW1 - 1
                  ,     QTAVW2 - 1
                  ,     QTAVW3 - 1
                  ,     QTAVW4 - 1
                  ,     QTAVW5 - 1
                  ,     "DATE"
                  ,     "TIME"
             FROM       READYFW
             WHERE      QTAVW1  > 1 and :RB_Open_YN = '1'
                or      QTAVW2  > 1 and :RB_Open_YN = '1'
                or      QTAVW3  > 1
                or      QTAVW4  > 1
                or      QTAVW5  > 1
             ORDER BY  DES1
                    ,  ITEM
                    ,  SIZE
           For Read only;

         exec sql Open C1;

       EndSr;


       //   ...........................................................
       //   :      Wrt_COLS - Write column descriptions to READYFWDSC :
       //   :.........................................................:

       BegSr Wrt_COLS;

         exec sql
           INSERT INTO   READYFWDSC
                     (   ITEM
                     ,   SIZE
                     ,   DES1
                     ,   QTAVW1
                     ,   QTAVW2
                     ,   QTAVW3
                     ,   QTAVW4
                     ,   QTAVW5)
           VALUES    (   'Item Number'
                     ,   'Sz'
                     ,   'Description'
                     ,   :MMDD1
                     ,   :MMDD2
                     ,   :MMDD3
                     ,   :MMDD4
                     ,   :MMDD5 );

       EndSr;


       //   ...........................................................
       //   :      ReadData - Read Data                               :
       //   :.........................................................:

       BegSr ReadData;
      //  Read Sow Schedule Records for Selected Week
         Dou SQLState <> '00000';
           exec sql Fetch C1 into :FutureAVL_DS;
           If SQLState <> '00000';  // Read until EOF
             EndOfFile = *On;
             *InLR     = *On;
             leavesr;
            Else;
             EndOfFile = *Off;
             If Size = '105' and Item = '5637' or       // Do not include these
                Size = '105' and Item = '5638' or
                Size = '105' and Item = '6943';
               Iter;
             EndIf;
           EndIf;
           leave;
         EndDo;

         If SQLState = '00000';
           If RB_Closed;
             QTAVW1 = *Zeros;
             QTAVW2 = *Zeros;
           EndIf;

           If %SubSt(ITEM:%Len(%Trim(ITEM)):1) = 'P';  // Last Character = "P" --> Partial
             Item = %SubSt(ITEM:1:%len(%Trim(ITEM))-1);  // Get Rid of "P"
             Desc = %Trim(DES1) + '<font color="red">-Partial</font>';
             CellSuffix = '%';
            Else;
             Desc = %Trim(DES1);
             CellSuffix = ' ';
           EndIf;

           CellVal01 = '-';
           CellVal02 = '-';
           CellVal03 = '-';
           CellVal04 = '-';
           CellVal05 = '-';

           If %Int(QTAVW1) > *Zero;
             CellVal01 = %Trim(%Char(%Int(QTAVW1))) + CellSuffix;
           EndIf;
           If %Int(QTAVW2) > *Zero;
             CellVal02 = %Trim(%Char(%Int(QTAVW2))) + CellSuffix;
           EndIf;
           If %Int(QTAVW3) > *Zero;
             CellVal03 = %Trim(%Char(%Int(QTAVW3))) + CellSuffix;
           EndIf;
           If %Int(QTAVW4) > *Zero;
             CellVal04 = %Trim(%Char(%Int(QTAVW4))) + CellSuffix;
           EndIf;
           If %Int(QTAVW5) > *Zero;
             CellVal05 = %Trim(%Char(%Int(QTAVW5))) + CellSuffix;
           EndIf;
         ENDIF;

       EndSr;

       //   ...........................................................
       //   :      Wrt_HTML - Write records to HTMLOUTN               :
       //   :.........................................................:

       DCL-PROC W;
         DCL-PI *n;
           HtmlLine Char(256) value;
         END-PI;

         If HTMLLINE <> ' ';
           //  Write a line of HTML to both files.
           exec sql INSERT INTO HTMLOUTN VALUES(:HTMLLINE);
           exec sql INSERT INTO HTMLOUTNP VALUES(:HTMLLINE);
         EndIf;

       END-PROC;

       DCL-PROC O;
         DCL-PI *n;
           HtmlLine Char(256) value;
         END-PI;

         If HTMLLINE <> ' ';
           //  Write a line of HTML to the file.
           exec sql INSERT INTO HTMLOUTN VALUES(:HTMLLINE);
         EndIf;

       END-PROC;
