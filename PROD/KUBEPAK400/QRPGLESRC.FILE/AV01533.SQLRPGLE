     **Free
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI AV01533;
         END-PI;

         dcl-pr qCmdExc extpgm ;
             *n char(1000) options(*varsize) const ;
             *n packed(15:5) const ;
         end-pr ;

         dcl-pr SENDFTP extpgm ;
             InputFile char(10) const ;
             OutputFile char(10) const ;
         end-pr ;

         DCL-S Monday        date;              //Monday Date
         DCL-S Day_Of_Week   zoned(1:0);        //Day of the Week MON=0-->SUN=6
         DCL-S Command VARCHAR(1000);
         DCL-S thisMonday CHAR(8) Inz('20170130');
         DCL-S STMF VARCHAR(256) Inz(
           '/kube pak/Avail_Out/AV_001533_');        // Availability Output Directory

         Day_Of_Week = %rem(%diff(%date():d'01/01/0001':*days):7); // *Mon=0 ... Sun=6
         Monday = %date() - %days(Day_Of_Week);
         If Day_Of_Week >= 4;   // If it's Friday or Later, add one week
           Monday += %Days(7);
         ENDIF;

         thisMonday = %Char(Monday:*ISO0);

         Exec SQL call QSYS2.QCMDEXC('CHGCURLIB CURLIB('||mySchema||')' );

         STMF = STMF
            + %trim( %char(%timestamp():*iso0 ) ) + '.txt';

         Exec SQL // Delete Ball x-mit file
           DELETE from FAV_01533;
           SQLSTATE = SQLSTATE;

         Exec SQL // Recreate Table
           CREATE or REPLACE TABLE FAV_01533 (
             RECORDTYPE   CHAR (02 ) NOT NULL WITH DEFAULT,
             COLUMN2      CHAR (22 ) NOT NULL WITH DEFAULT,
             COLUMN3      CHAR (16 ) NOT NULL WITH DEFAULT,
             DATEYYYYMMDD CHAR (10 ) NOT NULL WITH DEFAULT,
             COLUMN5      CHAR (10 ) NOT NULL WITH DEFAULT,
             COLUMN6      CHAR (03 ) NOT NULL WITH DEFAULT,
             COLUMN7      CHAR (02 ) NOT NULL WITH DEFAULT);
           SQLSTATE = SQLSTATE;

         Exec SQL //  Create Record Type '01'
           INSERT INTO
             FAV_01533
             VALUES(
               '01',
               'A103585',
               'planter',
               char(current date),
               char(current time),
               '',
               '');
           SQLSTATE = SQLSTATE;

           Exec SQL  // Create Record Type '02' for all Standard Plug Inventory
           INSERT INTO
             FAV_01533 (
              SELECT '02'                               AS RECORDTYPE
                  , TRIM(ITEM_NUMBER)||trim(ITEM_SIZE)  AS COLUMN2
                  , '0'                                 AS COLUMN3
                  , char(READY_DATE_7 + 19000000)       AS DATEYYYYMMDD
                  , INT(SUM(QUANTITY_AVAILABLE))        AS COLUMN5
                  , 'TRY'                               AS COLUMN6
                  , '0'                                 AS COLUMN7
              FROM     Kube_Pak_Standard_Plug_Inventory
              WHERE    VIEW_CONTROL_TYPE = 'Ball Seed'
              --and    SowDate >= NEXT_SOW_DATE_SEED
                and    ( Quantity_Available >= 1 or Quantity_Available = 0 )
              GROUP BY ITEM_NUMBER
                     , ITEM_SIZE
                     , READY_DATE_7
              ORDER BY READY_DATE_7);
           SQLSTATE = SQLSTATE;

         Exec SQL //  Create Record Type '99'
           INSERT INTO
             FAV_01533
             VALUES(
               '99',
               '',
               '',
               '',
               '',
               '',
               '');
           SQLSTATE = SQLSTATE;

         //  Build text file on IFS
         Command = 'CPYTOIMPF FROMFILE(FAV_01533)'
            +  ' TOSTMF(''' + %trim(STMF) + ''')'
            +  ' STMFCODPAG(*STDASCII) RCDDLM(*CRLF) DTAFMT(*DLM) STRDLM(*NONE)'
            +  ' STRESCCHR(*NONE) RMVBLANK(*TRAILING) FLDDLM(*TAB)';
         QCmdExc(Command:%Len(%Trim(Command)));

         //  Send File Via FTP to Vendor
         SENDFTP('AV01533FTP':'AV01533LOG');

         //  Copy TGMSDATA version to Archive
         Command = 'CPYF FROMFILE(TGMSDATA/FAV_01533)' +
          ' TOFILE(ARCHIVE/FAV_01533)' +
          ' FROMMBR(*FIRST)' +
          ' TOMBR(*FROMMBR)' +
          ' MBROPT(*REPLACE) FMTOPT(*MAP)' +
          ' CRTFILE(*YES)';
         QCmdExc(Command:%Len(%Trim(Command)));

         *InLR = *On;
         Return;
