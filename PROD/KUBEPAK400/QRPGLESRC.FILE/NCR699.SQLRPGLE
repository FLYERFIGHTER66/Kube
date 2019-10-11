     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: NCR699.01                                                  :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2014                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? : Refresh NCR6xx files from TGMSDATA into TESTDATA.         ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? :  NCR699.01?Original Version                               ?:
      *? :............................................................:

     D NCR699          PR                  ExtPgm('NCR699')
     D NCR699          PI

      /Free

         Exec SQL Delete from TESTDATA/FHORDR    ;
         Exec SQL Delete from TESTDATA/FMUPCUPC  ;
         Exec SQL Delete from TESTDATA/FMINVT    ;
         Exec SQL Delete from TESTDATA/FMORLSEAS ;
         Exec SQL Delete from TESTDATA/FMORLSQ   ;
         Exec SQL Delete from TESTDATA/NPUTORD   ;
         Exec SQL Delete from TESTDATA/NPUTSCN   ;
         Exec SQL Delete from TESTDATA/NPUTERR   ;
         Exec SQL Delete from TESTDATA/FTRHDRH   ;
         Exec SQL Delete from TESTDATA/FTRSCHD   ;

         Exec SQL
           Insert into TESTDATA/FHORDR    Select * from TGMSDATA/FHORDR    ;
         Exec SQL
           Insert into TESTDATA/FMUPCUPC  Select * from TGMSDATA/FMUPCUPC  ;
         Exec SQL
           Insert into TESTDATA/FMINVT    Select * from TGMSDATA/FMINVT    ;
         Exec SQL
           Insert into TESTDATA/FMORLSEAS Select * from TGMSDATA/FMORLSEAS ;
         Exec SQL
           Insert into TESTDATA/FMORLSQ   Select * from TGMSDATA/FMORLSQ   ;
         Exec SQL
           Insert into TESTDATA/NPUTORD   Select * from TGMSDATA/NPUTORD   ;
         Exec SQL
           Insert into TESTDATA/NPUTSCN   Select * from TGMSDATA/NPUTSCN   ;
         Exec SQL
           Insert into TESTDATA/NPUTERR   Select * from TGMSDATA/NPUTERR   ;
         Exec SQL
           Insert into TESTDATA/FTRHDRH   Select * from TGMSDATA/FTRHDRH   ;
         Exec SQL
           Insert into TESTDATA/FTRSCHD   Select * from TGMSDATA/FTRSCHD   ;

         *InLR = *On;

      /End-Free
