**free
  Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT );
  Ctl-Opt  dftactgrp(*no) actgrp(*caller) DatFmt(*USA);
  Ctl-Opt  thread(*serialize);

  // This program will allocate inventory for a given order line number
  dcl-pr MTI020              extpgm('MTI020');
    Prod                     char(1) const;
  end-pr;
  dcl-pi MTI020;
    Prod                     char(1) const;
  end-pi;

  // ??:````````````````````````````````````````````````````````````:?
  // ??:         Build Master Tag Drop Ship File                    :?
  // ??:............................................................:?
  // ? :````````````````````````````````````````````````````````````:
  // ? : Created:  May 2005             ? Kube-Pak Corporation ?    :
  // ? :      by:  William J. Behr                                  :
  // ? : Refactored:  Nov 2017          ? Kube-Pak Corporation ?    :
  // ? :      by:  William J. Behr                                  :
  // ? :............................................................:

  //? Data Structures
  dcl-ds LSOUTPUT;
    LS_FileName char(12);  //?File Name on IFS
  end-ds;

  //? Field Definitions
  dcl-s FTPUser varchar(40) Inz('mastertag/wbehr@kubepak.com'); //?FTP User ID
  dcl-s FTPPass varchar(40) Inz('TAGSMa@ster9751');             //?FTP Password
  dcl-s OurName char(30);                        //?Company Name
  dcl-s OurEmail char(33);                       //?Email Address
  dcl-s TO_FileName char(14);                    //?To File Name

  GetVariables();
  FTPCommands();
  *InLR = *On;

  //?  ...........................................................
  //?  :      GetVariables - Run SQL to retrieve variables       :
  //?  :.........................................................:

  DCL-PROC GetVariables;

      exec sql   //? Get our company name
        SELECT  RGNAME
        INTO    :OurName
        FROM    FMCORG
        WHERE   RGCOMP = 01;

      exec sql  //? Get our e-mail address
        SELECT  RGEML
        INTO    :OurEmail
        FROM    FMCORG
        WHERE   RGCOMP = 01;

    //  Build list of files to send
      exec sql
        DECLARE   C1 cursor for
        SELECT  LSOUTPUT from LSOUTPUT
        For Read only;

  END-PROC;

  //?  ...........................................................
  //?  :      FtpCommands - Inser FTP Commands into Source File  :
  //?  :.........................................................:

  DCL-PROC  FtpCommands;
    I('CLOSE');
    I('CLOSE');
    I('NAMEFMT 1');
    I('SENDEPSV 0');
    I('LCD  /QDLS/FTP/VF000477/SEND');
    I('OPEN mastertag.sharefileftp.com');
    I('USER ' + FTPUser + ' ' + FTPPass);
    I('CD   Dropship/Kube Pak/');
    getFiles();
    I('CLOSE');
    // TESTSERVER();
    I('QUIT');
  END-PROC;

  //?  ...........................................................
  //?  :      Test new Server                                    :
  //?  :.........................................................:

  DCL-PROC TESTSERVER;
    I('OPEN mastertag.sharefileftp.com');
    I('user mastertag/FTPTest@mastertag.com 9751Farm');
    I('CD /TestDropShip/DropTestFilesHere');
    getFiles();
    I('CLOSE');
  END-PROC;

  //?  ...........................................................
  //?  :      Write a line of FTP Script to INPUT file.          :
  //?  :.........................................................:

  DCL-PROC getFiles;
    // Read through cursor to populate file list
    exec sql Close     C1;
    exec sql Open      C1;
    exec sql Fetch C1 into :LSOUTPUT;
    DoW SQLSTT <> '02000';                                               //?Read until EOF
      If Prod = 'Y';
        I('PUT ' + %trim(LS_FileName) + ' KP' + %trim(LS_FileName));
       Else;
        I('PUT ' + %trim(LS_FileName) + ' ' + %SubSt(('KU' + LS_FileName):1:10)+'.TST');
      EndIf;
      exec sql Fetch C1 into :LSOUTPUT;
    EndDo;
           //  Close the SQL recordset
    exec sql Close     C1;
  END-PROC;

  //?  ...........................................................
  //?  :      Write a line of FTP Script to INPUT file.          :
  //?  :.........................................................:

  DCL-PROC I;
    DCL-PI *n;
      HtmlLine Char(256) value;
    END-PI;

  If HTMLLINE <> ' '; //  Write a line of FTP Script to INPUT file.
    Exec SQL INSERT INTO INPUT VALUES(0, 0, :HTMLLINE);
  EndIf;

  END-PROC;

