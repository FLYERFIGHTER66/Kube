     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: NCR731.01                                                  :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2015                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? : Scans initially go in as Master 99.  Once billed, NCR730  ?:
      *? : program will change them to Master 98.  During the night  ?:
      *? : process, this program will change them to Master 97.      ?:
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


      //  Main procedure prototype & interface
     D NCR731          PR                  ExtPgm('NCR731')
     D NCR731          PI

      /Free

         Exec SQL
           UPDATE   NPUTSCN
              SET   PSMSTR = 97
           WHERE    PSMSTR > 97;

         *InLR = *On;

      /End-Free
