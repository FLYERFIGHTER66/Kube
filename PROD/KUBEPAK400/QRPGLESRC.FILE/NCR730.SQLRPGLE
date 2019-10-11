     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: NCR730.01                                                  :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2014                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? : Scans initially go in as Master 99.  Once billed, this    ?:
      *? : program will change them to Master 98.  During the night  ?:
      *? : process, program NCR731 will change them to Master 97.    ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? :  NCR730.01?Original Version                               ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FNCR730FM  CF   E             WORKSTN

      //  Main procedure prototype & interface
     D NCR730          PR                  ExtPgm('NCR730')
     D  #Order                        6P 0 Const
     D NCR730          PI
     D  #Order                        6P 0 Const

      *? Field Definitions
     D   Screen        S              3S 0 Inz(0)                               ?Screen Number
     D   Order         S              6S 0                                      ?Order# to Print
     D   Count         S             11S 0                                      ?Record Count

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         Order = #Order;

         Exec SQL  Select  count(*)
                   into   :Count
                   FROM    NPUTSCN
                   WHERE   PSORD# = :Order
                     and   PSMSTR =  99;

         If Count > 0;
           DoW *InLR <> *On;
             Select;
               When Screen = 01;
                 Edit01();
               Other;
                 Load01();
                 Scrn01();
             ENDSL;
           ENDDO;
         EndIf;

         *InLR = *On;

      /End-Free


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 1 SubProcedures                                           :
      // :..................................................................:
     P Load01          B
     D Load01          PI
      /Free

         DELETESCAN = 'Y';

      /End-Free
     P Load01          E
      //_____________________________________________________________________
      //
     P Scrn01          B
     D Scrn01          PI
      /Free
         Screen = 01;
         //write ASSUME;
         exfmt NCR73001;
      /End-Free
     P Scrn01          E
      //_____________________________________________________________________
      //
     P Edit01          B
     D Edit01          PI
      /Free

         Select;

           When DELETESCAN = 'N';
             *InLR = *On;
           When DELETESCAN = 'Y';
             Exec SQL
               UPDATE   NPUTSCN
                  SET   PSMSTR = 98
               WHERE    PSORD#=:Order
                  and   PSMSTR = 99;
             *InLR = *On;
           Other;
             Scrn01();
         EndSl;
      /End-Free
     P Edit01          E
