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
         GetList();     // Get a list of the user's spool files
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

           Command =
              'WRKSPLF SELECT(*CURRENT *OUTQ) OUTPUT(*PRINT)';
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
               Select * into SPLISTDS FROM QTEMP/SPLISTPF
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

         ClrTemp();     // If spoolpf exists in qtemp, clear it.
           dcl-parm
         Command =
            'CPYSPLF   FILE(' + Spool_Name +
                  ') TOFILE(QTEMP/SPOOLPF) JOB(123456/USER/JOB)';
         qCmdExc(Command:%len(%trim(Command)));

         Exec SQL
           Select
             'THISPROGRAM',
             substr(spoolpf,10,18),
             substr(spoolpf,28,20)
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
      //------------------------------------------------------------------------
      // ClrTemp();     // Clear spoolpf in qtemp
      //------------------------------------------------------------------------
         dcl-proc ClrTemp;
             Exec SQL delete from qtemp/spoolpf;
         end-proc;

      //------------------------------------------------------------------------
