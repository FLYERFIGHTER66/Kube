     **Free
         //  This program will read through all spool files for the current user
         //  and extract program field references from compilation reports. To use
         //  this program, clear as many spool files as possible, then compile the
         //  program(s) you wish to cross reference.  Then run this program.  the
         //  results will be placed in library: METADATA in a file named: PGMFLDXREF

        /COPY QFunctDefn,#CopyRight  // Kube-Pak Corporation. All rights reserved.
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI PGMFLDXREF;
             DCL-PARM PROGRAM CHAR(10) Const;
         END-PI;

         dcl-ds PgmInfoDs    //System Data Structure
             psds
         end-ds ;

         dcl-pr qCmdExc extpgm ;
             *n char(1000) options(*varsize) const ;
             *n packed(15:5) const ;
         end-pr ;

         CrtTemp();     // Create spoolpf in qtemp
         GetList();     // Get a list of the user's spool files (QTEMP/SPLISTPF)
         WrkList();     // Work through the list scrubbing each sploof file for field data

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

           Exec SQL // Drop temporary file from previous runs
             DROP TABLE QTEMP/SPLISTPF;

           Exec SQL // Create temporary file to store spool data
             CREATE TABLE QTEMP/SPLISTPF
             (SPOOLDATA CHAR (132 ) NOT NULL WITH DEFAULT);

           Command =
              'WRKSPLF SELECT(*CURRENT *OUTQ) OUTPUT(*PRINT)';
           qCmdExc(Command:%len(%trim(Command)));

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

           Exec SQL // Get Record to Process
             Declare C1 Cursor for
             Select * FROM QTEMP/SPLISTPF;

           Exec SQL Fetch c1 into :SPLISTDS;
           DoW SQLSTATE = '00000';
             If SQLState = '00000';
               //PrcSplf(Spool_Name);
               PrcSplf();
             EndIf;
             Exec SQL Fetch c1 into :SPLISTDS;
           EndDo;

         end-proc;
      //------------------------------------------------------------------------
      // PrcSplf();     // Process the Spool File
      //------------------------------------------------------------------------
         dcl-proc PrcSplf;

           dcl-ds SpoolDS;
             dcl-subf Spool_Data char(132);
           end-ds;

           Exec SQL delete from qtemp/spoolpf;

         Command =
            'CPYSPLF   FILE(' + %Trim(Spool_Name) +
                  ') TOFILE(QTEMP/SPOOLPF) JOB(123456/USER/JOB)';
         qCmdExc(Command:%len(%trim(Command)));

         Exec SQL
           Select
             :SpoolName,
             substr(spooldata,10,18),
             substr(spooldata,28,20)
           into :spoolds
           from qtemp/spoolpf
           where rrn(spoolpf) between
             (SELECT rrn(spoolpf) from qtemp/spoolpf
             WHERE SPOOLPF like '%Global Field References:%')  and      -1 +
             (SELECT rrn(spoolpf) from qtemp/spoolpf
             WHERE SPOOLPF like '%E N D   O F   C R O S S   R E F E R E N C E%')
           and spoolpf not like '%References (D=Defined M=Modified)%'
           and substr(spoolpf,09,1) =' '
           and substr(spoolpf,10,1)<>' '
           and substr(spoolpf,10,1)<>'*'
           and substr(spoolpf,120,4)<>'Page';

         EndDo;

         end-proc;
