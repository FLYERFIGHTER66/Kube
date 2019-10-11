     **Free
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI #EXCEL;
           dcl-parm  FilePath char(80) Const;  //
           dcl-parm  FileName char(80) Const;  //
         END-PI;

         dcl-pr qCmdExc extpgm ;
             *n char(1000) options(*varsize) const ;
             *n packed(15:5) const ;
         end-pr;

         dcl-ds $Excel dtaara;
           PGMLOC char(80);
         end-ds;

         DCL-S ECHO VARCHAR(12) Inz('cmd /c echo ');
         DCL-S SPUT VARCHAR(23) Inz(' >>c:\Temp\kp_excel.bat');

         in $Excel;

         ExcCmd('STRPCO');

       // Send PC Commands
         PC_CMD('del c:\temp\kp_excel.bat');

         PC_CMD(ECHO + 'set a=' + %trim(PGMLOC) + SPUT);
         PC_CMD(ECHO + 'set b=' + %trim(FilePath) + SPUT);
         PC_CMD(ECHO + 'set c=' + %trim(FileName) + SPUT);
         PC_CMD(ECHO + 'echo %a%"%b%%c%"' + SPUT);

         PC_CMD('start c:\temp\kp_excel.bat');

         *InLR = *On;
         Return;

         dcl-proc PC_CMD;
           dcl-pi *n;
             PCCMD Char(123) const;
           end-pi;
           ExcCmd('STRPCCMD PCCMD(''' + %Trim(PCCMD) + ''') PAUSE(*NO)');
         end-proc PC_CMD;

         dcl-proc ExcCmd;
           dcl-pi *n;
             CMDString Char(1000) const;
           end-pi;
           dcl-s QCommand char(1000);
           QCommand = %Trim(CMDString);
           monitor;
             dsply %subst(QCommand:1:52);
             QCmdExc(QCommand:%Len(%Trim(QCommand)));
             on-error;
           ENDMON;
         end-proc ExcCmd;
