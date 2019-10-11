     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:                      Notes Application                     :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May 2004             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :  This is the NOTES deletion Program.  Pass a Note ID and  ?:
      *? :  this program will remove it from all NOTES Files.        ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :  *INZSR   -?Initialization Subroutine                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FNoteKyNt  UF   E           K DISK                                         ?Notes Key File
     FNoteHdPF  UF   E           K DISK                                         ?Note Header
     FNoteDtPF  UF   E           K DISK                                         ?Note Details
     F*NoteTrPF  IF   E           K DISK                                         ?Note Transactions

      *? Field Definitions
     D   #NoteID       S              9S 0                                      ?Note ID


     C     #NoteID       Chain     NoteKyNt                                     ?Note Key
     C     #NoteID       Chain     NoteHdPF                                     ?Note Header
     C     #NoteID       SetLL     NoteDtPF                                     ?Note Details
     C     #NoteID       ReadE     NoteDtPF                                     ?Note Details
     C                   DoW       not %eof(NoteDtPF)
     C                   Delete    NoteDt
     C     #NoteID       ReadE     NoteDtPF                                     ?Note Details
     C                   EndDo
     C                   If        %Found(NoteHdPF)
     C                   Delete    NoteHd
     C                   EndIf
     C                   If        %Found(NoteKyNt)
     C                   Delete    NoteKey
     C                   EndIf

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C     *Entry        PList
     C                   Parm                    #NoteID

    ?C                   EndSr                                                  ?
