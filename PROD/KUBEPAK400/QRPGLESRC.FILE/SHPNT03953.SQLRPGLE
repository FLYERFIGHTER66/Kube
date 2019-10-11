     **Free
         //  :````````````````````````````````````````````````````````````:  //
         //  : Send Shipping Notifications: 03953                         :  //
         //  :............................................................:  //
         //  :````````````````````````````````````````````````````````````:  //
         //  : Created:  Sept 2016              Kube-Pak Corporation      :  //
         //  :      by:  William J. Behr                                  :  //
         //  :............................................................:  //
        /COPY QFunctDefn,#CopyRight  // Kube-Pak Corporation. All rights reserved.
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI SHPNT03953;
         END-PI;

         dcl-pr qCmdExc extpgm ;
             *n char(1000) options(*varsize) const ;
             *n packed(15:5) const ;
         end-pr ;

         dcl-pr SENDFTP extpgm ;
             InputFile char(10) const ;
             OutputFile char(10) const ;
         end-pr ;

         dcl-s CUST packed(6:0) inz(03953);
         DCL-S Command VARCHAR(1000);
         DCL-S CARRIER VARCHAR(256) Inz('FedEx');
         DCL-S PATH VARCHAR(256) Inz('/kube pak/CSV_Out/Ship_Notice/');
         DCL-S FILE VARCHAR(256) Inz('SHIP_NOTICE.03953');
         DCL-S STMF VARCHAR(256);
         DCL-S HTML VARCHAR(256);
         DCL-S Records Packed(15:5);

         Exec SQL Drop Table QTEMP/SHIPNOTICE;
         Exec SQL
           CREATE TABLE QTEMP/SHIPNOTICE
           (ORDER_NUMBER   CHAR (20 ) NOT NULL WITH DEFAULT,
           CARRIER_NAME    CHAR (30 ) NOT NULL WITH DEFAULT,
           TRACKING_NUMBER CHAR (16 ) NOT NULL WITH DEFAULT);

         Exec SQL   //Write out header as in provided example
           INSERT INTO QTEMP/SHIPNOTICE (ORDER_NUMBER, CARRIER_NAME,
           TRACKING_NUMBER) VALUES('EHR Order#', 'Carrier', 'Tracking#');

         Exec SQL   //Write out shipping details
           INSERT INTO QTEMP/SHIPNOTICE (
             SELECT upper(trim(OHPONO)), :CARRIER, MASTER#
             FROM WRITE_SHP, FHORDR
             WHERE ORDER_1 <> 0 and ORDER_1 = OHORD# and OHBLCU = :CUST
             and MASTER# not in (Select MASTER# from WRITE_SHPX)
               union
             SELECT upper(trim(OHPONO)), :CARRIER, MASTER#
             FROM WRITE_SHP, FHORDR
             WHERE ORDER_2 <> 0 and ORDER_2 = OHORD# and OHBLCU = :CUST
             and MASTER# not in (Select MASTER# from WRITE_SHPX)
               union
             SELECT upper(trim(OHPONO)), :CARRIER, MASTER#
             FROM WRITE_SHP, FHORDR
             WHERE ORDER_3 <> 0 and ORDER_3 = OHORD# and OHBLCU = :CUST
             and MASTER# not in (Select MASTER# from WRITE_SHPX)
               union
             SELECT upper(trim(OHPONO)), :CARRIER, MASTER#
             FROM WRITE_SHP, FHORDR
             WHERE ORDER_4 <> 0 and ORDER_4 = OHORD# and OHBLCU = :CUST
             and MASTER# not in (Select MASTER# from WRITE_SHPX)
               union
             SELECT upper(trim(OHPONO)), :CARRIER, MASTER#
             FROM WRITE_SHP, FHORDR
             WHERE ORDER_5 <> 0 and ORDER_5 = OHORD# and OHBLCU = :CUST
             and MASTER# not in (Select MASTER# from WRITE_SHPX) );

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

         STMF = PATH + FILE + '.csv';

         If Records > 1;  //The header will be 1 record...  must have more than that

           SENDFTP('SH03953FTP':'SH03953LOG');
           Exec SQL  //  Insert Tracking numbers into WRITE_SHPX to indicate sent
             Insert into WRITE_SHPX
              ( Select trim(TRACKING_NUMBER)
                  from QTEMP/SHIPNOTICE
                 where TRACKING_NUMBER <> 'Tracking#' );
           Command = 'MOV OBJ(''' + %Trim(STMF) +
                     ''') TODIR(''' + %Trim(PATH) + 'Sent/'')';
                     QCmdExc(Command:%Len(%Trim(Command)));
         Else;  // Process only generatede a header move to "Empty" folder
           Command = 'MOV OBJ(''' + %Trim(STMF) +
                     ''') TODIR(''' + %Trim(PATH) + 'Sent/Empty/'')';
                     QCmdExc(Command:%Len(%Trim(Command)));
         EndIf;

         *InLR = *On;
