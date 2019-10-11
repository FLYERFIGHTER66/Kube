     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: LASTUSED                                                   :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2016                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? : Logs 'Last Used' information about programs.              ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? :  LASTUSED ?Original Version                               ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

      //  Main procedure prototype & interface
     D LASTUSED        PR                  ExtPgm('LASTUSED')
     D LASTUSED        PI

      *? Function Prototypes
    ?D/COPY QFunctDefn,$JOB
    ?D/COPY QFunctDefn,$USER
    ?D/COPY QFunctDefn,$JOBNBR
    ?D/COPY QFunctDefn,$isBatch
    ?D/COPY QFunctDefn,$TimeStamp

      *? Field Definitions
     D  OBJECT         S             10
     D  LIBRARY        S             10
     D  STAMP          S               Z
     D  INTBAT         S              1A   Inz('I')
     D  JOBNAME        S             10A
     D  JOBUSER        S             10A
     D  JOBNUMBER      S              6S 0
     D  Loop           S             10P 0

     D GetCaller       PR                  Extpgm('QWVRCSTK')
     D                             2000
     D                               10I 0
     D                                8    CONST
     D                               56
     D                                8    CONST
     D                               15

     D Var             DS          2000
     D  BytAvl                       10I 0
     D  BytRtn                       10I 0
     D  Entries                      10I 0
     D  Offset                       10I 0
     D  EntryCount                   10I 0
     D VarLen          S             10I 0 Inz(%size(Var))
     D ApiErr          S             15
     D JobIdInf        DS
     D  JIDQName                     26    Inz('*')
     D  JIDIntID                     16
     D  JIDRes3                       2    Inz(*loval)
     D  JIDThreadInd                 10I 0 Inz(1)
     D  JIDThread                     8    Inz(*loval)

     D Entry           DS           256
     D  EntryLen                     10I 0
     D  PgmNam                       10    Overlay(Entry:25)
     D  PgmLib                       10    Overlay(Entry:35)

      /Free

         CallP     GetCaller(Var:VarLen:'CSTK0100':JobIdInf:'JIDF0100':ApiErr);
         // Loop back through the call stack (Reverse order / most current first)
         For Loop = 1 to EntryCount;
           Entry = %subst(Var:Offset + 1) ;
           Offset = Offset + EntryLen ;
           // Find the first program in the stack that is not the current program.
           If PGMNAM <> 'LASTUSED  ';
             Leave;
           EndIf;
         EndFor;

         OBJECT     = PgmNam      ;
         LIBRARY    = PgmLib      ;
         STAMP      = $TIMESTAMP();
         If $isBatch();
           INTBAT   = 'B'         ;
         EndIf;
         JOBNAME    = $JOB()      ;
         JOBUSER    = $USER()     ;
         JOBNUMBER  = $JOBNBR()   ;

         Exec SQL //  Write Last Used Record
           INSERT INTO LASTUSEDPF
           VALUES( :OBJECT
                 , :LIBRARY
                 , :STAMP
                 , :INTBAT
                 , :JOBNAME
                 , :JOBUSER
                 , :JOBNUMBER );

         *InLR = *On;

      /End-Free

