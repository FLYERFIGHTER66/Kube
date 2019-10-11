     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:              Retrieve default Printer to use               :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May 2004             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :  This program is used to return an indicator to denote    ?:
      *? :  if there is a NOTE associated with the specified record. ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :  *NONE    -?no subroutines in this module                 ?:
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

      *? Files
     FNoteKyPF  IF A E           K DISK                                         ?Notes Key File

      *? Function Prototype(s)
     D/Copy QFunctDefn,$isNote

     P $isNote         B                   Export
     D $isNote         PI              N
     D   #File                       10A   Const
     D   #RecdKey                    25A   Const

      *? Check NOTE Key file for an entry

     C     NoteKy_Key    KList
     C                   KFld                    #File
     C                   KFld                    #RecdKey

     C                   Eval      *InLR = *On

    ?C     NoteKy_Key    Chain     NoteKyPF
     C                   If        %Found(NoteKyPF)
     C                   Return    *On
     C                   Else
     C                   Return    *Off
     C                   EndIf

     P $isNote         E
