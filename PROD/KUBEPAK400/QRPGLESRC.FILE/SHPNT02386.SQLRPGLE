     **Free
         //  :````````````````````````````````````````````````````````````:
         //  : Send Shipping Notifications: 02386 GRIFFIN                 :
         //  :............................................................:
         //  :````````````````````````````````````````````````````````````:
         //  : Created:  Sept 2016            ? Kube-Pak Corporation ?    :
         //  :      by:  William J. Behr                                  :
         //  :............................................................:
        /COPY QFunctDefn,#CopyRight //Kube-Pak Corporation. All rights reserved.
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI SHPNT02386;
         END-PI;

         dcl-pr qCmdExc extpgm ;
             *n char(1000) options(*varsize) const ;
             *n packed(15:5) const ;
         end-pr ;

         dcl-s CUST packed(6:0) inz(02386);
         DCL-S Command VARCHAR(1000);
         DCL-S PATH VARCHAR(256) Inz('/kube pak/CSV_Out/Ship_Notice/');
         DCL-S FILE VARCHAR(256) Inz('SHIP_NOTICE.02386');
         DCL-S STMF VARCHAR(256);
         DCL-S HTML VARCHAR(256);
         DCL-S EMAIL VARCHAR(256);
         DCL-S Records Packed(15:5);

         Exec SQL Drop Table QTEMP/SHIPNOTICE;
         SQLSTATE = SQLSTATE;

         Exec SQL
           CREATE TABLE QTEMP/SHIPNOTICE
           (TRACKING_NUMBER  CHAR (16 ) NOT NULL WITH DEFAULT,
            SHIP_DATE        CHAR (10 ) NOT NULL WITH DEFAULT,
            ORDER_NUMBER     CHAR (30 ) NOT NULL WITH DEFAULT);
         SQLSTATE = SQLSTATE;

         Exec SQL   //Write out header
           INSERT INTO QTEMP/SHIPNOTICE (TRACKING_NUMBER, SHIP_DATE,
           ORDER_NUMBER) VALUES('Tracking#', 'Ship Date', 'Griffin Order#');
         SQLSTATE = SQLSTATE;

         Exec SQL
           INSERT INTO QTEMP/SHIPNOTICE (
             SELECT MASTER#, SHIPDATE, upper(trim(OHPONO))
             FROM WRITE_SHP, FHORDR
             WHERE ORDER_1 <> 0 and ORDER_1 = OHORD# and OHBLCU = :CUST
             and MASTER# not in (Select MASTER# from WRITE_SHPX)
               union
             SELECT MASTER#, SHIPDATE, upper(trim(OHPONO))
             FROM WRITE_SHP, FHORDR
             WHERE ORDER_2 <> 0 and ORDER_2 = OHORD# and OHBLCU = :CUST
             and MASTER# not in (Select MASTER# from WRITE_SHPX)
               union
             SELECT MASTER#, SHIPDATE, upper(trim(OHPONO))
             FROM WRITE_SHP, FHORDR
             WHERE ORDER_3 <> 0 and ORDER_3 = OHORD# and OHBLCU = :CUST
             and MASTER# not in (Select MASTER# from WRITE_SHPX)
               union
             SELECT MASTER#, SHIPDATE, upper(trim(OHPONO))
             FROM WRITE_SHP, FHORDR
             WHERE ORDER_4 <> 0 and ORDER_4 = OHORD# and OHBLCU = :CUST
             and MASTER# not in (Select MASTER# from WRITE_SHPX)
               union
             SELECT MASTER#, SHIPDATE, upper(trim(OHPONO))
             FROM WRITE_SHP, FHORDR
             WHERE ORDER_5 <> 0 and ORDER_5 = OHORD# and OHBLCU = :CUST
             and MASTER# not in (Select MASTER# from WRITE_SHPX) );
         SQLSTATE = SQLSTATE;

         Exec SQL Select count(*) into :Records from QTEMP/SHIPNOTICE;
         SQLSTATE = SQLSTATE;

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

         If Records > 1;   // Only Send if there is data

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
           QCmdExc(Command:%Len(%Trim(Command)));

           Exec SQL  //  Insert Tracking numbers into WRITE_SHPX to indicate sent
             Insert into WRITE_SHPX
              ( Select trim(TRACKING_NUMBER)
                  from QTEMP/SHIPNOTICE
                 where TRACKING_NUMBER <> 'Tracking#' );
         SQLSTATE = SQLSTATE;

         EndIf;

         Command = 'MOV OBJ(''' + %Trim(STMF) +
                   ' TODIR(''' + %Trim(PATH) + 'Sent/'')';
         QCmdExc(Command:%Len(%Trim(Command)));

         *InLR = *On;
