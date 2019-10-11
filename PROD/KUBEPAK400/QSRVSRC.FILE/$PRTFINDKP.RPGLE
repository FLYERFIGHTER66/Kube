     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

     D   Ara           S            100A   Dim(0003) CtData                     ?Commands Array

     D  LDA           UDS                  DtaAra(*LDA)
     D  LDAData                1    134

     D  LDAwk          DS
     D  LCONO                  1      2  0 INZ(01)                              ?Company Code
     D  LJOBQ                  6      6    INZ('N')                             ?Job Que ?
     D  LP1ID                 17     26    INZ('P8')                            ?Printer 1
     D  LP2ID                 27     36    INZ(*Blanks)                         ?Printer 2
     D  LBEGDT                37     42  0 INZ(*Zeros)                          ?Beg. Date
     D  LENDDT                43     48  0 INZ(*Zeros)                          ?End Date
     D  LSELEC                49     49  0 INZ(1)                               ?Selection
     D  LBORD                 50     55  0 INZ(*Zeros)                          ?Beg. Order #  >Parm
     D  LPC1                  59     60    INZ(*Blanks)                         ?Fm. Prod. Class
     D  LPC2                  61     62    INZ(*Blanks)                         ?To Prod Class
     D  LRTE1                 63     64    INZ(*Blanks)                         ?From Route
     D  LRTE2                 65     66    INZ(*Blanks)                         ?To Route
     D  LPHY1                 67     67    INZ(*Blanks)                         ?Phyto From
     D  LPHY2                 68     68    INZ(*Blanks)                         ?Phyto To
     D  LPREV                 69     69    INZ(*Blanks)                         ?Previously Printed
     D  LSHP1                 70     71    INZ(*Blanks)                         ?Ship Via from
     D  LSHP2                 72     73    INZ(*Blanks)                         ?Ship Via to
     D  LLOC1                 74     76    INZ(*Blanks)                         ?From Location
     D  LLOC2                 77     79    INZ(*Blanks)                         ?To Location
     D  LTAG                  80     80  0 INZ(3)                               ?1Plant;2Tag;3Both
     D  LEORD                 81     86  0 INZ(*Zeros)                          ?Ending Order #
     D  AREA                  87     88    INZ(*Blanks)                         ?Area
     D  LCANCL               133    133    INZ(*Blanks)                         ?Cancel ????
     D  AllowDetail          134    134N   INZ(*On)                             ?Allow Lot Details
      *
      *? Function Prototype(s)
     D/Copy QFunctDefn,$PrintPick
     D/Copy QFunctDefn,QCMDEXC

     ?*   ..................................................................
     ?*   :  $PRTFINDKP                                           function :
     ?*   :................................................................:

     P  $PRTFINDKP     B                        Export

     D  $PRTFINDKP     PI
     D     #Order                     6S 0      const
     D     #Printer                  10A        const
     D     #Copies                    3A        const
     D     #Save                      1A        const

     D     Command     S            255A
     D     Length      S              4S 0
     D     #Save@      S              4A        Inz('*NO')

     C                   If        #Copies <> '000'

     C                   If        #Save = 'Y'
     C                   Eval      #Save@ = '*YES'
     C                   EndIf

     C                   In        LDA
     C                   Reset                   LDAwk

     C                   Eval      LBORD = #Order
     C                   Eval      LEORD = #Order
     C                   Eval      LDAData = LDAwk

     C                   Out       LDA

     C                   Eval      Command = %trim( %trim( ara(1) )+ara(2) )
     C                   ExSr      $Command

     C                   Eval      Command = %trim( ara(3))
     C                   ExSr      $Command

     C                   Call      'BIR310'

     C                   EndIf

      *?  ..........................................................
      *?  :   Run system command                                   :
      *?  :........................................................:
     C     $Command      BegSR
      *? Format the command String.  Put vaiable in place in the string.

      *?   |P?=Printer ID?    ?Put the Printer Name in the Override command?
     C                   DoW       %Scan('|P':Command) <> 0
     C                   Eval      Command = %REPLACE
     C                             (%Trim(#Printer): Command :
     C                               %SCAN('|P': Command))
     C                   EndDo

      *?   |C?=Number Copies?  ?Put the Number of Copies in the Override command?
     C                   DoW       %Scan('|C':Command) <> 0
     C                   Eval      Command = %REPLACE
     C                             (%Trim(#Copies): Command :
     C                               %SCAN('|C': Command))
     C                   EndDo

      *?   |S?=Save Y or N  ?  ?Put the *YES or *NO in the SAVE parameter of the OVRPRTF command
     C                   DoW       %Scan('|S':Command) <> 0
     C                   Eval      Command = %REPLACE
     C                             (%Trim(#Save@): Command :
     C                               %SCAN('|S': Command))
     C                   EndDo

      *?   ~ ?=Blank that needs to be removed??Replace with nothing?
     C                   DoW       %Scan('~':Command) <> 0
     C                   Eval      Command =
     C                               %SubSt(Command:1:%Scan('~':Command)-1)
     C                             + %SubSt(Command:%Scan('~':Command)+1:
     C                               %Len(Command) - %Scan('~':Command))
     C                   EndDo

      *? Execute the Command using QCMDEXC.
     C                   Eval      Length = %len(%Trim(Command))
     C                   CALLP     qcmdexc(Command:%len(%Trim(Command)))

     C                   EndSR

     P  $PRTFINDKP     E
**
OVRPRTF FILE(BIR310) TOFILE(*LIBL/QSYSPRT) DEV(|P~~~~~~~~) PAGESIZE(66 80) LPI(6) CPI(10)
 OVRFLW(53) ALIGN(*NO) FORMTYPE(*NAR) HOLD(*NO) SAVE(|S~~) COPIES(|C~) OVRSCOPE(*JOB)
OVRPRTF FILE(BIR310X) TOFILE(*LIBL/QSYSPRT) OVRSCOPE(*JOB)
