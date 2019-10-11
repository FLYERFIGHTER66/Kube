     **Free
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI UPLITMPICF;
           dcl-parm itemSize char(16);
         END-PI;

       // Override to the UPLITMPICF member to build the FTP script
       qSys2Cmd(
        'OVRDBF FILE(QFTPSRC) TOFILE(QFTPSRC) MBR(UPLITMPICF) OVRSCOPE(*JOB)');

       // Clear the FTP files
       qSys2Cmd('CLRPFM FILE(QFTPSRC) MBR(UPLITMPICF)');
       qSys2Cmd('CLRPFM FILE(QFTPSRC) MBR(UPLITMPICL)');

       // Build the FTP script
       wf('CLOSE');
       wf('CLOSE');
       wf('CLOSE');
       wf('NAMEFMT 1');
       wf('LCD  ''/www/zendphp7/htdocs/PICTURES/''');
       wf('OPEN ftp.kubepak.net');
       wf('USER kubepak.net   Kubepak3114#');
       wf('CD   /public/images/KP_Items');
       wf('PUT  ' + %trim(itemSize) + '.jpg');
       wf('CLOSE');

       // Give the file a few seconds to become available
       qSys2Cmd('DLYJOB DLY(4)');

       // Send the FTP script
       qSys2Cmd('SBMJOB ' +
                'CMD(SENDFTP INPUT(UPLITMPICF) ' +
                'OUTPUT(UPLITMPICL)) JOB(SENDFTP) ' +
                'JOBQ(QBATCH2)');

       *InLR = *On;
       Return;

       //---Write FTP-----------------------------------------------------------
       dcl-proc wf;
         dcl-pi *n;
           ftp_statement char(80) const;
         end-pi;
         Exec SQL INSERT INTO QFTPSRC VALUES(0, 0, :ftp_statement);
       END-PROC;

       //---System Command -----------------------------------------------------
       dcl-proc qSys2Cmd;
         DCL-PI *n;
           Command Char(1000) value;
         END-PI;
         exec sql CALL QSYS2.QCMDEXC(:Command);
       END-PROC;
