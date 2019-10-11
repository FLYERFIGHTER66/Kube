     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Build Master Tag Drop Ship File                    :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May 2005             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :  *INZSR   -?Initialization Subroutine                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

      *? Function Prototypes

      *? Arrays

      *? Data Structures
     D  LSOUTPUT       DS
     D LS_FileName                   12A                                        ?File Name on IFS

      *? Field Definitions              ftp://kubepakupload@206.173.64.83
     D   FTPUser       S             13A   Inz('sqlkubepak')                    ?FTP User ID
     D   FTPPass       S             10A   Inz('k5sj!xdz')                      ?FTP Password
     D   FTPSite       S             15A   Inz('206.83.70.13')                  ?FTP Site
     D   TO_FileName   S             14A                                        ?To File Name

      *? Indicators

    ?C                   ExSr      FTPCommands
     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      FtpCommands - Inser FTP Commands into Source File  :
      *?  :.........................................................:

     C     FtpCommands   BegSr

      *? Build MTDROPSHIP file

    ?c/exec sql
    ?c+  INSERT INTO INPUT VALUES(0, 0, 'CLOSE                                ')
    ?c/end-exec

    ?c/exec sql
    ?c+  INSERT INTO INPUT VALUES(0, 0, 'CLOSE                                ')
    ?c/end-exec

    ?c/exec sql
    ?c+  INSERT INTO INPUT VALUES(0, 0, 'NAMEFMT 1                            ')
    ?c/end-exec

    ?c/exec sql
    ?c+  INSERT INTO INPUT
    ?c+  VALUES(0, 0, 'LCD  /QDLS/FTP/CF002386/SEND         ')
    ?c/end-exec

    ?c/exec sql
    ?c+  INSERT INTO INPUT VALUES(0, 0, 'OPEN '||:FTPSite)
    ?c/end-exec

    ?c/exec sql
    ?c+  INSERT INTO INPUT VALUES(0, 0, 'USER '|| :FTPUser||' '||:FTPPass)
    ?c/end-exec

    ?c/exec sql
    ?c+  INSERT INTO INPUT VALUES(0, 0, 'CD   sql_availability                ')
    ?c/end-exec

    ?c/exec sql
    ?c+  INSERT INTO INPUT
    ?c+  VALUES(0, 0,'PUT SPECIAL.CSV kube_pak_upload_special.CSV')
    ?c/end-exec

    ?c*exec sql
    ?c*  INSERT INTO INPUT
    ?c*  VALUES(0, 0,'PUT AVAIL.CSV kube_pak_upload.CSV')
    ?c*end-exec

    ?c/exec sql
    ?c+  INSERT INTO INPUT VALUES(0, 0, 'CLOSE                                ')
    ?c/end-exec

    ?c/exec sql
    ?c+  INSERT INTO INPUT VALUES(0, 0, 'QUIT                                 ')
    ?c/end-exec

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?


    ?C                   EndSr                                                  ?
