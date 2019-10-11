     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:    Print user labels for use as Sown By or Fixed by        :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Dec 2005             ? Kube-Pak Corporation ?    :
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
    ?D/COPY QFunctDefn,$isFile

      *? Arrays

      *? Data Structures

      *? Field Definitions
     D  UsrLab#        S              8S 0
     D  UsrLab@        S              8A

      *? Indicators

    ?C                   ExSr      BuildFile
     C                   Eval      *InLR = *On


      *?  ...........................................................
      *?  :      BuildFile    - Build File in QTEMP with User#      :
      *?  :.........................................................:

     C     BuildFile     BegSr

      *? Delete File if it Exists

     C*                  If        $isFile('USRLABPF')
    ?c/exec sql
    ?c+
    ?c+    DROP TABLE QTEMP/USRLABPF CASCADE
    ?c+
    ?c/end-exec
     C*                  EndIf

      *? Create file in QTEMP

    ?c/exec sql
    ?c+
    ?c+    CREATE TABLE QTEMP/USRLABPF
    ?c+    (User#   DEC  (  8, 0) NOT NULL WITH DEFAULT)
    ?c+
    ?c/end-exec

      *? Populate with User Label #

    ?c/exec sql
    ?c+
    ?c+    INSERT INTO QTEMP/USRLABPF VALUES(:UsrLab#)
    ?c+
    ?c/end-exec

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *Entry        PList                                                  ?
    ?C                   Parm                    UsrLab@

     C                   Eval      UsrLab# = %Int(UsrLab@)

    ?C                   EndSr                                                  ?
