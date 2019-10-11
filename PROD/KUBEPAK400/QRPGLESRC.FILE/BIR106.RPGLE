PNK |H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
PNK |H DftActGrp(*no)
PNK |H BndDir('*LIBL/KPFUNCTION')
PNK |H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         PRINT DAILY CART REQUIREMENTS REPORT               :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  April 2005           ? Kube-Pak Corporation ?    :
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
      *? :          ?                                                ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFMSTCRTSTSIF   E           K DISK                                         ?Master Carts
     FFMCUST    IF   E           K DISK                                         ?Customer Master
     FBIR106P   O    E             PRINTER OFLIND(*In11) UsrOpn

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,QCmdExc

      *? Arrays
     D   Cmd           S            100A   Dim(0001) CtData                     ?System Commands

      *? Data Structures
     D   TruckCarts    DS                  Inz
     D     Cart01S
     D     Cart02S
     D     Cart03S
     D     Cart04S
     D     Cart05S
     D     Cart06S
     D     Cart07S
     D     Cart08S
     D     Cart09S
     D     Cart10S
     D     Cart11S
     D     Cart12S
     D     Cart13S
     D     Cart14S
     D     Cart15S
     D     CartsAra                   3S 0 Dim(15) OverLay(TruckCarts)

      *? Field Definitions
     D   User          S             10A                                        ?Current User ID
     D   Command       S            200A   Inz(*Blanks)                         ?System Command
     D   Today         S              6S 0                                      ?Todays Date MDY
     D   Now           S              6S 0                                      ?The Time at *Init
     D   Printer       S             10A                                        ?Printer for CMD
     D   PrtToUse      S             10A   Inz('XERPRT01')                      ?Printer to use
     D   Program       S             10A                                        ?Program
     D   FileName      S             10A                                        ?File Name for Label
     D   saveTruck     S                   Like(TRTRK#)                         ?save Truck Number

      *? Indicators
     D  DataFound      S               N   INZ(*Off)

      *?  Read the First Record
    ?C*    *Loval        SetLL     FMSTCRTSTS
    ?C     DateMast      SetLL     FMSTCRTSTS
    ?C*                  Read      FMSTCRTSTS
    ?C     DateMast      ReadE     FMSTCRTSTS
      *?  Write the first Page Headers
     C                   Eval      ShipDate = $MDYDate($Date(OIRVDT))
    ?C                   Write     Head
    ?C                   Write     TruckHead
     C                   Eval      saveTruck = TRTRK#
      *?  Read all Master Cart Records
     C                   DoW       not %EOF(FMSTCRTSTS)
     C                   Eval      DataFound = *On
      *?  ... if new Truck write Subtotal for Previous Truck
     C                   If        TRTRK# <> saveTruck
     C                   ExSr      SubTotSR
     C                   Clear                   TruckCarts
     C                   Eval      saveTruck = TRTRK#
    ?C                   Write     TruckHead
     C                   EndIf                                                  ?

      *?  Check for New Page
     C                   If        *In11
     C                   Eval      *In11 = *Off
    ?C                   Write     Head
    ?C                   Write     TruckHead
     C                   EndIf

      *?  Write order details
     C                   ExSr      DetailSR

    ?C*                  Read      FMSTCRTSTS
    ?C     DateMast      ReadE     FMSTCRTSTS
     C                   ENDDO                                                  ?

      *?  End of Program Logic
     C                   If        DataFound
      *?  Write Subtotal for Last Truck
     C                   ExSr      SubTotSR
      *?  Write Grand Totals
     C                   If        *In11
    ?C                   Write     Head
     C                   EndIf
    ?C                   Write     Total
     C                   Else
    ?C                   Write     NoData
     C                   EndIf
     C                   Eval      *InLr = *On
     C                   If        %Open(BIR106P)
RED |C                   Close     BIR106P
     C                   EndIf

      *?  ..........................................................
      *?  :   Run system command                                   :
      *?  :........................................................:
     C     $Command      BegSR
      *? Format the command String.  Put variable in place in the string.

      *?   |P?=Printer ID?    ?Put the Printer Name in the Override command?
     C                   Eval      Printer = PrtToUse
     C                   DoW       %Scan('|P':Command) <> 0
     C                   Eval      Command = %REPLACE
     C                             (%Trim(Printer): Command :
     C                               %SCAN('|P': Command))
     C                   EndDo

      *?   |F?=File Name?     ?Put the File Name in the Command?
     C                   DoW       %Scan('|F':Command) <> 0
     C                   Eval      Command = %REPLACE
     C                             (%Trim(FileName): Command :
     C                               %SCAN('|F': Command))
     C                   EndDo

      *?   ~ ?=Blank that needs to be removed??Replace with nothing?
     C                   DoW       %Scan('~':Command) <> 0
     C                   Eval      Command =
     C                               %SubSt(Command:1:%Scan('~':Command)-1)
     C                             + %SubSt(Command:%Scan('~':Command)+1:
     C                               %Len(Command) - %Scan('~':Command))
     C                   EndDo

      *? Execute the Command using QCMDEXC.
     C                   CALLP     QCmdExc(Command:%len(%Trim(Command)))

     C                   EndSR


      *?  ...........................................................
      *?  :      DetailSR - Subtotal Subroutine                     :
      *?  :.........................................................:
    ?C     DetailSR      BegSr                                                  ?

    ?C     OICUST        Chain     FMCUST
     C                   Eval      NAME25 = %SubSt(CMNAME:1:25)
     C                   Eval      Cart01S = Cart01S + Cart01
     C                   Eval      Cart02S = Cart02S + Cart02
     C                   Eval      Cart03S = Cart03S + Cart03
     C                   Eval      Cart04S = Cart04S + Cart04
     C                   Eval      Cart05S = Cart05S + Cart05
     C                   Eval      Cart06S = Cart06S + Cart06
     C                   Eval      Cart07S = Cart07S + Cart07
     C                   Eval      Cart08S = Cart08S + Cart08
     C                   Eval      Cart09S = Cart09S + Cart09
     C                   Eval      Cart10S = Cart10S + Cart10
     C                   Eval      Cart11S = Cart11S + Cart11
     C                   Eval      Cart12S = Cart12S + Cart12
     C                   Eval      Cart13S = Cart13S + Cart13
     C                   Eval      Cart14S = Cart14S + Cart14
     C                   Eval      Cart15S = Cart15S + Cart15
    ?C                   Write     Detl

     C                   EndSR


      *?  ...........................................................
      *?  :      SubTotSR - Subtotal Subroutine                     :
      *?  :.........................................................:
    ?C     SubTotSR      BegSr                                                  ?

     C                   Eval      Cart01T = Cart01T + Cart01S
     C                   Eval      Cart02T = Cart02T + Cart02S
     C                   Eval      Cart03T = Cart03T + Cart03S
     C                   Eval      Cart04T = Cart04T + Cart04S
     C                   Eval      Cart05T = Cart05T + Cart05S
     C                   Eval      Cart06T = Cart06T + Cart06S
     C                   Eval      Cart07T = Cart07T + Cart07S
     C                   Eval      Cart08T = Cart08T + Cart08S
     C                   Eval      Cart09T = Cart09T + Cart09S
     C                   Eval      Cart10T = Cart10T + Cart10S
     C                   Eval      Cart11T = Cart11T + Cart11S
     C                   Eval      Cart12T = Cart12T + Cart12S
     C                   Eval      Cart13T = Cart13T + Cart13S
     C                   Eval      Cart14T = Cart14T + Cart14S
     C                   Eval      Cart15T = Cart15T + Cart15S
     C                   XFoot     CartsAra      Carts
     C                   Eval      CartsT  = CartsT + Carts
    ?C                   Write     SubTotal

     C                   EndSR


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C     *Entry        PList
     C                   Parm                    Printer
     C                   Parm                    Date6             6 0
     C                   Parm                    Mast              2 0

     C                   Eval      User  = $User()
     C                   Eval      Program = 'BIR106'
     C                   Eval      Today = $MDYDate($Date(0))
     C                   Time                    Now

     C                   If        Printer = *Blanks
     C                   Eval      PrtToUse = $DftPrt(User:Program:'*PGM')      ?Printer to Use
     C                   Else
     C                   Eval      PrtToUse = Printer                           ?Printer to Use
     C                   EndIf

     C                   Z-ADD     *ZERO         DATE7             7 0
     C     DateMast      KList
     C                   KFld                    DATE7
     C                   KFld                    MAST
     C                   Eval      Date7 = $Date7($DateMDY(Date6))

     C                   Eval      Command = CMD(1)
     C                   ExSr      $Command
     C                   If        not %Open(BIR106P)
RED |C                   Open      BIR106P
     C                   EndIf

     C                   Time                    Now

    ?C                   EndSr                                                  ?
**
OVRPRTF FILE(BIR106P) OUTQ(|P~~~~~~~~) CPI(10) FORMTYPE(*NAR) OVRSCOPE(*JOB) PAGESIZE(66 80)
