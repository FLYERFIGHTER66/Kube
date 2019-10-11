    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Fin. Inventory Master Inquiry                      :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2008            ? Kube-Pak Corporation ?    :
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
      *? :  Scrn01   -?Display Screen 01                             ?:
      *? :  Load01   -?Load Screen 01                                ?:
      *? :  Edit01   -?EDIT Screen 01                                ?:
      *? :  ClrError -?Clear Error MEssage Subfile                   ?:
      *? :  SndError -?Send an Error Message to the PGMMSGQ          ?:
      *? :  SRMSGF   -?Clear or send messages to Pgm msg queue       ?:
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
      *? :  01 - 24 ?Return Screen Functions                         ?:
      *? :  03      ?Exit                                            ?:
      *? :  06      ?Restart                                         ?:
      *? :          ?                                                ?:
      *? :  25      ?SFLDSP, SFLDSPCTL, SFLCLR(N)                    ?:
      *? :  26      ?SFLDSP (Subfile has Data)                       ?:
      *? :  27      ?SFLEND                                          ?:
      *? :  28      ?SFLNXTCHG                                       ?:
      *? :  40      ?RollDn Indicator                                ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FICR012FM  CF   E             WORKSTN InfDs(ICR012FM_Inf)
     F                                     SFILE(ICR01201:RRN01)
     F                                     SFILE(ICR01202:RRN01)
     F                                     SFILE(ICR01203:RRN01)
     F                                     SFILE(ICR01204:RRN01)
     F                                     SFILE(ICR01205:RRN01)
     F                                     SFILE(ICR01206:RRN01)
     F                                     DEVID(WSID)

     FFMINVT    UF   E           K Disk
     FFMINVTDESCUF A E           K Disk
     FMTITEMS   UF A E           K Disk
     FFMUPCITEM UF   E           K Disk
     FFMINSER   UF A E           K Disk
     FFMSIZE    IF   E           K Disk
     FFSOWTYP   IF   E           K Disk
     FFPTABLE   IF   E           K Disk
     FFMORLSIS  IF   E           K Disk

      * Display file data structure
     d ICR012FM_Inf    DS
     d  FunctionKey          369    369
     d  CursorLoc            370    371
     d  DataLen              372    375I 0
     d  SflRrnNbr            376    377I 0
     d  SflCurRrn            378    379I 0
     d  SflMaxRrn            380    381I 0


      *? Function Prototypes
    ?D/COPY QFunctDefn,$Center
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$IsDate#
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,QCmdExc

     D  ItemRecord     DS                  Inz
     D   C1_IMSTAT                         Like(IMSTAT)                         ?
     D   C1_IMITEM                         Like(IMITEM)                         ?
     D   C1_IMSIZE                         Like(IMSIZE)                         ?
     D   C1_IMLOOK                         Like(IMLOOK)                         ?

     D   C1_IMDES1                         Like(IMDES1)                         ?
     D   C1_IMDES2                         Like(IMDES2)                         ?
     D   C1_IMDES3                         Like(IMDES3)                         ?
     D   C1_IMDES4                         Like(IMDES4)                         ?

     D   C1_IMBD1                          Like(IMBD1 )                         ?
     D   C1_IMED1                          Like(IMED1 )                         ?
     D   C1_IMWG1                          Like(IMWG1 )                         ?

     D   C1_IMBD2                          Like(IMBD2 )                         ?
     D   C1_IMED2                          Like(IMED2 )                         ?
     D   C1_IMWG2                          Like(IMWG2 )                         ?

     D   C1_IMBD3                          Like(IMBD3 )                         ?
     D   C1_IMED3                          Like(IMED3 )                         ?
     D   C1_IMWG3                          Like(IMWG3 )                         ?

     D   C1_IMBD4                          Like(IMBD4 )                         ?
     D   C1_IMED4                          Like(IMED4 )                         ?
     D   C1_IMWG4                          Like(IMWG4 )                         ?

     D   C1_IMLOTC                         Like(IMLOTC)                         ?
     D   C1_IMTRYC                         Like(IMTRYC)                         ?
     D   C1_IMALTP                         Like(IMALTP)                         ?
     D   C1_IM#SED                         Like(IM#SED)                         ?
     D   C1_IMMSCX                         Like(IMMSCX)                         ?
     D   C1_IMFRSZ                         Like(IMFRSZ)                         ?
     D   C1_IMLOC                          Like(IMLOC )                         ?
     D   C1_IMTPSW                         Like(IMTPSW)                         ?
     D   C1_IMFTAB                         Like(IMFTAB)                         ?
     D   C1_IMSOWC                         Like(IMSOWC)                         ?

     D   C1_IMBIN#                         Like(IMBIN#)                         ?
     D   C1_IMLIST                         Like(IMLIST)                         ?
     D   C1_IMPCL1                         Like(IMPCL1)                         ?
     D   C1_IMPCL2                         Like(IMPCL2)                         ?
     D   C1_IMPCL3                         Like(IMPCL3)                         ?
     D   C1_IMCYCD                         Like(IMCYCD)                         ?
     D   C1_IMVEND                         Like(IMVEND)                         ?
     D   C1_IMVITM                         Like(IMVITM)                         ?
     D   C1_IMROYL                         Like(IMROYL)                         ?

     D   C1_IMSEL1                         Like(IMSEL1)                         ?
     D   C1_IMSEL2                         Like(IMSEL2)                         ?
     D   C1_IMSEL3                         Like(IMSEL3)                         ?
     D   C1_IMSEL4                         Like(IMSEL4)                         ?
     D   C1_IMSEL5                         Like(IMSEL5)                         ?
     D   C1_IMPUOM                         Like(IMPUOM)                         ?
     D   C1_IMSUOM                         Like(IMSUOM)                         ?
     D   C1_IM3UOM                         Like(IM3UOM)                         ?
     D   C1_IMBPUM                         Like(IMBPUM)                         ?
     D   C1_IMMULT                         Like(IMMULT)                         ?
     D   C1_IMMUL2                         Like(IMMUL2)                         ?
     D   C1_IMORDD                         Like(IMORDD)                         ?

     D   C1_IMDTLO                         Like(IMDTLO)                         ?
     D   C1_IMDTLS                         Like(IMDTLS)                         ?
     D   C1_IMDTLA                         Like(IMDTLA)                         ?
     D   C1_IMUSER                         Like(IMUSER)                         ?

      *? Field Definitions
     D   User          S             10A                                        ?Current User ID
     D   Today         S               D                                        ?Todays Date MDY
     D   Now           S               T                                        ?The Time at *Init
     D   Program       S             10A                                        ?Program
     D   FileName      S             10A                                        ?File Name for Label

     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   LastRRN01     S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   StopRRN01     S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   Step01        S              4  0 Inz(0)                               ?SFLRRN 01 Increment
     D   ErrorCount    S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount01  S              3S 0 Inz(0)                               ?Error Count
     D   RecordCount   S              5S 0 INZ(0)
     D   ChainRRN01    S              4S 0 Inz(*Zero)                           ?Key by RRN
     D   WhereAmI      S              4S 0 Inz(*Zero)                           ?Current Screen RRN

     D   Look4@        S             +2    Like(Look4)                          ?What to Look For
     D   @MDES1@       S             +2    Like(@MDES1)                         ?Description Search
     D   @MLOOK@       S             +2    Like(@MLOOK)                         ?Alpha Search

     D   IMDES1_       S                   Like(IMDES1)                         ?Item Description
     D   IMLOOK_       S                   Like(IMLOOK)                         ?Item Alpha Sort

     D   SAVLook4      S                   Like(Look4)                          ?What to Look For
     D   SAV@ACTIT     S                   Like(@ACTIT)                         ?What to Look For
     D   SAV@MITEM     S                   Like(@MITEM)                         ?ITEM
     D   SAV@MSIZE     S                   Like(@MSIZE)                         ?SIZE
     D   SAV@MDES1     S                   Like(@MDES1)                         ?DES1
     D   SAV@MLOOK     S                   Like(@MLOOK)                         ?Alpha
     D   SAV@MSTAT     S                   Like(@MSTAT)                         ?Status
     D   SAV@MLOTC     S                   Like(@MLOTC)                         ?Lot Control
     D   SAV@MTRYC     S                   Like(@MTRYC)                         ?Seeder
     D   SAV@MALTP     S                   Like(@MALTP)                         ?Orifice
     D   SAV@M#SED     S                   Like(@M#SED)                         ?# Seeds / Cell
     D   SAV@MMSCX     S                   Like(@MMSCX)                         ?Soil Mix
     D   SAV@MFRSZ     S                   Like(@MFRSZ)                         ?From Size
     D   SAV@MLOC      S                   Like(@MLOC )                         ?Location Code
     D   SAV@MTPSW     S                   Like(@MTPSW)                         ?Sow Type
     D   SAV@MFTAB     S                   Like(@MFTAB)                         ?Factor Table
     D   SAV@MSOWC     S                   Like(@MSOWC)                         ?Sow Code

     D   SAV@MBD1      S                   Like(@MBD1 )                         ?Begin Date Window 1
     D   SAV@MED1      S                   Like(@MED1 )                         ?End Date   Window 1
     D   SAV@MWG1      S                   Like(@MWG1 )                         ?Wks 2 Grow Window 1
     D   SAV@MBD2      S                   Like(@MBD2 )                         ?Begin Date Window 2
     D   SAV@MED2      S                   Like(@MED2 )                         ?End Date   Window 2
     D   SAV@MWG2      S                   Like(@MWG2 )                         ?Wks 2 Grow Window 2
     D   SAV@MBD3      S                   Like(@MBD3 )                         ?Begin Date Window 3
     D   SAV@MED3      S                   Like(@MED3 )                         ?End Date   Window 3
     D   SAV@MWG3      S                   Like(@MWG3 )                         ?Wks 2 Grow Window 3
     D   SAV@MBD4      S                   Like(@MBD4 )                         ?Begin Date Window 4
     D   SAV@MED4      S                   Like(@MED4 )                         ?End Date   Window 4
     D   SAV@MWG4      S                   Like(@MWG4 )                         ?Wks 2 Grow Window 4

     D   SAV@MBIN#     S                   Like(@MBIN#)                         ?@MBIN#
     D   SAV@MLIST     S                   Like(@MLIST)                         ?@MLIST
     D   SAV@MPCL1     S                   Like(@MPCL1)                         ?@MPCL1
     D   SAV@MVEND     S                   Like(@MVEND)                         ?@MVEND
     D   SAV@MVITM     S                   Like(@MVITM)                         ?@MVITM
     D   SAV@MROYL     S                   Like(@MROYL)                         ?@MROYL

     D   SAV@MPUOM     S                   Like(@MPUOM)                         ?U.O.M. #1
     D   SAV@MSUOM     S                   Like(@MSUOM)                         ?U.O.M. #2
     D   SAV@M3UOM     S                   Like(@M3UOM)                         ?U.O.M. #3
     D   SAV@MBPUM     S                   Like(@MBPUM)                         ?U.O.M. Sale
     D   SAV@MORDD     S                   Like(@MORDD)                         ?On Order List

     D   WeekCount     S              4S 0                                      ?Account for Weeks

     D  SKU_to_Use     S                   Like(UPCSKU#)                        ?UPC SKU#

      *? Indicators
     D   EndOfFile     S               N
     D   PassedEdit    S               N   Inz(*Off)

    ?C                   ExSr      ClrError                                     ?
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01                                       ?

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    01                                           ?
    ?C                   ExSr      Edit01                                       ?
    ?C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?
     C*                  Call      'FIXORLFL'                                   ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   If        Screen <> 01
     C                   Z-Add     Screen        PrevScreen        3 0          ?Prev. Screen
     C                   EndIf
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     ICR01201F                                   ?
     C                   If        ErrorCount01 <> *Zero                        ?Error Count
    ?C                   Write     MSGCTL                                       ?
     C                   EndIf
     C                   If        not *In40 and WhereAmI > 0
     C                   Eval      StartRRN01 = WhereAmI
     C                   EndIf
     C                   If        StartRRN01 = *Zero
     C                   Eval      StartRRN01 = 1
     C                   EndIf
     C                   If        RRN01 = *Zero
     C                   Eval      *In26 = *Off                                 ?
     C                   EndIf
    ?C   81              ExFmt     ICR01201C                                    ?
    ?C   82              Write     ICR01202C                                    ?
    ?C   82              Read      ICR01202C                                    ?
    ?C   83              ExFmt     ICR01203C                                    ?
    ?C   84              ExFmt     ICR01204C                                    ?
    ?C   85              ExFmt     ICR01205C                                    ?
    ?C   86              ExFmt     ICR01206C                                    ?
     C                   Eval      WhereAmI = SflCurRRN
    ?C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount01 = *Zero                         ?Error Count
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   MoveA     '00000000000' *In(50)

     C                   Eval      SAVLook4     =  Look4
     C                   Eval      SAV@ACTIT    =  @ACTIT
     C                   Eval      SAV@MITEM    =  @MITEM
     C                   Eval      SAV@MSIZE    =  @MSIZE
     C                   Eval      SAV@MDES1    =  @MDES1
     C                   Eval      SAV@MLOOK    =  @MLOOK
     C                   Eval      SAV@MSTAT    =  @MSTAT
     C                   Eval      SAV@MLOTC    =  @MLOTC
     C                   Eval      SAV@MTRYC    =  @MTRYC
     C                   Eval      SAV@MALTP    =  @MALTP
     C                   Eval      SAV@M#SED    =  @M#SED
     C                   Eval      SAV@MMSCX    =  @MMSCX
     C                   Eval      SAV@MFRSZ    =  @MFRSZ
     C                   Eval      SAV@MLOC     =  @MLOC
     C                   Eval      SAV@MTPSW    =  @MTPSW
     C                   Eval      SAV@MFTAB    =  @MFTAB
     C                   Eval      SAV@MSOWC    =  @MSOWC

     C                   Eval      SAV@MBD1     =  @MBD1
     C                   Eval      SAV@MED1     =  @MED1
     C                   Eval      SAV@MWG1     =  @MWG1
     C                   Eval      SAV@MBD2     =  @MBD2
     C                   Eval      SAV@MED2     =  @MED2
     C                   Eval      SAV@MWG2     =  @MWG2
     C                   Eval      SAV@MBD3     =  @MBD3
     C                   Eval      SAV@MED3     =  @MED3
     C                   Eval      SAV@MWG3     =  @MWG3
     C                   Eval      SAV@MBD4     =  @MBD4
     C                   Eval      SAV@MED4     =  @MED4
     C                   Eval      SAV@MWG4     =  @MWG4

     C                   Eval      SAV@MBIN#    =  @MBIN#
     C                   Eval      SAV@MLIST    =  @MLIST
     C                   Eval      SAV@MPCL1    =  @MPCL1
     C                   Eval      SAV@MVEND    =  @MVEND
     C                   Eval      SAV@MVITM    =  @MVITM
     C                   Eval      SAV@MROYL    =  @MROYL

     C                   Eval      SAV@MPUOM    =  @MPUOM
     C                   Eval      SAV@MSUOM    =  @MSUOM
     C                   Eval      SAV@M3UOM    =  @M3UOM
     C                   Eval      SAV@MBPUM    =  @MBPUM
     C                   Eval      SAV@MORDD    =  @MORDD

     C                   Eval      Step01 = 16 * ( 1 )
     C                   Eval      EndOfFile = *Off
      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
     C                   Eval      StartRRN01 = *Zero
    ?C                   Write     ICR01201C                                    ?
    ?C                   Write     ICR01202C                                    ?
    ?C                   Write     ICR01203C                                    ?
    ?C                   Write     ICR01204C                                    ?
    ?C                   Write     ICR01205C                                    ?
    ?C                   Write     ICR01206C                                    ?

      *? Load the Subfile

    ?C                   ExSr      OpenData

     C                   Z-add     *Zero         RRN01                          ?
     C                   Z-add     1             WhereAmI                       ?

     C                   Eval      StopRRN01 = Step01

     C                   If        *In93
     C                   Eval      StopRRN01 = 9999
     C                   EndIf

    ?C                   ExSr      ReadData
     C                   DoW       not EndOfFile and RRN01 < StopRRN01
    ?C                   ExSr      Load01Fld
    ?C                   ExSr      ReadData
     C                   EndDo                                                  ?

     C                   If        not *In26
     C                   Clear                   ICR01201
     C                   Clear                   ICR01202
     C                   Clear                   ICR01203
     C                   Clear                   ICR01204
     C                   Clear                   ICR01205
     C                   Clear                   ICR01206
     C                   Eval      RRN01 = 1
     C                   Eval      IMDES1='No Data Found'
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Write     ICR01201                                     ?
    ?C                   Write     ICR01202                                     ?
    ?C                   Write     ICR01203                                     ?
    ?C                   Write     ICR01204                                     ?
    ?C                   Write     ICR01205                                     ?
    ?C                   Write     ICR01206                                     ?
     C                   EndIf

     C                   IF        *In26 = *On and EndOfFile                    ?
    ?C     RRN01         Chain     ICR01201                                     ?
    ?C     RRN01         Chain     ICR01202                                     ?
    ?C     RRN01         Chain     ICR01203                                     ?
    ?C     RRN01         Chain     ICR01204                                     ?
    ?C     RRN01         Chain     ICR01205                                     ?
    ?C     RRN01         Chain     ICR01206                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    ICR01201                                     ?
    ?C                   Update    ICR01202                                     ?
    ?C                   Update    ICR01203                                     ?
    ?C                   Update    ICR01204                                     ?
    ?C                   Update    ICR01205                                     ?
    ?C                   Update    ICR01206                                     ?
     C                   EndIF                                                  ?
     C*                  Clear                   ICR01201                                     ?
     C*                  Clear                   ICR01202                                     ?
     C*                  Clear                   ICR01203                                     ?
     C*                  Clear                   ICR01204                                     ?
     C*                  Clear                   ICR01205                                     ?
     C*                  Clear                   ICR01206                                     ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      More01 - Load Screen 01 w/ More records            :
      *?  :.........................................................:
    ?C     More01        BegSr                                                  ?

     C                   If        not EndOfFile
     C                   MoveA     '00000000000' *In(50)

     C                   Eval      StartRRN01= RRN01 + 1
     C                   Eval      StopRRN01 = RRN01 + Step01

    ?C*                  ExSr      ReadData
     C                   DoW       not EndOfFile and RRN01 < StopRRN01
      *? Load screen fields
    ?C                   ExSr      Load01Fld
    ?C                   ExSr      ReadData

     C                   EndDo                                                  ?

     C                   IF        *In26 = *On and EndOfFile                    ?
    ?C     RRN01         Chain     ICR01201                                     ?
    ?C     RRN01         Chain     ICR01202                                     ?
    ?C     RRN01         Chain     ICR01203                                     ?
    ?C     RRN01         Chain     ICR01204                                     ?
    ?C     RRN01         Chain     ICR01205                                     ?
    ?C     RRN01         Chain     ICR01206                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    ICR01201                                     ?
    ?C                   Update    ICR01202                                     ?
    ?C                   Update    ICR01203                                     ?
    ?C                   Update    ICR01204                                     ?
    ?C                   Update    ICR01205                                     ?
    ?C                   Update    ICR01206                                     ?
     C                   EndIF                                                  ?
     C                   EndIf                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01Fld - Load Screen 01 Fields                  :
      *?  :.........................................................:
    ?C     Load01Fld     BegSr                                                  ?

      *? Load screen fields

      *? Write Subfile Record
     C                   Add       1             RRN01                          ?

      *?     Check to see if this is the starting screen
     C                   If        StartRRN01 = 0
     C                   Eval      StartRRN01 = RRN01
     C                   EndIf

      *?  :````````````````````````````````````````````````````````````:
      *?  :              Load SFL Fields here ! ! !                    :
      *?  :............................................................:

    ?C     ItemSize      SetLL     MTITEMS
     C                   If        %Equal(MTITEMS)
     C                   Eval      MTAGS  = 'Y'
     C                   Else
     C                   Eval      MTAGS  = 'N'
     C                   EndIf

    ?C     ItemSize      Chain(n)  FMINVTDESC
     C                   If        not %Found(FMINVTDESC)
     C                   Eval      IDDATE = $date(1100901)
     C                   EndIf

      /Free

        PTDESC = *Blanks;
        Exec SQL // Get the Factor Table description
           Select PTDESC into :PTDESC from FPTABLE where PTABID = :IMFTAB;

      /End-Free

    ?C     ItemSize      Chain     FMORLSIS
     C                   If        not %Found(FMORLSIS)
     C                   Eval      OLLIST = '*NONE'
     C                   EndIf

    ?C     ItemSize      Chain(n)  FMUPCITEM
     C                   If        not %Found(FMUPCITEM)
    ?C                   Call      'CRTSKU'
    ?C                   Parm                    IMITEM
    ?C                   Parm                    IMSIZE
    ?C                   Parm                    IMDES1
    ?C                   Parm                    SKU_to_Use
    ?C     ItemSize      Chain(n)  FMUPCITEM
     C                   EndIf

    ?C     IMITEM        Chain(n)  FMINSER
     C                   If        not %Found(FMINSER)
     C                   Clear                   RMINSER
     C                   EndIf

     C                   Eval      WeekCount = IMED1 - IMBD1 +
     C                                         IMED2 - IMBD2 +
     C                                         IMED3 - IMBD3 +
     C                                         IMED4 - IMBD4
     C                   If        IMED1 > 0
     C                   Eval      WeekCount = WeekCount + 1
     C                   EndIf
     C                   If        IMED2 > 0
     C                   Eval      WeekCount = WeekCount + 1
     C                   EndIf
     C                   If        IMED3 > 0
     C                   Eval      WeekCount = WeekCount + 1
     C                   EndIf
     C                   If        IMED4 > 0
     C                   Eval      WeekCount = WeekCount + 1
     C                   EndIf
     C                   If        WeekCount <> 0 and WeekCount <> 53
     C                   Eval      *In51 = *On
     C                   Else
     C                   Eval      *In51 = *Off
     C                   EndIf
     C                   If        IMSTAT <> 'A'
     C                   Eval      *In61 = *On
     C                   Else
     C                   Eval      *In61 = *Off
     C                   EndIf
    ?C                   Write     ICR01201                                     ?
    ?C                   Write     ICR01202                                     ?
    ?C                   Write     ICR01203                                     ?
    ?C                   Write     ICR01204                                     ?
    ?C                   Write     ICR01205                                     ?
    ?C                   Write     ICR01206                                     ?
     C                   Eval      *In26 = *On                                  ?Have Data Indicator

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

     C                   Eval      Look4@   = *Blanks
     C                   Eval      @MDES1@  = *Blanks
     C                   Eval      @MLOOK@  = *Blanks

     C                   If        Look4   <> *Blanks
     C                   Eval      Look4@   = '%' + %Trim(Look4) + '%'
     C                   EndIf
     C                   If        @MDES1  <> *Blanks
     C                   Eval      @MDES1@  = '%' + %Trim(@MDES1) + '%'
     C                   EndIf
     C                   If        @MLOOK  <> *Blanks
     C                   Eval      @MLOOK@  = '%' + %Trim(@MLOOK) + '%'
     C                   EndIf

      *? Process pre-edit Functions F3, F6, F7 & F9
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
    ?C                   ExSr      CloseData
     C                   MOVE      *ON           *INLR                          ?
      *? Change View Toggle
    ?C                   When      *In10 and *In81
    ?C                   ExSr      Updt01
     C                   Eval      *In81 = *Off
     C                   Eval      *In82 = *On
     C                   Eval      *In83 = *Off
     C                   Eval      *In84 = *Off
     C                   Eval      *In85 = *Off
     C                   Eval      *In86 = *Off
    ?C                   ExSr      Scrn01
    ?C                   When      *In10 and *In82
    ?C                   ExSr      Updt01
     C                   Eval      *In81 = *Off
     C                   Eval      *In82 = *Off
     C                   Eval      *In83 = *On
     C                   Eval      *In84 = *Off
     C                   Eval      *In85 = *Off
     C                   Eval      *In86 = *Off
    ?C                   ExSr      Scrn01
    ?C                   When      *In10 and *In83
    ?C                   ExSr      Updt01
     C                   Eval      *In81 = *Off
     C                   Eval      *In82 = *Off
     C                   Eval      *In83 = *Off
     C                   Eval      *In84 = *On
     C                   Eval      *In85 = *Off
     C                   Eval      *In86 = *Off
    ?C                   ExSr      Scrn01
    ?C                   When      *In10 and *In84
    ?C                   ExSr      Updt01
     C                   Eval      *In81 = *Off
     C                   Eval      *In82 = *Off
     C                   Eval      *In83 = *Off
     C                   Eval      *In84 = *Off
     C                   Eval      *In85 = *On
     C                   Eval      *In86 = *Off
    ?C                   ExSr      Scrn01
    ?C                   When      *In10 and *In85
    ?C                   ExSr      Updt01
     C  N30              Eval      *In81 = *Off
     C   30              Eval      *In81 = *On
     C                   Eval      *In82 = *Off
     C                   Eval      *In83 = *Off
     C                   Eval      *In84 = *Off
     C                   Eval      *In85 = *Off
     C   30              Eval      *In86 = *Off
     C  N30              Eval      *In86 = *On
    ?C                   ExSr      Scrn01
    ?C                   When      *In10 and *In86
    ?C                   ExSr      Updt01
     C                   Eval      *In81 = *On
     C                   Eval      *In82 = *Off
     C                   Eval      *In83 = *Off
     C                   Eval      *In84 = *Off
     C                   Eval      *In85 = *Off
     C                   Eval      *In86 = *Off
    ?C                   ExSr      Scrn01
      *? Change Views with Screen Button
    ?C                   When      ChgView <> 0
    ?C                   ExSr      Updt01
     C                   MoveA     '000000'      *in(81)
     C                   Eval      *In(80+ChgView) = '1'
    ?C                   ExSr      Scrn01
      *? Change Mode Toggle Button F13 Pressed
    ?C                   When      *In13
    ?C                   If        *In30
     C                   Eval      *In30 = *Off
    ?C                   Else
     C                   Eval      *In30 = *On
    ?C                   EndIf
    ?C                   ExSr      CloseData
     C                   Time                    Now
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? RollDown Requested
    ?C                   When         *In40 and not EndOfFile
    ?C                   ExSr      More01
    ?C                   ExSr      Scrn01
      *? RollDown Requested past end
    ?C                   When         *In40
     C                   Eval      ErrorCount01 = ErrorCount01 + 1              ?Error Count
     C                   Eval      MessageID = 'SFL0102'
     C                   Eval      MessageDta = *Blanks
    ?C                   ExSr      SndError
    ?C                   ExSr      Scrn01
      *? Refresh Requested
    ?C                   When         *In05
    ?C                   ExSr      CloseData
     C                   Time                    Now
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Selection Changed
    ?C                   When      Look4     <> SAVLook4  or
    ?C                             @ACTIT    <> SAV@ACTIT or
    ?C                             @MITEM    <> SAV@MITEM or
    ?C                             @MSIZE    <> SAV@MSIZE or
    ?C                             @MDES1    <> SAV@MDES1 or
    ?C                             @MLOOK    <> SAV@MLOOK or
    ?C                             @MSTAT    <> SAV@MSTAT or
    ?C                             @MLOTC    <> SAV@MLOTC or
    ?C                             @MTRYC    <> SAV@MTRYC or
    ?C                             @MALTP    <> SAV@MALTP or
    ?C                             @M#SED    <> SAV@M#SED or
    ?C                             @MMSCX    <> SAV@MMSCX or
    ?C                             @MFRSZ    <> SAV@MFRSZ or
    ?C                             @MLOC     <> SAV@MLOC  or
    ?C                             @MTPSW    <> SAV@MTPSW or
    ?C                             @MFTAB    <> SAV@MFTAB or
    ?C                             @MSOWC    <> SAV@MSOWC or

    ?C                             @MBD1     <> SAV@MBD1  or
    ?C                             @MED1     <> SAV@MED1  or
    ?C                             @MWG1     <> SAV@MWG1  or
    ?C                             @MBD2     <> SAV@MBD2  or
    ?C                             @MED2     <> SAV@MED2  or
    ?C                             @MWG2     <> SAV@MWG2  or
    ?C                             @MBD3     <> SAV@MBD3  or
    ?C                             @MED3     <> SAV@MED3  or
    ?C                             @MWG3     <> SAV@MWG3  or
    ?C                             @MBD4     <> SAV@MBD4  or
    ?C                             @MED4     <> SAV@MED4  or
    ?C                             @MWG4     <> SAV@MWG4  or

    ?C                             @MBIN#    <> SAV@MBIN# or
    ?C                             @MLIST    <> SAV@MLIST or
    ?C                             @MPCL1    <> SAV@MPCL1 or
    ?C                             @MVEND    <> SAV@MVEND or
    ?C                             @MVITM    <> SAV@MVITM or
    ?C                             @MROYL    <> SAV@MROYL or

    ?C                             @MPUOM    <> SAV@MPUOM or
    ?C                             @MSUOM    <> SAV@MSUOM or
    ?C                             @M3UOM    <> SAV@M3UOM or
    ?C                             @MBPUM    <> SAV@MBPUM or
    ?C                             @MORDD    <> SAV@MORDD

    ?C                   ExSr      Updt01                                       ?
     C                   ExSr      CloseData
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? If no Functions, Check for Updates.
    ?C                   OTHER                                                  ?
    ?C                   ExSr      Updt01                                       ?
      *? Redisplay
    ?C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Updt01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Updt01        BegSr                                                  ?

     C                   Eval      LastRRN01 = RRN01

    ?C   81              ReadC     ICR01201
    ?C   82              ReadC     ICR01202
    ?C   83              ReadC     ICR01203
    ?C   84              ReadC     ICR01204
    ?C   85              ReadC     ICR01205
    ?C   86              ReadC     ICR01206
    ?C                   DoW       not %EOF(ICR012FM)

     C                   Eval      IMDES1_ = IMDES1
     C                   Eval      IMLOOK_ = IMLOOK

    ?C  n82RRN01         Chain     ICR01201
    ?C  n82RRN01         Chain     ICR01202
    ?C  n83RRN01         Chain     ICR01203
    ?C  n84RRN01         Chain     ICR01204
    ?C  n85RRN01         Chain     ICR01205
    ?C  n86RRN01         Chain     ICR01206
     C                   Eval      IMDES1 = IMDES1_
     C                   Eval      IMLOOK = IMLOOK_
    ?C  n82              Update    ICR01201
    ?C  n82              Update    ICR01202
    ?C  n83              Update    ICR01203
    ?C  n84              Update    ICR01204
    ?C  n85              Update    ICR01205
    ?C  n86              Update    ICR01206

     C                   MoveA     '00000000000' *In(50)

      *?   IMLOTC   *In52     Should be (Y)es or (N)o
     C                   If        IMLOTC <> 'Y' and
     C                             IMLOTC <> 'N'
     C                   Eval      *In52 = *On
     C                   EndIf
      *?   IMTRYC   *In53     Can be anything.
      *?   IMALTP   *In53     Can be anything.
      *?   IM#SED   *In54     Can be anything. (btw...  99 means it's a mix)
      *?   IMMSCX   *In55     Can be anything.  Should be right justified.
      *?   IMFRSZ   *In56     Any Valid Size Code on FMSIZE or *Blanks
     C                   If        IMFRSZ <> *Blanks
    ?C     IMFRSZ        Chain     FMSIZE
     C                   If        not %Found(FMSIZE)
     C                   Eval      *In56 = *On
     C                   EndIf
     C                   EndIf
      *?   IMLOC    *In57     Can be anything.
      *?   IMTPSW   *In58     Any Valid Sow Type on FSOWTYP or *Blanks if LOTC<>'Y'
    ?C     IMTPSW        Chain     FSOWTYP
     C                   If        not %Found(FSOWTYP) and IMLOTC = 'Y'
     C                   Eval      *In58 = *On
     C                   EndIf
      *?   IMFTAB   *In59     Any Valid Table Factor on FPTABLE
    ?C     IMFTAB        Chain     FPTABLE
     C                   If        not %Found(FPTABLE) and IMLOTC = 'Y'
     C                   Eval      *In59 = *On
     C                   EndIf
      *?   IMSOWC   *In60     Can be anything.

     C   52              SetOn                                        50
     C   53              SetOn                                        50
     C   54              SetOn                                        50
     C   55              SetOn                                        50
     C   56              SetOn                                        50
     C   57              SetOn                                        50
     C   58              SetOn                                        50
     C   59              SetOn                                        50
     C   60              SetOn                                        50

     C                   If        not *In50
    ?C   30ItemSize      Chain(n)  FMINVT
    ?C  N30ItemSize      Chain     FMINVT
    ?C     ItemSize      KList
    ?C                   KFld                    IMITEM
    ?C                   KFld                    IMSIZE
    ?C   30ItemSize      Chain(n)  MTITEMS
    ?C  N30ItemSize      Chain     MTITEMS
    ?C   30ItemSize      Chain(n)  FMUPCITEM
    ?C  N30ItemSize      Chain     FMUPCITEM
    ?C   30IMITEM        Chain(n)  FMINSER
    ?C  N30IMITEM        Chain     FMINSER
    ?C   30ItemSize      Chain(n)  FMINVTDESC
    ?C  N30ItemSize      Chain     FMINVTDESC

    ?C   81RRN01         Chain     ICR01201
    ?C   82RRN01         Chain     ICR01202
    ?C   83RRN01         Chain     ICR01203
    ?C   84RRN01         Chain     ICR01204
    ?C   85RRN01         Chain     ICR01205
    ?C   86RRN01         Chain     ICR01206
      *?  Update Item Master File
    ?C  N30              Update    RMINVT
      *?  Update UPC Master File
     C                   If        %Found(FMUPCITEM)
    ?C  N30              Update    RMUPC
     C                   EndIf
      *?  Update Master Tags
     C                   If        MTAGS = 'N' and %Found(MTITEMS)
    ?C  N30              Delete    RTITEMS
     C                   EndIf
     C                   If        MTAGS = 'Y' and not %Found(MTITEMS)
     C                   Eval      MTITEM = IMITEM
     C                   Eval      MTSIZE = IMSIZE
     C                   Eval      MTVEND = *Zeros
    ?C  N30              Write     RTITEMS
     C                   EndIf
      *?  Update Series
     C                   If        ISCODE <> *Blanks and not %Found(FMINSER)
     C                   Eval      ISITEM = IMITEM
     C                   Eval      ISVEND = *Zeros
    ?C  N30              Write     RMINSER
     C                   EndIf
     C                   If        ISCODE <> *Blanks and %Found(FMINSER)
    ?C  N30              Update    RMINSER
     C                   EndIf
      *?  Update Narrative
     C                   If        IDNARA <> *Blanks and not %Found(FMINVTDESC)
     C                   Eval      IDITEM = IMITEM                              ITEM #
     C                   Eval      IDSIZE = IMSIZE                              SIZE CODE
     C                   Clear                   IDNAME                         ITEM NAME
     C                   Eval      IDNARA = IDNARA                              Narrative
     C                   Clear                   IDCOMN                         Common Name
     C                   Clear                   IDBOTN                         Botanical Name
     C                   Clear                   IDCOLR                         Color Description
     C                   Clear                   IDHGHT                         Mature Plant Height
     C                   Clear                   IDZONF                         From Zone
     C                   Clear                   IDZONT                         To Zone
     C                   Clear                   IDHARD                         Hardiness
     C                   Clear                   IDBLOM                         Bloom Time
     C                   Clear                   IDSOIL                         Soil Type
     C                   Clear                   IDLGHT                         Light Requirements
     C                   Clear                   IDWATR                         Watering Requirement
     C                   Clear                   IDDPTH                         Planting Depth
     C                   Clear                   IDSPCE                         Plant Spacing
     C                   Clear                   IDDATE                         Item Creation Date
    ?C  N30              Write     RMINVTDESC
     C                   EndIf
     C                   If        %Found(FMINVTDESC)
    ?C  N30              Update    RMINVTDESC
     C                   EndIf
      *?  ~~~~~~~~~~~~~~
     C                   Eval      *In28 = *Off
    ?C   81              Update    ICR01201
    ?C   82              Update    ICR01202
    ?C   83              Update    ICR01203
    ?C   84              Update    ICR01204
    ?C   85              Update    ICR01205
    ?C   86              Update    ICR01206
     C                   Else
     C                   Eval      *In50 = *On
     C                   Eval      *In28 = *On
    ?C   81              Update    ICR01201
    ?C   82              Update    ICR01202
    ?C   83              Update    ICR01203
    ?C   84              Update    ICR01204
    ?C   85              Update    ICR01205
    ?C   86              Update    ICR01206
    ?C                   Leave
     C                   EndIf
    ?C   81              ReadC     ICR01201
    ?C   82              ReadC     ICR01202
    ?C   83              ReadC     ICR01203
    ?C   84              ReadC     ICR01204
    ?C   85              ReadC     ICR01205
    ?C   86              ReadC     ICR01206
    ?C                   EndDo

     C                   Eval      RRN01 = LastRRN01

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ExitSR - Exit Subroutine                           :
      *?  :.........................................................:
    ?C     ExitSR        BegSr                                                  ?

     C                   ExSr      CloseData
     C                   Eval      *InLR = *On
     C                   Return

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ClrError - Clear Error Message Subfile             :
      *?  :.........................................................:
    ?C     ClrError      BegSr                                                  ?

     C                   MOVE      'C'           SndClr
    ?C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrorCount = *Zero                           ?Error Count
     C                   Eval      *In50 = *Off                                 ?Error Indicator

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      SndError - Send an Error Message to the PGMMSGQ    :
      *?  :.........................................................:
    ?C     SndError      BegSr                                                  ?

     C                   MOVE      'S'           SndClr
    ?C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrorCount = ErrorCount + 1                  ?Error Count
     C                   Eval      *In50 = *On                                  ?Error Indicator

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      * ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
      *?  :.........................................................:
    ?C     SRMSGF        BegSr                                                  ?

      *? Define Parameter List - define variables         ?

     C     MessageParm   PLIST                                                  ?
     C                   Parm      'ICR012'      PgmQ             10            ?Pgm Msg Queue
     C                   Parm      'KPMSGF'      MsgFile          10            ?Message File
     C                   Parm      '*LIBL'       MsgfLib          10            ?Library
     C                   Parm                    MessageID         7            ?Message Id
     C                   Parm                    MessageDta      100            ?Message Data
     C                   Parm                    MsgKey            4            ?Message Key
     C                   Parm                    SndClr            1            ?Send or Clear

      *? Call Msg processing CL                           ?

     C                   CALL      'XAMSFC'      MessageParm                    ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      OpenData - Open Data Source                        :
      *?  :.........................................................:
    ?C     OpenData      BegSr                                                  ?

    ?c/exec sql
    ?c+
    ?c+    SELECT       Count(*)
    ?c+    INTO         :Records
    ?c+    FROM         FMINVT
    ?c+    WHERE
    ?c+                 (IMITEM =    :@MITEM        or :@MITEM  = ' ')
    ?c+             and (IMSIZE =    :@MSIZE        or :@MSIZE  = ' ')
    ?c+             and (IMDES1 like Trim(:@MDES1@) or :@MDES1@ = ' ')
    ?c+             and (IMLOOK like Trim(:@MLOOK@) or :@MLOOK@ = ' ')
    ?c+             and (IMSTAT =    :@MSTAT        or :@MSTAT  = ' ')
    ?c+             and (IMLOTC =    :@MLOTC        or :@MLOTC  = ' ')
    ?c+             and (IMTRYC =    :@MTRYC        or :@MTRYC  = ' ')
    ?c+             and (IMALTP =    :@MALTP        or :@MALTP  = ' ')
    ?c+             and (IM#SED =    :@M#SED        or :@M#SED  = 0  )
    ?c+             and (IMMSCX =    :@MMSCX        or :@MMSCX  = ' ')
    ?c+             and (IMFRSZ =    :@MFRSZ        or :@MFRSZ  = ' ')
    ?c+             and (IMLOC  =    :@MLOC         or :@MLOC   = ' ')
    ?c+             and (IMTPSW =    :@MTPSW        or :@MTPSW  = ' ')
    ?c+             and (IMFTAB =    :@MFTAB        or :@MFTAB  = ' ')
    ?c+             and (IMSOWC =    :@MSOWC        or :@MSOWC  = ' ')
    ?c+             and (IMSTAT =    'A'            or :@ACTIT  = 'N')

    ?c+             and (IMBD1  =    :@MBD1         or :@MBD1   = 0  )
    ?c+             and (IMED1  =    :@MED1         or :@MED1   = 0  )
    ?c+             and (IMWG1  =    :@MWG1         or :@MWG1   = 0  )

    ?c+             and (IMBD2  =    :@MBD2         or :@MBD2   = 0  )
    ?c+             and (IMED2  =    :@MED2         or :@MED2   = 0  )
    ?c+             and (IMWG2  =    :@MWG2         or :@MWG2   = 0  )

    ?c+             and (IMBD3  =    :@MBD3         or :@MBD3   = 0  )
    ?c+             and (IMED3  =    :@MED3         or :@MED3   = 0  )
    ?c+             and (IMWG3  =    :@MWG3         or :@MWG3   = 0  )

    ?c+             and (IMBD4  =    :@MBD4         or :@MBD4   = 0  )
    ?c+             and (IMED4  =    :@MED4         or :@MED4   = 0  )
    ?c+             and (IMWG4  =    :@MWG4         or :@MWG4   = 0  )

    ?c+             and (IMPUOM =    :@MPUOM        or :@MPUOM  = ' ')
    ?c+             and (IMSUOM =    :@MSUOM        or :@MSUOM  = ' ')
    ?c+             and (IM3UOM =    :@M3UOM        or :@M3UOM  = ' ')
    ?c+             and (IMBPUM =    :@MBPUM        or :@MBPUM  = ' ')
    ?c+             and (IMORDD =    :@MORDD        or :@MORDD  = ' ')

    ?c+             and (IMBIN# =    :@MBIN#        or :@MBIN#  = ' ')
    ?c+             and (IMLIST =    :@MLIST        or :@MLIST  = ' ')
    ?c+             and (IMPCL1 =    :@MPCL1        or :@MPCL1  = ' ')
    ?c+             and (IMCYCD =    :@MCYCD        or :@MCYCD  = ' ')
    ?c+             and (IMVEND =    :@MVEND        or :@MVEND  = 0  )
    ?c+             and (IMVITM =    :@MVITM        or :@MVITM  = ' ')
    ?c+             and (IMROYL =  0 and :@MROYL = 'N'  or
    ?c+                  IMROYL <> 0 and :@MROYL = 'Y'  or
    ?c+                                  :@MROYL = ' ')

    ?c+         and  (( IMDES1 like Trim(:LOOK4@)
    ?c+              or IMDES2 like Trim(:LOOK4@)
    ?c+              or IMDES3 like Trim(:LOOK4@)
    ?c+              or IMDES4 like Trim(:LOOK4@)
    ?c+              or IMITEM like Trim(:LOOK4@)
    ?c+              or IMSIZE like Trim(:LOOK4@)
    ?c+              or IMLOOK like Trim(:LOOK4@)
    ?c+              or IMVITM like Trim(:LOOK4@)
    ?c+              or 'ITEM '  || IMITEM  like Trim(:LOOK4@)
    ?c+              or 'SIZE '  || IMSIZE  like Trim(:LOOK4@)
    ?c+              or 'LOOK '  || IMLOOK  like Trim(:LOOK4@)
    ?c+              )  or :Look4@ = ' ' )
    ?c+
    ?c/end-exec
     C                   Z-Add     *Zero         Zero              1 0
    ?c/exec sql
    ?c+
    ?c+    DECLARE  C1 cursor for
    ?c+
    ?c+    SELECT       IMSTAT
    ?c+         ,       IMITEM
    ?c+         ,       IMSIZE
    ?c+         ,       IMLOOK

    ?c+         ,       IMDES1
    ?c+         ,       IMDES2
    ?c+         ,       IMDES3
    ?c+         ,       IMDES4

    ?c+         ,       IMBD1
    ?c+         ,       IMED1
    ?c+         ,       IMWG1

    ?c+         ,       IMBD2
    ?c+         ,       IMED2
    ?c+         ,       IMWG2

    ?c+         ,       IMBD3
    ?c+         ,       IMED3
    ?c+         ,       IMWG3

    ?c+         ,       IMBD4
    ?c+         ,       IMED4
    ?c+         ,       IMWG4

    ?c+         ,       IMLOTC
    ?c+         ,       IMTRYC
    ?c+         ,       IMALTP
    ?c+         ,       IM#SED
    ?c+         ,       IMMSCX
    ?c+         ,       IMFRSZ
    ?c+         ,       IMLOC
    ?c+         ,       IMTPSW
    ?c+         ,       IMFTAB
    ?c+         ,       IMSOWC

    ?c+         ,       IMBIN#
    ?c+         ,       IMLIST
    ?c+         ,       IMPCL1
    ?c+         ,       IMPCL2
    ?c+         ,       IMPCL3
    ?c+         ,       IMCYCD
    ?c+         ,       IMVEND
    ?c+         ,       IMVITM
    ?c+         ,       IMROYL

    ?c+         ,       IMSEL1
    ?c+         ,       IMSEL2
    ?c+         ,       IMSEL3
    ?c+         ,       IMSEL4
    ?c+         ,       IMSEL5
    ?c+         ,       IMPUOM
    ?c+         ,       IMSUOM
    ?c+         ,       IM3UOM
    ?c+         ,       IMBPUM
    ?c+         ,       IMMULT
    ?c+         ,       IMMUL2
    ?c+         ,       IMORDD
    ?
    ?c+         ,       IMDTLO
    ?c+         ,       IMDTLS
    ?c+         ,       IMDTLA
    ?c+         ,       IMUSER

    ?c+    FROM         FMINVT
    ?c+    WHERE
    ?c+                 (IMITEM =    :@MITEM        or :@MITEM  = ' ')
    ?c+             and (IMSIZE =    :@MSIZE        or :@MSIZE  = ' ')
    ?c+             and (IMDES1 like Trim(:@MDES1@) or :@MDES1@ = ' ')
    ?c+             and (IMLOOK like Trim(:@MLOOK@) or :@MLOOK@ = ' ')
    ?c+             and (IMSTAT =    :@MSTAT        or :@MSTAT  = ' ')
    ?c+             and (IMLOTC =    :@MLOTC        or :@MLOTC  = ' ')
    ?c+             and (IMTRYC =    :@MTRYC        or :@MTRYC  = ' ')
    ?c+             and (IMALTP =    :@MALTP        or :@MALTP  = ' ')
    ?c+             and (IM#SED =    :@M#SED        or :@M#SED  = 0  )
    ?c+             and (IMMSCX =    :@MMSCX        or :@MMSCX  = ' ')
    ?c+             and (IMFRSZ =    :@MFRSZ        or :@MFRSZ  = ' ')
    ?c+             and (IMLOC  =    :@MLOC         or :@MLOC   = ' ')
    ?c+             and (IMTPSW =    :@MTPSW        or :@MTPSW  = ' ')
    ?c+             and (IMFTAB =    :@MFTAB        or :@MFTAB  = ' ')
    ?c+             and (IMSOWC =    :@MSOWC        or :@MSOWC  = ' ')
    ?c+             and (IMSTAT =    'A'            or :@ACTIT  = 'N')

    ?c+             and (IMBD1  =    :@MBD1         or :@MBD1   = 0  )
    ?c+             and (IMED1  =    :@MED1         or :@MED1   = 0  )
    ?c+             and (IMWG1  =    :@MWG1         or :@MWG1   = 0  )

    ?c+             and (IMBD2  =    :@MBD2         or :@MBD2   = 0  )
    ?c+             and (IMED2  =    :@MED2         or :@MED2   = 0  )
    ?c+             and (IMWG2  =    :@MWG2         or :@MWG2   = 0  )

    ?c+             and (IMBD3  =    :@MBD3         or :@MBD3   = 0  )
    ?c+             and (IMED3  =    :@MED3         or :@MED3   = 0  )
    ?c+             and (IMWG3  =    :@MWG3         or :@MWG3   = 0  )

    ?c+             and (IMBD4  =    :@MBD4         or :@MBD4   = 0  )
    ?c+             and (IMED4  =    :@MED4         or :@MED4   = 0  )
    ?c+             and (IMWG4  =    :@MWG4         or :@MWG4   = 0  )

    ?c+             and (IMPUOM =    :@MPUOM        or :@MPUOM  = ' ')
    ?c+             and (IMSUOM =    :@MSUOM        or :@MSUOM  = ' ')
    ?c+             and (IM3UOM =    :@M3UOM        or :@M3UOM  = ' ')
    ?c+             and (IMBPUM =    :@MBPUM        or :@MBPUM  = ' ')
    ?c+             and (IMORDD =    :@MORDD        or :@MORDD  = ' ')

    ?c+             and (IMBIN# =    :@MBIN#        or :@MBIN#  = ' ')
    ?c+             and (IMLIST =    :@MLIST        or :@MLIST  = ' ')
    ?c+             and (IMPCL1 =    :@MPCL1        or :@MPCL1  = ' ')
    ?c+             and (IMCYCD =    :@MCYCD        or :@MCYCD  = ' ')
    ?c+             and (IMVEND =    :@MVEND        or :@MVEND  = 0  )
    ?c+             and (IMVITM =    :@MVITM        or :@MVITM  = ' ')
    ?c+             and (IMROYL =  0 and :@MROYL = 'N'  or
    ?c+                  IMROYL <> 0 and :@MROYL = 'Y'  or
    ?c+                                  :@MROYL = ' ')

    ?c+         and  (( IMDES1 like Trim(:LOOK4@)
    ?c+              or IMDES2 like Trim(:LOOK4@)
    ?c+              or IMDES3 like Trim(:LOOK4@)
    ?c+              or IMDES4 like Trim(:LOOK4@)
    ?c+              or IMITEM like Trim(:LOOK4@)
    ?c+              or IMSIZE like Trim(:LOOK4@)
    ?c+              or IMLOOK like Trim(:LOOK4@)
    ?c+              or IMVITM like Trim(:LOOK4@)
    ?c+              or 'ITEM '  || IMITEM  like Trim(:LOOK4@)
    ?c+              or 'SIZE '  || IMSIZE  like Trim(:LOOK4@)
    ?c+              or 'LOOK '  || IMLOOK  like Trim(:LOOK4@)
    ?c+              )  or :Look4@ = ' ' )
    ?c+    ORDER BY     IMLOOK, IMSIZE
    ?c+
    ?c+    For Read only
    ?c+
    ?c/end-exec
     C                   Z-Add     *Zero         Zero              1 0
     ?*  Open the SQL recordset
    ?c/exec sql
    ?c+                  Open      C1
    ?c/end-exec

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ReadData - Read Data                               :
      *?  :.........................................................:

     C     ReadData      BegSr

     ?*  Read Sow Schedule Records
    ?c/exec sql
    ?c+ Fetch C1 into :ItemRecord
    ?c/end-exec

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Eval      IMSTAT      = C1_IMSTAT
     C                   Eval      IMITEM      = C1_IMITEM
     C                   Eval      IMSIZE      = C1_IMSIZE
     C                   Eval      IMLOOK      = C1_IMLOOK

     C                   Eval      IMDES1      = C1_IMDES1
     C                   Eval      IMDES2      = C1_IMDES2
     C                   Eval      IMDES3      = C1_IMDES3
     C                   Eval      IMDES4      = C1_IMDES4

     C                   Eval      IMBD1       = C1_IMBD1
     C                   Eval      IMED1       = C1_IMED1
     C                   Eval      IMWG1       = C1_IMWG1

     C                   Eval      IMBD2       = C1_IMBD2
     C                   Eval      IMED2       = C1_IMED2
     C                   Eval      IMWG2       = C1_IMWG2

     C                   Eval      IMBD3       = C1_IMBD3
     C                   Eval      IMED3       = C1_IMED3
     C                   Eval      IMWG3       = C1_IMWG3
     C                   Eval      IMBD4       = C1_IMBD4
     C                   Eval      IMED4       = C1_IMED4
     C                   Eval      IMWG4       = C1_IMWG4

     C                   Eval      IMLOTC      = C1_IMLOTC
     C                   Eval      IMTRYC      = C1_IMTRYC
     C                   Eval      IMALTP      = C1_IMALTP
     C                   Eval      IM#SED      = C1_IM#SED
     C                   Eval      IMMSCX      = C1_IMMSCX
     C                   Eval      IMFRSZ      = C1_IMFRSZ
     C                   Eval      IMLOC       = C1_IMLOC
     C                   Eval      IMTPSW      = C1_IMTPSW
     C                   Eval      IMFTAB      = C1_IMFTAB
     C                   Eval      IMSOWC      = C1_IMSOWC

     C                   Eval      IMBIN#      = C1_IMBIN#
     C                   Eval      IMLIST      = C1_IMLIST
     C                   Eval      IMPCL1      = C1_IMPCL1
     C                   Eval      IMPCL2      = C1_IMPCL2
     C                   Eval      IMPCL3      = C1_IMPCL3
     C                   Eval      IMCYCD      = C1_IMCYCD
     C                   Eval      IMVEND      = C1_IMVEND
     C                   Eval      IMVITM      = C1_IMVITM
     C                   Eval      IMROYL      = C1_IMROYL

     C                   Eval      IMSEL1      = C1_IMSEL1
     C                   Eval      IMSEL2      = C1_IMSEL2
     C                   Eval      IMSEL3      = C1_IMSEL3
     C                   Eval      IMSEL4      = C1_IMSEL4
     C                   Eval      IMSEL5      = C1_IMSEL5
     C                   Eval      IMPUOM      = C1_IMPUOM
     C                   Eval      IMSUOM      = C1_IMSUOM
     C                   Eval      IM3UOM      = C1_IM3UOM
     C                   Eval      IMBPUM      = C1_IMBPUM
     C                   Eval      IMMULT      = C1_IMMULT
     C                   Eval      IMMUL2      = C1_IMMUL2
     C                   Eval      IMORDD      = C1_IMORDD

     C                   Eval      IMDTLO      = C1_IMDTLO
     C                   Eval      IMDTLS      = C1_IMDTLS
     C                   Eval      IMDTLA      = C1_IMDTLA
     C                   Eval      IMUSER      = C1_IMUSER

     C                   EndIf

     C                   EndSr

      *?  ...........................................................
      *?  :      CloseDate - Close the Data Set                     :
      *?  :.........................................................:

     C     CloseData     BegSr

     ?*  Close the SQL recordset
    ?c/exec sql
    ?c+ Close C1
    ?c/end-exec

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   If        Look4   <> *Blanks
     C                   Eval      Look4@   = '%' + %Trim(Look4) + '%'
     C                   Else
     C                   Eval      Look4@   = *Blanks
     C                   EndIf

     C*                  Eval      @MLOTC   = 'Y'
     C                   Eval      @ACTIT   = 'Y'

     C                   MoveA     '100000'      *In(81)
     C                   Eval      *In93 = *Off
     C                   Eval      *In30 = *On
     C                   Time                    Today
     C                   Time                    Now

    ?C                   EndSr                                                  ?
