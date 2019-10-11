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
      *? :  This program is used to return the default Printer to    ?:
      *? :  use.  If a program entry exists, use that otherwise see  ?:
      *? :  if the user has a default and use that.                  ?:
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
     FDFTPRTPF  IF A E           K DISK    USROPN                               ?Default Printers
     FDFTPRTLUPFIF A E           K DISK    USROPN                               ?Last Used Printer

      *? Field Definitions
     D   TypeU         S              1A   Inz('U')                             ?User Printer Type
     D   TypeP         S              1A   Inz('P')                             ?Pgm Printer Type
     D   #Printer      S             10A   Inz(*Blanks)                         ?Printer Selected
     D   #RqType       S              5A                                        ?Request Type

      *? Function Prototype(s)
     D/Copy QFunctDefn,$isPrinter
     D/Copy QFunctDefn,$DftPrt

     P $DftPrt         B                   Export
     D $DftPrt         PI            10A
     D   #User                       10A   Const
     D   #Pgm                        10A   Const
     D   #Type                        5A   Const

      *? Get the Default Printers

     C                   If        not %Open(DFTPRTLUPF)
     C                   Open      DFTPRTLUPF
     C                   EndIf
     C                   If        not %Open(DFTPRTPF)
     C                   Open      DFTPRTPF
     C                   EndIf

     C                   Eval      *InLR = *Off
     C                   Eval      #RqType = #Type

     C                   DoW       not *InLR

    ?C                   Select
    ?C                   When      #RqType = '*LAST'
    ?C     LU_Key        Chain     DFTPRTLUPF
     C                   If        %Found(DFTPRTLUPF) and $isPrinter(DLPRTR)
     C                   Eval      #Printer = DLPRTR
     C                   Eval      *InLr = *On
     C                   EndIf
     C                   Eval      #RqType = *Blanks
    ?C                   When      #RqType = '*USER'
    ?C     UserKey       Chain     DFTPRTPF
     C                   If        %Found(DFTPRTPF) and $isPrinter(DPPRTR)
     C                   Eval      #Printer = DPPRTR
     C                   Eval      *InLr = *On
     C                   EndIf
     C                   Eval      #RqType = *Blanks
    ?C                   When      #RqType = '*PGM'
    ?C     PgmKey        Chain     DFTPRTPF
     C                   If        %Found(DFTPRTPF) and $isPrinter(DPPRTR)
     C                   Eval      #Printer = DPPRTR
     C                   Eval      *InLr = *On
     C                   EndIf
     C                   Eval      #RqType = *Blanks

    ?C                   Other
    ?C     PgmKey        Chain     DFTPRTPF
     C                   If        not %Found(DFTPRTPF)
     C                             or not $isPrinter(DPPRTR)
    ?C     UserKey       Chain     DFTPRTPF
     C                   If        not %Found(DFTPRTPF)
     C                             or not $isPrinter(DPPRTR)
     C                   Eval      *InLr = *On
     C                   Close     DFTPRTLUPF
     C                   Close     DFTPRTPF
    ?C                   Return    *Blanks
     C                   EndIf
     C                   EndIf
     C                   Eval      *InLr = *On
     C                   Eval      #Printer = DPPRTR

    ?C                   EndSl
     C                   EndDo

     C                   Eval      *InLr = *On
     C                   Close     DFTPRTLUPF
     C                   Close     DFTPRTPF
    ?C                   Return    #Printer

     C     UserKey       KList
     C                   KFld                    TypeU
     C                   KFld                    #User

     C     LU_Key        KList
     C                   KFld                    #User
     C                   KFld                    #Pgm

     C     PgmKey        KList
     C                   KFld                    TypeP
     C                   KFld                    #Pgm

     C     UpdtKey       KList
     C                   KFld                    DPTYPE
     C                   KFld                    DPNAME

     P   $DftPrt       E
