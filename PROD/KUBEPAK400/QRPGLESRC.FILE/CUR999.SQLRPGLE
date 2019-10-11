    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *??:````````````````````````````````````````````````````````````:?
      *??:     Assign People to Apply Chemicals                       :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Dec. 2004            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? : Subroutine ?-Subroutine Description                  ?  ?:
      *? :  *INZSR      -?Initialization Subroutine                  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? : Function   ?-Function Description                    ?  ?:
      *? :  $Date        ?Get Date Value                             ?:
      *? :  $DateMDY     ?Get Date Number in MM/DD/YY                ?:
      *? :  $Monday      ?Get Monday Date Value                      ?:
      *? :  $AddDate     ?Add/Subtract Days from Date                ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :  60      ?Color Blue - Already on this Order              ?:
      *? :  61      ?Color Pink - Selected for this Order            ?:
      *? :  62      ?Color Red  - Selected for Deletion WARNING      ?:
      *? :  63      ?DSPATR(HI) - Record matches Resow Ship Date     ?:
      *? :  70      ?Position Cursor                                 ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : Date    Int  Change Description                         ?:
      *? : 03/23/05 WB01 ?Add Ounces to Print Function               ?:
      *? :............................................................:

     FCUR999FM  CF   E             WORKSTN
     F                                     SFILE(CUR99901S:SFLRRN01)
     FFCUTVENDA UF   E           K DISK
     FFMVEND    IF   E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$AddDate

      *? Copy Book Features
    ?D/COPY QFunctDefn,$ErrMsg

      *? Program Data Structure
     D                SDS
     D   PgmID           *PROC

      *? Data Structures

      *? Field Definitions
     D  UserID         S             10A
     D  Today          S              6S 0
     D  Monday         S               D
     D  ThisMonday     S               D
     D  MondayCYMD     S              7S 0
     D  SflRRN01       S              4S 0
     D  Errors         S               N
     D  X              S              5S 0
     D  Vendor         S                   Like(VMVEND)
     D  HasControl     S               N
     D  Actions        C                   CONST('1=Select Vendor')

      *? Arrays

      *?  ...........................................................
      *?  :      M A I N   C A L C S                                :
      *?  :.........................................................:

     C                   ExSr      Load01
     C                   ExSr      Scrn01

     C                   DoW       *InLR <> *On
    ?C                   Select
    ?C     Screen        WhenEq    01
     C                   ExSr      Edit01
    ?C     Screen        WhenEq    02
     C                   ExSr      Edit02
    ?C                   Other
     C                   Eval      *InLR = *On
    ?C                   EndSL
     C                   EndDo

      *?  ...........................................................
      *?  :      Load01   - Load Screen 01                          :
      *?  :.........................................................:

     C     Load01        BegSr

      *?  Clear the Subfile
    ?C                   Eval      *In25 = *Off                                 |Subfile Display
    ?C                   Eval      *In26 = *Off                                 |Subfile No Records
    ?C                   Eval      *In27 = *Off                                 |Subfile End
     C                   Eval      SflRRN01 = 0
     C                   Eval      SflRcds = *Zero
    ?C                   Write     CUR99901C

      *?  Load the Subfile

    ?C     *LoVal        SetLL     FCUTVENDA
    ?C                   Read      FCUTVENDA

     C                   DoW       not %Eof(FCUTVENDA)

      /Free
         // dcl-s HasControl ind ;
         HasControl = *Off;
         Exec SQL  // Check for Control Record
           Select '1' into :HasControl from FCUTCTL where CCVEND = :CVVEND
           Fetch First Row Only;
         If not HasControl;
           Exec SQL // Insert Default Control Record
             INSERT INTO FCUTCTL
             VALUES(01, :CVVEND, 100, 'Y', 0, 800000);
         EndIf;
      /End-Free
    ?C     CVVEND        Chain     FMVEND
     C                   If        not %Found(FMVEND)
    ?C                   Delete    RCUTVEND
     C                   Else
     C                   If        CVLOOK <> VMLOOK
     C                   Eval      CVLOOK =  VMLOOK
    ?C                   Update    RCUTVEND
     C                   EndIf
      *?  Selection Criteria...  Omit these:
     C                   If
     C                                SelVMVEND  <> *Zeros                   and
     C                                SelVMVEND  <>  VMVEND
     C                             or SelVMLOOK  <> *Blanks                  and
     C                                SelVMLOOK  <> %SUBST(VMLOOK:1:
     C                                %LEN(%TRIM(SELVMLOOK)))
      *?                 Do        Nothing
     C                   Else
     C                   Eval      *In70    = *Off
     C                   Eval      ACTION   = *Blanks
     C                   Eval      *In26 = *On                                  ?Subfile Has Records
     C                   Eval      SflRRN01 = SflRRN01 + 1
     C                   Eval      SflRcds = SflRRN01
    ?C                   Write     CUR99901S
     C                   EndIf
     C                   EndIf
    ?C                   Read      FCUTVENDA
     C                   EndDo

     C                   EndSr


      *?  ...........................................................
      *?  :      Scrn01   - Display Screen 01                       :
      *?  :.........................................................:

     C     Scrn01        BegSr

     C                   Z-Add     01            Screen            3 0          ?Screen  Number

    ?C                   Write     Assume                                       ?Clear Err Messages
    ?C                   Write     MSGCTL                                       ?Error Messages
    ?C                   Write     CUR99901F                                    ?Subfile Footer Rcd.
     C                   Eval      *In25 = *On                                  ?SubFile Display Ind
    ?C                   ExFmt     CUR99901C                                    ?Subfile Control Rcd
     C                   ExSr      $ClrError
     C                   Eval      *In25 = *Off                                 ?
     C                   If        SFLCSRRRN > 0
     C                   Eval      SFLPOSTO1 = SFLCSRRRN
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      Scrn02   - Display Screen 02                       :
      *?  :.........................................................:

     C     Scrn02        BegSr

     C                   Z-Add     02            Screen            3 0          ?Screen  Number

    ?C                   Write     Assume                                       ?Clear Err Messages
    ?C                   Write     MSGCTL                                       ?Error Messages
    ?C                   ExFmt     CUR99902                                     ?Subfile Control Rcd
     C                   ExSr      $ClrError

     C                   EndSr


      *?  ...........................................................
      *?  :      Edit01   - Edit Screen 01                          :
      *?  :.........................................................:

     C     Edit01        BegSr

      *?  Pre Subfile Edit Functions (Does not redisplay Screen)
    ?C                   Select
    ?C                   When      *In12 or *In03
     C                   Eval      Vendor = *Zeros
     C                   ExSr      ExitSR
    ?C                   When      *In06
     C                   Eval      NewVend = *Zeros
     C                   ExSr      Scrn02
    ?C                   When      *In23
      /Free
        Chain SFLCSRRRN CUR99901S;
        If %Found(CUR999FM);
          Exec SQL Delete from FCUTVEND where CVVEND = :VMVEND;
        EndIf;
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   Other
      *?  Edit Subfile Options (Check Options)
     C                   ExSr      EdtS01
      *?  Post Subfile Edit Functions (Redisplay Screen after Edits)
    ?C                   Select
    ?C                   When      Errors
     C                   ExSr      Scrn01
    ?C                   Other
      *?  No Function Keys used ==> User Pressed Enter ==> Update file
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   EndSL
    ?C                   EndSL

     C                   EndSr
      *?  ...........................................................
      *?  :      Edit02   - Edit Screen 02                          :
      *?  :.........................................................:

     C     Edit02        BegSr
      /Free
         Select;
         When      *In03;
         ExSr      Scrn01;
         Other;
         Exec SQL INSERT INTO FCUTVEND VALUES(:NewVend, 'New Vendor');
         ExSr      Load01;
         ExSr      Scrn01;
         EndSL;
      /End-Free
     C                   EndSr


      *?  ...........................................................
      *?  :      EdtS01 - Edit Subfile 01                           :
      *?  :.........................................................:

     C     EdtS01        BegSr

     C                   Eval      Errors = *Off
     C                   If        *In26
    ?C                   ReadC     CUR99901S                                    ?Changed Records
     C                   DoW       not %EOF(CUR999FM)
     C                   Eval      *In70 = *Off
    ?C                   Select
    ?C                   When      Action <> ' ' and
    ?C                             Action <> '1'
     C                   Eval      $ERR_MsgID = 'SFL0001'
     C                   Eval      $ERR_MsgData = Action + ' ' + Actions
     C                   ExSr      $SndError
     C                   Eval      Errors = *On
     C                   Eval      *In70 = *On
     C                   Eval      *In51 = *On
    ?C                   When      Action = '1'
     C                   Eval      Vendor = VMVEND
     C                   ExSr      ExitSR
    ?C                   EndSL
     C                   If        not *In70
     C                   Eval      Action = *Blanks
     C                   Else
     C                   Eval      *In28 = *On
     C                   EndIf
    ?C                   Update    CUR99901S
    ?C                   ReadC     CUR99901S                                    ?Changed Records
     C                   EndDo
     C                   EndIf

     C                   EndSr


    ? /Eject
    ?C*COPY QFunctDefn,$CommandSR
    ?D/COPY QFunctDefn,$ErrMsgSr


      *?  ...........................................................
      *?  :      ExitSR   - Exit Subroutine                         :
      *?  :.........................................................:

     C     ExitSr        BegSr

     C                   Eval      *InLR = *On
     C                   Return

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C     *Entry        PList
     C                   Parm                    Vendor

     C                   Eval      Today = $MDYDate($Date(0))
     C                   Eval      UserID= $User()
     C                   Eval      Monday = $Monday($Date(0):'SAT')
     C                   Eval      ThisMonday = Monday
     C                   Eval      SFLPOSTO1 = 1

     C                   Eval      $ERR_PROG  = 'CUR999'                        ?Pgm Msg Queue
     C                   Eval      $ERR_MSGF  = 'KPMSGF'                        ?Message File
     C                   Eval      $ERR_LIBR   = '*LIBL'                        ?Library

     C                   EndSR
