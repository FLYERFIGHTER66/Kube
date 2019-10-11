**Free
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI AV01533Z;
         END-PI;
         dcl-pr qCmdExc extpgm ;
             *n char(1000) options(*varsize) const ;
             *n packed(15:5) const ;
         end-pr ;
         dcl-pr SENDFTP extpgm ;
             InputFile char(10) const ;
             OutputFile char(10) const ;
         end-pr ;
         DCL-DS RMINVT_DS extname('FMINVT');      //Item Master File Data Structure
         END-DS;
         DCL-S Monday date;              //Monday Date
         DCL-S thisMonday Date;          //Monday Date
         DCL-S thisSow Date;
         DCL-S nextSow Date;
         DCL-S Command VARCHAR(1000);
         DCL-S STMF VARCHAR(256) Inz(
           '/kube pak/Avail_Out/AV_001533_');        // Availability Output Directory


         STMF = STMF
            + %trim( %char(%timestamp():*iso0 ) ) + '_Zero.txt';

         InitializeWorkTable(); // Delete and recreate the FAV_01533Z Work Table
         Write01Record();       // Create Record Type '01'
         Write02Records();      // Create Record Type '02' For Each Item
         Write99Record();       // Create Record Type '99'
         BuildTextFile();       //  Build text file on IFS
         SENDFTP('AV01533FTP':'AV01533LOG');  //  Send File Via FTP to Vendor

         *InLR = *On;
         Return;

      //--------------------------------------------------------------------------------------------
       DCL-PROC InitializeWorkTable;
         Exec SQL // Delete Ball x-mit file
           DELETE FROM TGMSDATA/FAV_01533Z;
           SQLSTATE = SQLSTATE;

         Exec SQL // Recreate Table
           CREATE or REPLACE TABLE TGMSDATA/FAV_01533Z (
             RECORDTYPE   CHAR (02 ) NOT NULL WITH DEFAULT,
             COLUMN2      CHAR (22 ) NOT NULL WITH DEFAULT,
             COLUMN3      CHAR (16 ) NOT NULL WITH DEFAULT,
             DATEYYYYMMDD CHAR (08 ) NOT NULL WITH DEFAULT,
             COLUMN5      CHAR (10 ) NOT NULL WITH DEFAULT,
             COLUMN6      CHAR (03 ) NOT NULL WITH DEFAULT,
             COLUMN7      CHAR (02 ) NOT NULL WITH DEFAULT);
           SQLSTATE = SQLSTATE;
       END-PROC;
      //--------------------------------------------------------------------------------------------
       DCL-PROC Write01Record;
         Exec SQL //  Create Record Type '01'
           INSERT INTO
             TGMSDATA.FAV_01533Z
             VALUES(
               '01',
               'A103585',
               'planter',
               char(current date),
               char(current time),
               '',
               '');
           SQLSTATE = SQLSTATE;
       END-PROC;
      //--------------------------------------------------------------------------------------------
       DCL-PROC Write02Records;
         Exec SQL  // Write zero records for previous 2 weeks
           INSERT INTO TGMSDATA.FAV_01533Z (
             Select '02'
               ,  trim(IMITEM)||trim(IMSIZE)
               ,  '0'
               ,  MONDAY_DATE_CYYMMDD + 19000000
               ,  0
               ,  'TRY'
               ,  '0'
               from   MONDAYS,
                      KUBEPAK_PLUG_ITEMS
                 join Inventory_View_Control_File on IMSOWC = PLUG_CTL_CODE
               Where Monday_Date between next_sow_date_seed - 14 days
                                     and next_sow_date_seed - 1 days
                 and PLUG_CTL_TYPE = 'Ball Seed'  )  ;
       END-PROC;
      //--------------------------------------------------------------------------------------------
       DCL-PROC Write99Record;
         Exec SQL //  Create Record Type '99'
           INSERT INTO
             TGMSDATA.FAV_01533Z
             VALUES(
               '99',
               '',
               '',
               '',
               '',
               '',
               '');
           SQLSTATE = SQLSTATE;

       //  Copy TGMSDATA version to Archive
       Command = 'CPYF FROMFILE(TGMSDATA/FAV_01533Z)' +
        ' TOFILE(ARCHIVE/FAV_01533Z)' +
        ' FROMMBR(*FIRST)' +
        ' TOMBR(*FROMMBR)' +
        ' MBROPT(*REPLACE)' +
        ' CRTFILE(*YES)';
       QCmdExc(Command:%Len(%Trim(Command)));

       END-PROC;
      //--------------------------------------------------------------------------------------------
       DCL-PROC BuildTextFile;
         //  Build text file on IFS
         Command = 'CPYTOIMPF FROMFILE(TGMSDATA/FAV_01533Z)'
            +  ' TOSTMF(''' + %trim(STMF) + ''')'
            +  ' STMFCODPAG(*STDASCII) RCDDLM(*CRLF) DTAFMT(*DLM) STRDLM(*NONE)'
            +  ' STRESCCHR(*NONE) RMVBLANK(*TRAILING) FLDDLM(*TAB)';
         QCmdExc(Command:%Len(%Trim(Command)));
       END-PROC;
      //--------------------------------------------------------------------------------------------
