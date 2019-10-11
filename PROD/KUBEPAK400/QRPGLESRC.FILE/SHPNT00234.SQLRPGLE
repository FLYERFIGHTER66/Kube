     **Free

         //  :````````````````````````````````````````````````````````````:
         //  : Send Shipping Notifications: 00234 GLOECKNER               :
         //  :............................................................:
         //  :````````````````````````````````````````````````````````````:
         //  : Created:  Feb 2017    ? Kube-Pak Corporation ?    :
         //  :      by:  William J. Behr                                  :
         //  :............................................................:
        /COPY QFunctDefn,#CopyRight //Kube-Pak Corporation. All rights reserved.
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI SHPNT00234;
         END-PI;

         dcl-pr qCmdExc extpgm ;
             *n char(1000) options(*varsize) const ;
             *n packed(15:5) const ;
         end-pr ;

         dcl-s CUST packed(6:0) inz(00234);
         DCL-S Command VARCHAR(1000);
         DCL-S PATH VARCHAR(256) Inz('/kube pak/CSV_Out/Ship_Notice/');
         DCL-S FILE VARCHAR(256) Inz('SHIP_NOTICE.00234');
         DCL-S STMF VARCHAR(256);
         DCL-S HTML VARCHAR(256);
         DCL-S EMAIL VARCHAR(256);
         DCL-S Records Packed(15:5);

         Exec SQL Drop Table QTEMP/SHIPNOTICE;
         Exec SQL
           CREATE TABLE QTEMP/SHIPNOTICE
           (ORDER_NUMBER   CHAR (20 ) NOT NULL WITH DEFAULT,
           KP_ORDER        CHAR (15 ) NOT NULL WITH DEFAULT,
           COMPANY_NAME    CHAR (35 ) NOT NULL WITH DEFAULT,
           ADDRESS1        CHAR (35 ) NOT NULL WITH DEFAULT,
           ADDRESS2        CHAR (35 ) NOT NULL WITH DEFAULT,
           CITY            CHAR (24 ) NOT NULL WITH DEFAULT,
           "STATE"         CHAR (05 ) NOT NULL WITH DEFAULT,
           ZIP             CHAR (09 ) NOT NULL WITH DEFAULT,
           SHIPDATE        CHAR (10 ) NOT NULL WITH DEFAULT,
           MASTER_TRACK#   CHAR (16 ) NOT NULL WITH DEFAULT,
           TRACKING_NUMBER CHAR (256 ) NOT NULL WITH DEFAULT);

         Exec SQL   //Write out header
           INSERT INTO QTEMP/SHIPNOTICE
             VALUES('Gloeckner PO#'
                  , 'Kube-Pak Order#'
                  , 'Customer Name'
                  , 'Address 1'
                  , 'Address 2'
                  , 'City'
                  , 'State'
                  , 'ZIP'
                  , 'Ship Date'
                  , 'FedEx Tracking #'
                  , 'Tracking Link');

         Exec SQL
           INSERT INTO QTEMP/SHIPNOTICE (
             SELECT upper(trim(OHPONO)), ORDER_1, COMPANY,
             ADDRESS1, ADDRESS2, CITY, STATE, ZIP, SHIPDATE, MASTER#,
             '=HYPERLINK("https://www.fedex.com/apps/fedextrack/?tracknumbers='
             || MASTER# || '&cntry_code=us","Track '|| MASTER# ||'")'
             FROM WRITE_SHP, FHORDR
             WHERE ORDER_1 <> 0 and ORDER_1 = OHORD# and OHBLCU = :CUST
             and MASTER# not in (Select MASTER# from WRITE_SHPX)

               union

             SELECT upper(trim(OHPONO)), ORDER_2, COMPANY,
             ADDRESS1, ADDRESS2, CITY, STATE, ZIP, SHIPDATE, MASTER#,
             '=HYPERLINK("https://www.fedex.com/apps/fedextrack/?tracknumbers='
             || MASTER# || '&cntry_code=us","Track '|| MASTER# ||'")'
             FROM WRITE_SHP, FHORDR
             WHERE ORDER_2 <> 0 and ORDER_2 = OHORD# and OHBLCU = :CUST
             and MASTER# not in (Select MASTER# from WRITE_SHPX)

               union

             SELECT upper(trim(OHPONO)), ORDER_3, COMPANY,
             ADDRESS1, ADDRESS2, CITY, STATE, ZIP, SHIPDATE, MASTER#,
             '=HYPERLINK("https://www.fedex.com/apps/fedextrack/?tracknumbers='
             || MASTER# || '&cntry_code=us","Track '|| MASTER# ||'")'
             FROM WRITE_SHP, FHORDR
             WHERE ORDER_3 <> 0 and ORDER_3 = OHORD# and OHBLCU = :CUST
             and MASTER# not in (Select MASTER# from WRITE_SHPX)

               union

             SELECT upper(trim(OHPONO)), ORDER_4, COMPANY,
             ADDRESS1, ADDRESS2, CITY, STATE, ZIP, SHIPDATE, MASTER#,
             '=HYPERLINK("https://www.fedex.com/apps/fedextrack/?tracknumbers='
             || MASTER# || '&cntry_code=us","Track '|| MASTER# ||'")'
             FROM WRITE_SHP, FHORDR
             WHERE ORDER_4 <> 0 and ORDER_4 = OHORD# and OHBLCU = :CUST
             and MASTER# not in (Select MASTER# from WRITE_SHPX)

               union

             SELECT upper(trim(OHPONO)), ORDER_5, COMPANY,
             ADDRESS1, ADDRESS2, CITY, STATE, ZIP, SHIPDATE, MASTER#,
             '=HYPERLINK("https://www.fedex.com/apps/fedextrack/?tracknumbers='
             || MASTER# || '&cntry_code=us","Track '|| MASTER# ||'")'
             FROM WRITE_SHP, FHORDR
             WHERE ORDER_5 <> 0 and ORDER_5 = OHORD# and OHBLCU = :CUST
             and MASTER# not in (Select MASTER# from WRITE_SHPX)

               order by COMPANY, MASTER#       );

         Exec SQL Select count(*) into :Records from QTEMP/SHIPNOTICE;

         FILE = %Trim(FILE) + '_' + %Trim(%Char(%Date():*ISO0))
                            + '_' + %Trim(%Char(%Time():*HMS0));

         // Create .CSV file
         Command = 'DB2XTOOLS/DB2CSV' +
         ' FILENAME(QTEMP/SHIPNOTICE)' +
         ' TOFILENAME(' + %Trim(FILE) + ')' +
         ' IFSPATH(''' + PATH + ''')' +
         ' ROWDLM(*CRLF)' +
         ' FLDDLM('','')' +
         ' DECPNT(*PERIOD)' +
         ' STRDLM(''"'')' +
         ' SHOW(*NO)';
         QCmdExc(Command:%Len(%Trim(Command)));

         HTML = '/Kube pak/PRODUCTION APPLICATIONS/iSeries Email/' +
                'Shipping Notification.html';
         STMF = PATH + FILE + '.csv'')';

         If Records > 1;     // Only Send if there is data


           //  Format Email Command
           Command = 'EMLHTML2'
           + ' SUBJECT(''Shipping Notification'')'
           + ' FROMNAME(''Kube-Pak'')'
           + ' FROMADDR(''donotreply@kubepak.com'')'
           + ' TO(';

           Exec SQL  // Get email addresses to use (code TRK is allowed to have multiples)
           DECLARE  C1 cursor for
             SELECT trim( EMAIL ) || '/''' || trim(EMNAME) || '''/*TO'
              from  FMEMAIL
             WHERE  EMCODE = 'TRK'
               and  EMACCT = :CUST
             For Read Only;

           Exec SQL  Close C1;
           Exec SQL  Open C1;
           Exec SQL  Fetch C1 into :EMAIL;
           DoW SQLState = '00000';
             Command = %Trim(Command) + ' ' + EMAIL;
             Exec SQL  Fetch C1 into :EMAIL;
           ENDDO;
           Exec SQL  Close C1;

           Command = %Trim(Command)
           + ' BCC@KUBEPAK.NET/''Kube-Pak BCC''/*BCC)'
           + ' HTML(''' + %Trim(HTML) + ''')'
           + ' STMF(''' + %Trim(STMF) ;


           // Send Email
           QCmdExc(Command:%Len(%Trim(Command)));

           Exec SQL  //  Insert Tracking numbers into WRITE_SHPX to indicate sent
             Insert into WRITE_SHPX
              ( Select Distinct trim(MASTER_TRACK#)
                  from QTEMP/SHIPNOTICE
                 where MASTER_TRACK# <> 'FedEx Tracking #');

         EndIf;

         Command = 'MOV OBJ(''' + %Trim(STMF) +
                   ' TODIR(''' + %Trim(PATH) + 'Sent/'')';
         QCmdExc(Command:%Len(%Trim(Command)));

         *InLR = *On;
