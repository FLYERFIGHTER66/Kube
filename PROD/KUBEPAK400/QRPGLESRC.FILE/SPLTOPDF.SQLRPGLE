      //Free
         //  This program will read through all spool files on given OUTQ and create
         //  PDF files for each spool file.

        /COPY QFunctDefn,#CopyRight  // Kube-Pak Corporation. All rights reserved.
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI SPLTOPDF;
             DCL-PARM OUTQ CHAR(10) Const;
         END-PI;

         dcl-ds PgmInfoDs    //System Data Structure
             psds
         end-ds ;

         dcl-pr qCmdExc extpgm ;
             *n char(1000) options(*varsize) const ;
             *n packed(15:5) const ;
         end-pr ;

         CrtTemp();     // Create spoolpf in qtemp
         GetList();     // Get a list of the OUTQ's spool files
         WrkList();     // Work through the list PDFing each one.

         *InLR = *On;


      //------------------------------------------------------------------------
      // CrtTemp();     // Create spoolpf in qtemp
      //------------------------------------------------------------------------
         dcl-proc CrtTemp;
           Exec SQL
             CREATE TABLE QTEMP/SPOOLPF
             (PROGRAMNAME CHARACTER  (10 ) NOT NULL WITH DEFAULT
             ,SPOOLDATA   CHARACTER (132 ) NOT NULL WITH DEFAULT);
         end-proc;

      //------------------------------------------------------------------------
      // GetList();     // Get a list of the user's spool files
      //------------------------------------------------------------------------
         dcl-proc GetList;
           dcl-s Command Char(256);

           Command =
            'WRKSPLF SELECT(*ALL ' + %Trim(OUTQ) + ') OUTPUT(*PRINT)';
           qCmdExc(Command:%len(%trim(Command)));

           Exec SQL // Create temporary file to store spool data
             CREATE TABLE QTEMP/SPLISTPF
             (SPOOLDATA CHAR (132 ) NOT NULL WITH DEFAULT);

           Command =
              'CPYSPLF FILE(QPRTSPLF) TOFILE(QTEMP/SPLISTPF) SPLNBR(*LAST)';
           qCmdExc(Command:%len(%trim(Command)));

           Exec SQL // Clear records that are not data records
             DELETE  FROM QTEMP/SPLISTPF WHERE
             substr(SPOOLDATA,13,10) <> USER;

         end-proc;

      //------------------------------------------------------------------------
      // WrkList();     // Work through the list scrubbing each sploof file for field data
      //------------------------------------------------------------------------
         dcl-proc WrkList;

           dcl-ds SpListDS;
             dcl-subf Spool_Data char(132);
             dcl-subf Spool_Name char(10) pos(1);
           end-ds;

           dcl-s Command Char(256);

           DoW SQLSTATE = '00000';

             Exec SQL // Get Record to Process
               Select * into :SPLISTDS FROM QTEMP/SPLISTPF
                 Fetch First Row Only;
             If SQLState = '00000';
               PrcSplf(Spool_Name);
             EndIf;
           EndDo;

         end-proc;
      //------------------------------------------------------------------------
      // PrcSplf();     // Process the Spool File
      //------------------------------------------------------------------------
         dcl-proc PrcSplf;

           dcl-ds SpoolDS;
             dcl-subf Spool_Data char(132);
           end-ds;

         end-proc;
      //------------------------------------------------------------------------
      // ClrTemp();     // Clear spoolpf in qtemp
      //------------------------------------------------------------------------
         dcl-proc ClrTemp;
             Exec SQL delete from qtemp/spoolpf;
         end-proc;

      //------------------------------------------------------------------------
