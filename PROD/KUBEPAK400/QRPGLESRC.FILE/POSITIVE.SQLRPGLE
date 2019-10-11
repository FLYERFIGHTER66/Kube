     **Free
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI POSITIVE;
           dcl-parm ParmDate char(6) Const;  // Passed in MMDDYY format
         END-PI;

         dcl-ds PgmInfoDs    //System Data Structure
             psds
         end-ds ;

         dcl-pr qCmdExc extpgm ;
             *n char(1000) options(*varsize) const ;
             *n packed(15:5) const ;
         end-pr ;

         dcl-pr PP0001CL extpgm ;
            *n char(256) options(*varsize) const ;
         end-pr ;

         dcl-s UseCurrent char(1);

         DCL-S Stamp TIMESTAMP Inz(*SYS);
         DCL-S ThisDate6 zoned(6:0);
         DCL-S TextOut VARCHAR(126);
         DCL-S Command VARCHAR(512);
         DCL-S STMF VARCHAR(256) Inz(
           '/home/qssh/Positive/SFTP/BEB431ARI19P.');        // QSSH directory for SFTP
         DCL-S SPUT VARCHAR(256) Inz(
           'PUT /home/qssh/Positive/SFTP/BEB431ARI19P.');    // QSSH script put command
         DCL-S SCRF VARCHAR(256) Inz(
           '/home/qssh/Positive/SFTP/SFTP_Script.');         // QSSH script file name
         DCL-S FILE VARCHAR(256) Inz(
           '/home/qssh/Positive/SFTP/SFTP_Script.');         // QSSH script file name
         DCL-S HTML VARCHAR(256) Inz(
           '/home/qssh/Positive/PositivePay.html');     // Email Body for email

         If ParmDate = *Blanks;
           UseCurrent = 'Y';  // Use Current Date
           ThisDate6  = *Zeros;
          else;
           UseCurrent = 'N';  // Use Parm Date
           ThisDate6  = %Int(ParmDate);
         ENDIF;

         STMF = STMF + %SubSt(%char(Stamp):1:19) + '.txt'')';
         SPUT = SPUT + %SubSt(%char(Stamp):1:19) + '.txt';
         SCRF = SCRF + %SubSt(%char(Stamp):1:19) + '.txt'')';
         FILE = FILE + %SubSt(%char(Stamp):1:19) + '.txt';

         Exec SQL // Get Current Days Checks

           Declare C1 Cursor for

           SELECT 'C431001316300898 RA '||
                   RIGHT(TRIM('0000000000'||CHAR(AMCHEK)),10)          ||
                   RIGHT(TRIM('0000000000'||CHAR(DEC(AM$AMT*100))),10) ||
                   RIGHT(TRIM('000000'||CHAR(AMCKDT)),6) ||
                  (Select VMNAME from FMVEND where VMVEND = AMVEND)
           FROM    FAPMTH join FCALEN_ALL on AMTDAT = MDY6
           WHERE ( :UseCurrent = 'Y' and
                    DateFld = current date)
              or ( :UseCurrent = 'N' and
                    AMTDAT = :ThisDate6 )
           For Read Only;

         Exec SQL Drop Table QTEMP/POSPAY;
         Exec SQL CREATE TABLE QTEMP/POSPAY (CheckInfo CHAR (126));

         Exec SQL Close C1;
         Exec SQL Open C1;
         DoW SQLState = '00000';
           Exec SQL Fetch C1 into :TextOut;
           If SQLState = '00000';
             Exec SQL Insert into QTEMP/POSPAY values( :TextOut );
             SQLState = '00000';
           EndIf;
         EndDo;
         Exec SQL Close C1;


         //  Build text file on IFS
         Command = 'CPYTOIMPF FROMFILE(QTEMP/POSPAY) TOSTMF(''' + STMF
            +  ' STMFCODPAG(*STDASCII) RCDDLM(*CRLF) DTAFMT(*FIXED)'
            +  ' STRESCCHR(*NONE) FLDDLM('','')';
         QCmdExc(Command:%Len(%Trim(Command)));

         //  Build SFTP script for file created
         Exec SQL Drop Table QTEMP/PPSCRIPT;
         Exec SQL CREATE TABLE QTEMP/PPSCRIPT (FTPText CHAR (126));
         Exec SQL Insert into QTEMP/PPSCRIPT values( 'cd Upload' );
         Exec SQL Insert into QTEMP/PPSCRIPT values( :SPUT );
         Exec SQL Insert into QTEMP/PPSCRIPT values( 'QUIT' );

         Command = 'CPYTOIMPF FROMFILE(QTEMP/PPSCRIPT) TOSTMF(''' + SCRF
            +  ' STMFCODPAG(*STDASCII) RCDDLM(*CRLF) DTAFMT(*FIXED)'
            +  ' STRESCCHR(*NONE) FLDDLM('','')';
         QCmdExc(Command:%Len(%Trim(Command)));

         //  SFTP Positive pay to bank
         PP0001CL(FILE);  //Process Script File

         //  Email Results
         Command = 'EMLHTML2 SUBJECT(''Positive Pay'') FROMNAME(''Kube-Pak'')'
            + ' FROMADDR(''ap@kubepak.com'')'
            + ' TO(hr@kubepak.com/''Kube-Pak HR''/*TO'
            + ' ap@kubepak.com/''Kube-Pak AP''/*CC'
            + ' BCC@KUBEPAK.NET/''Kube-Pak BCC''/*BCC)'
            + ' HTML(''' + HTML + ''')'
            + ' STMF(''' + STMF ;
         QCmdExc(Command:%Len(%Trim(Command)));

         *InLR = *On;
         Return;
