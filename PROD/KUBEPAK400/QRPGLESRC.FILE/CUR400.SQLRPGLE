    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *?                                                              ?
      *??|                                                            |?
      *??|       Cuttings Inquiry Program                             |?
      *?|                                                            |?

      **PROGRAM NAME-------- CUR400
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- INQUIRE INTO CUTTING LOT FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * VV01    11/20/18   Vimala       Include Supplier Quantity in Subfile
      * SUD01   11/22/18   S.Uthaya     F14 to Display Supp Qty by Vendor
      *                                 in Window Subfile
      //--------------------------------------------------------------------
      *
      *
     FCUR400FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFCALEN    IF   E           K DISK
     F                                     RENAME(RCALEN:CALENI)
     FFCALEX    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCUTLOTA  IF   E           K DISK
     FFCUTLOT   UF A E           K DISK    Rename(RCUTLOT:LotRecord)
     FFCUTORD   O  A E           K DISK
     FFCUTCTL   UF   E           K DISK
     FFMVEND    IF   E           K DISK
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$isNote
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(5) CTDATA PERRCD(1)              MESSAGES
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
WJB   *
WJB  D  Vendor         S                   Like(VMVEND)
VV01 D  WkDate         S               D
VV01 D  WkDateN        S              8P 0
VV01 D  WkItem         S                   Like(CLITEM)

     D  Tot_SOLD       S                   Like(SOLD  )
     D  Tot_ONHAND     S                   Like(ONHAND)
     D  Tot_ONORD      S                   Like(ONORD )
     D  Tot_AVAIL      S                   Like(AVAIL )
     D  ToSowd7        S                   Like(CLSOWD)
VV01 D  Tot_SupQ       S                   Like(SUPQTY)
VV01 D  NullInd        S              5I 0                                      Null Indicator
VV01 D  NullValue      S              5I 0 Inz(-1)

     D  Order#1        S                   Like(COORD#)
     D  Order#2        S                   Like(COORD#)

     D  LastITEM       S                   Like(ITEM)
     D  CLITEM5        S              5A

     D  oForce         S                   Like(FORCE)

SUD01 /Free
  |    Dcl-Pr CUR400W1 ExtPgm;
  |       PItem Char(12);
  |       PDate Date(*ISO);
  |    End-Pr;
  |    Dcl-s PDate Date(*ISO);
SUD01 /End-Free

      ****************
      * START HERE   *
      ****************
     C     RSTART        TAG
     C                   Z-ADD     0             SOWDAT
     C                   Z-ADD     0             SOWDAT7
     C                   Z-ADD     0             SOWDAT6
     C                   Z-ADD     0             YEAR
     C                   Z-ADD     0             WEEK
     C                   Z-ADD     0             OSOWD             6 0
     C                   Z-ADD     0             OYEAR             4 0
     C                   Z-ADD     0             OWEEK             2 0
     C                   MOVE      *BLANKS       ALPHA
     C                   MOVE      *BLANKS       ITEMI
     C                   SetOn                                        60
     C                   SETOFF                                       1011
     C                   SETOFF                                       404145
     C                   SETOFF                                       489899
     C     NXTA          TAG
     C                   Goto      RSTRTB
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG DO
     C                   SETOFF                                       1011
     C                   SETOFF                                       404145
     C                   SETOFF                                       489899
      * CHECK ITEM NUMBER
     C     ITEMI         IFGT      *BLANKS
     C                   MOVEL     ITEM          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     ITEMI:2       IMLOOK
     C                   MOVEL     'CUT'         IMSIZE
     C                   MOVE      *BLANKS       SHPFR
     C                   CALL      'LKITAL'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        ITEMI
     C                   GOTO      NXTA
     C                   END                                                    TST1=? /
     C     ITMKEY        KLIST
     C                   KFLD                    CLITEM
     C                   KFLD                    CLSIZE
     C                   MOVEL     ITEMI         CLITEM
     C                   MOVEL     'CUT'         CLSIZE
     C     ITMKEY        CHAIN     FMINVT                             10
     C   10              GOTO      NXTA
     C                   END                                                    ITEM>" "
      * CHECK FOR SOW DATE
     C     SOWDAT        IFGT      0
     C     SOWDAT        CHAIN     FCALEN                             40
     C   40              DO
     C                   SETON                                        99
     C                   Z-ADD     0             SOWDAT7
     C                   Z-ADD     0             YEAR
     C                   Z-ADD     0             WEEK
     C                   GOTO      NXTA
     C                   ENDDO                                                  40 DO
     C     CL#Y          IFNE      1
     C                   SETON                                        404199
     C                   GOTO      NXTA
     C                   END                                                    CL#Y><1
     C                   MOVEL     CLCENT        YEAR
     C                   MOVE      CLYEAR        YEAR
     C                   Z-ADD     CLWEEK        WEEK
     C                   Z-ADD     CLCYMD        SOWDAT7           7 0
     C                   END                                                    SOWDAT>0
      * SEE IF WEEK NUMBER ENTERED
     C     SOWDAT        IFLE      0
     C     YEAR          ANDGT     0
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C                   MOVEL     YEAR          CLCENT
     C                   MOVE      YEAR          CLYEAR
     C                   Z-ADD     WEEK          CLWEEK
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             45
     C   45              DO
     C                   SETON                                        99
     C                   Z-ADD     0             SOWDAT7
     C                   Z-ADD     0             SOWDAT6
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        SOWDAT
     C                   Z-ADD     CLCYMD        SOWDAT7
     C                   END                                                    SOWDAT=0
      *
      ** GET SUB FILE
     C     RSTRTB        TAG
     C                   EXSR      BLDSFL
     C     NXTSFL        TAG
     C                   Z-add     SOWDAT6       OSOWDAT6          6 0
     C                   MOVEL     ALPHA         OALPHA           15
     C                   MOVEL     ITEMI         OITEMI           12
     C     PAGE#         IFLE      0
     C                   Z-ADD     1             PAGE#
     C                   END
     C                   EXFMT     RECCTL
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG DO
     C   KF              GOTO      RSTART
     C                   Select
     C                   When      CHGVIEW = 1
     C                   MoveA     '010'         *In(60)                        |View Shortage Only
     C                   GOTO      RSTRTB
     C                   When      CHGVIEW = 2
     C                   MoveA     '001'         *In(60)                        |View Overage Only
     C                   GOTO      RSTRTB
     C                   When      CHGVIEW = 3
     C                   MoveA     '100'         *In(60)                        |View All
     C                   GOTO      RSTRTB
     C                   EndSl
      ** SEE IF Order Lookup Requested
     C   KE              DO
     C     LINE          CHAIN     RECSFL                             90
     C   90              GOTO      NXTSFL
     C                   Move      READY6        READY
     C                   Call      'BIR265ICL'
     C                   Parm                    CLITEM
     C                   Parm                    CLSIZE
     C                   Parm                    READY             6
     C                   Parm      '1'           TYPE              1
     C                   Eval      PAGE# = LINE
     C                   GOTO      NXTSFL
     C                   ENDDO
      ** SEE IF Details  Requested
     C   KD              DO
     C     LINE          CHAIN     RECSFL                             90
     C   90              GOTO      NXTSFL
     C                   Call      'CUR410'
    ?C                   Parm                    VMVEND
    ?C                   Parm                    CLITEM
    ?C                   Parm                    CLSIZE
    ?C                   Parm                    CLSOWD
     C                   Eval      PAGE# = LINE
     C                   GOTO      NXTSFL
     C                   ENDDO
      ** SEE IF Transfer Requested
     C   KJ              DO
     C     LINE          CHAIN     RECSFL                             90
     C   90              GOTO      NXTSFL
     C                   ExSr      ScrnEsr
     C                   GOTO      RSTRTB
     C                   ENDDO
SUD01 /Free
  |   * Get Supplier quantity by Vendor and Available Date
        *In54 = *Off;
  |     If *InKN = *On;
  |        Chain Line RecSfl;
  |        If %Found;
  |           WkDateN = %Dec(%Char(%Date(SOWD:*mdy):*ISO0):8:0);
  |           PDate = %Date(WkDateN:*ISO);
  |           CUR400W1(CLITEM:PDate);
  |           Page# = Line;
              *In54 = *On;
  |        Endif;
  |     Endif;
  |
  |   /End-Free
  |  C   54              GOTO      NXTSFL
SUD01
      ** SEE IF Plus or Minu Week Requested.
     C                   If        *InKH or *InKI
     C                   If        SOWDAT6 = *Zero
     C                   Eval      SowDat6 = $MDYDate($Monday($Date(0):'SAT'))
     C                   ENDif
     C   KH              Eval      SOWDAT6 =
     C                             $MDYDate($AddDate($DateMDY(SOWDAT6):-7))
     C   KI              Eval      SOWDAT6 =
     C                             $MDYDate($AddDate($DateMDY(SOWDAT6):+7))
     C                   ENDif
      ** SEE IF OTHERB SCREEN WANTED
     C   KB              DO
     C     LINE          CHAIN     RECSFL                             90
     C   90              GOTO      NXTSFL
     C     ITEMI         IFLE      *BLANKS
     C                   MOVEL     CLITEM        ITEMI
     C                   Z-ADD     0             SOWDAT7
     C                   ELSE
     C                   MOVE      *BLANKS       ITEMI
     C                   Z-ADD     CLSOWD        SOWDAT7
     C                   Eval      SOWDAT6 = $MDYDate($Date(SOWDAT7))
     C                   Z-ADD     SOWDAT6       OSOWDAT6
     C                   END
     C                   MOVE      *BLANKS       ALPHA
     C                   MOVE      *BLANKS       OALPHA
     C                   GOTO      RSTRTB
     C                   ENDDO                                                  KB DO
      ** SEE IF ITEM OR SOWDATE CHANGED
     C     ITEMI         IFNE      OITEMI
     C     SOWDAT6       ORNE      OSOWDAT6
     C     FORCE         ORNE      OFORCE
     C                   Eval      OFORCE = FORCE
     C                   If        SOWDAT6 = 0
     C                   Z-add     *Zero         SOWDAT7           7 0
     C                   Else
     C                   Eval      SOWDAT7 = $Date7($DateMDY(SOWDAT6))
     C                   EndIf
     C                   GOTO      RSTRTB
     C                   ENDIF                                                  ITEMI><OITEMI
      ** SEE IF ALPHA CHANGED
     C     ALPHA         IFNE      OALPHA
     C                   EXSR      GETPAG
     C                   GOTO      NXTSFL
     C                   ENDIF                                                  ALPHA><OALPH
      ** NO OPTIONS GOTO NXTSFL
     C                   GOTO      NXTSFL
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ********************
      ** BUILD SUB FILE **
      ********************
     C     BLDSFL        BEGSR
     C                   Z-ADD     0             Tot_SOLD
     C                   Z-ADD     0             Tot_ONHAND
     C                   Z-ADD     0             Tot_ONORD
     C                   Z-ADD     0             Tot_AVAIL
VV01 C                   Z-ADD     0             Tot_SUPQ
     C                   SETON                                        80
     C                   WRITE     RECCTL
     C                   SETOFF                                       8025
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             PAGE#
     C                   MOVE      *BLANKS       CLLOOK
WJB  C     VendLook      KList
WJB  C                   KFld                    Vendor
WJB  C                   KFld                    CLLOOK
WJB  C*    CLLOOK        SETLL     FCUTLOTA
WJB  C     VendLook      SETLL     FCUTLOTA
     C     NXTBLD        TAG
     C                   READ      FCUTLOTA                               90
WJB  C*  90              GOTO      ENDBLD
WJB  C                   If        *In90 or CLVEND <> Vendor
WJB  C                   GOTO      ENDBLD
WJB  C                   EndIf
     C     CLSOWD        IFNE      SOWDAT7
     C     SOWDAT7       ANDGT     0
     C                   GOTO      NXTBLD
     C                   END
     C     CLITEM        IFNE      ITEMI
     C     ITEMI         ANDGT     *BLANKS
     C                   GOTO      NXTBLD
     C                   END
      ** GET SCREEN FIELDS
     C                   MOVEL     CLITEM        ITEM
     C     ITMKEY        CHAIN     FMINVT                             81
     C   81              MOVEL     MSG(1)        IMDES1s
     C  N81              MOVEL     IMDES1        IMDES1s
     C                   Z-ADD     CLSOWD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SOWD
     C*                  Call      'GETREADY'    GETREADY
     C*                  Z-add     *Zero         READY6            6 0
     C                   If        CLRDYD = *Zero
     C                   Eval      Ready6 = *Zeros
     C                   Else
     C                   Eval      Ready6 = $MDYDate($Date(CLRDYD))
     C                   EndIf
     C                   Z-ADD     CLQTSL        SOLD
     C                   Z-ADD     CLQTOH        ONHAND
     C                   Z-ADD     CLQTOO        ONORD
     C     ONHAND        ADD       ONORD         AVAIL
     C                   SUB       SOLD          AVAIL
     C     AVAIL         IFLT      0
     C                   SETON                                        25
     C                   ELSE
     C                   SETOFF                                       25
     C                   END
     C                   If        CLRDYD = CLSOWD
     C                   Eval      *In50 = *On
     C                   Else
     C                   Eval      *In50 = *Off
     C                   EndIf
      *
VV01  /Free
VV01     SUPQTY  = *Zeros;
         If SOWD <> 0 and SOWD <> 999999;
VV01     WkDateN  =  %Dec(%Char(%Date(SOWD:*mdy):*ISO0):8:0);
VV01     WkDate  = %Date(WkDateN:*ISO);
VV01     WkItem  = CLITEM;
VV01     Exec Sql
VV01        Select sum(SUPPLIER_QUANTITY_AVAILABLE) into :SUPQTY :NullInd
VV01           from WSSUPINVL1
VV01           where Kube_Pak_Item = :WkItem
VV01             and AVAILABLE_DATE = :WkDate;
VV01        If NullInd = NullValue;
VV01           SUPQTY = 0;
VV01        Endif;
VV01      Endif;
VV01  /End-Free
VV01  *
     C                   If           (*In60              )
     C                             or (*In61 and AVAIL < 0)
     C                             or (*In62 and AVAIL > 0)
     C                   Add       SOLD          Tot_SOLD
     C                   Add       ONHAND        Tot_ONHAND
     C                   Add       ONORD         Tot_ONORD
     C                   Add       AVAIL         Tot_AVAIL
VV01 C                   Add       SUPQTY        Tot_SUPQ
     C                   If        SOLD   <> 0 or
     C                             ONHAND <> 0 or
     C                             ONORD  <> 0 or
     C                             AVAIL  <> 0 or
VV01 C                             SUPQTY <> 0 or
     C                             FORCE  =  'Y'
     C                   ADD       1             RECNO
     C                   If        ITEM = LastITEM
     C                   Eval      *In52 = *On
     C                   Else
     C                   Eval      *In52 = *Off
     C                   Eval      LastITEM = ITEM
     C                   EndIF
     C                   If        IMSIZE = 'CUT'
     C                   Eval      *In53 = *On
     C                   Else
     C                   Eval      *In53 = *Off
     C                   EndIF

     C                   Eval      CLITEM5 = %Subst(CLITEM:1:5)
     C                   MoveL     *Blanks       KEYFLD           25
     C                   Eval      KeyFld = %EditW(Vendor:'0     ')
     C                                    +        CLITEM5
     C                                    +        CLSIZE
     C                                    + %EditW(CLSOWD:' -  /  /  ')
     C                   Eval      *In30 = $isNote('FCUTLOT':KEYFLD)

     C                   WRITE     RECSFL
     C                   EndIf
     C     PAGE#         IFLE      0
     C     CLLOOK        ANDGE     ALPHA
     C                   Z-ADD     RECNO         PAGE#
     C                   END
     C                   EndIf
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       IMDES1s
     C                   MOVE      *BLANKS       IMSIZE
     C                   Z-ADD     0             SOWD
     C                   Z-ADD     Tot_SOLD      SOLD
     C                   Z-ADD     Tot_ONHAND    ONHAND
     C                   Z-ADD     Tot_ONORD     ONORD
     C                   Z-ADD     Tot_AVAIL     AVAIL
VV01 C                   Z-ADD     Tot_SUPQ      SUPQTY
     C                   MOVEL     MSG(4)        IMDES1s
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   Eval      *In51 = *On
     C                   WRITE     RECSFL
     C                   Eval      *In51 = *Off
     C                   ENDSR
      ********************
      ** GET PAGE NUMB  **
      ********************
    ?C     ScrnEsr       BEGSR
    ?C     FromLot       KList
    ?C                   KFld                    CLVEND
    ?C                   KFld                    CLITEM
    ?C                   KFld                    CLSIZE
    ?C                   KFld                    CLSOWD
    ?C     ToLot         KList
    ?C                   KFld                    CLVEND
    ?C                   KFld                    CLITEM
    ?C                   KFld                    ToSIZE
    ?C                   KFld                    ToSOWD7

     C                   Eval      Alpha  = CLLOOK

     C                   Eval      TOSIZE = CLSIZE
     C                   Eval      TOSOWD = SOWD
     C                   Eval      MOVEQTY = *Zero
     C                   Move      CLSIZE        FromSize          3
     C     RstrtE        Tag
    ?C                   ExFmt     SCRNE
     C                   Eval      ToSowd7 = $Date7($DateMDY(TOSOWD))
    ?C     FromLot       SetLL     FCUTLOT                                60
    ?C     ToLot         SetLL     FCUTLOT                                61
    ?C                   Select
    ?C                   When      *InKL
    ?C*                  Do        Nothing
    ?C                   When          MOVEQTY <> 0
    ?C                             and MOVEQTY <= CLQTOH
    ?C                             and *In60
    ?C                             and *In61
     C                   Z-Add     1             Company           2 0
    ?C     CompVend      KList
    ?C                   KFld                    Company
    ?C                   KFld                    Vendor
    ?C     CompVend      CHAIN     FCUTCTL                            93
     C                   Eval      Order#1 = CCNXTM
     C                   Eval      Order#2 = CCNXTM + 1
     C                   Eval      CCNXTM = Order#2 + 1
    ?C  N93              Update    RCUTCTL
     C                   Eval      COORDD = $Date7($Date(0))
     C                   Eval      COVEND = CLVEND
     C                   Eval      COSVND = CLVEND
     C                   Eval      COSTAT = 'M'
     C                   Eval      COITEM = CLITEM
     C                   Eval      COUSEC = CLUSEC
     C                   Eval      COSOWD = CLSOWD
     C                   Eval      CORDYD = CLRDYD
     C                   Eval      COLOOK = COLOOK
     C                   Eval      COVNAL = 'Transfer'
     C                   Eval      COQTOO = 0
     C                   Eval      COPRTD = 'Y'
     C                   Eval      COTRAN = 'Y'
    ?C     FromLot       Chain     FCUTLOT
     C                   Eval      CLQTOH = CLQTOH - MOVEQTY
     C                   Eval      CLQTAV = CLQTOH + CLQTOO - CLQTSL
    ?C                   Update    LotRecord
     C                   Eval      COSIZE = CLSIZE
     C                   Eval      COSOWD = CLSOWD
     C                   Eval      COORD# = Order#1
     C                   Eval      COQTRC = -MOVEQTY
     C                   Eval      COVITM = 'Move to   ' + ToSize
    ?C                   Write     RCUTORD
    ?C     ToLot         Chain     FCUTLOT
     C                   Eval      CLQTOH = CLQTOH + MOVEQTY
     C                   Eval      CLQTAV = CLQTOH + CLQTOO - CLQTSL
    ?C                   Update    LotRecord
     C                   Eval      COSIZE = CLSIZE
     C                   Eval      COSOWD = CLSOWD
     C                   Eval      COORD# = Order#2
     C                   Eval      COQTRC = MOVEQTY
     C                   Eval      COVITM = 'Move from ' + FromSize
    ?C                   Write     RCUTORD
    ?C                   Other
     C                   Goto      RstrtE
    ?C                   EndSl
     C                   ENDSR
      ********************
      ** GET PAGE NUMB  **
      ********************
     C     GETPAG        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             PAGE#
     C     NXTPAG        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPAG
     C                   END
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTPAG
     C     PAGE#         IFLE      0
     C     CLLOOK        ANDGE     ALPHA
     C                   Z-ADD     RECNO         PAGE#
     C                   GOTO      ENDPAG
     C                   END
     C                   GOTO      NXTPAG
     C     ENDPAG        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
WJB  C     *Entry        PList
WJB  C                   Parm                    Vendor
WJB  C     Vendor        Chain     FMVEND
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      ** GET LOWEST SOW DATE (THIS WEEK)
     C     TDATE         CHAIN     FCALEN                             90
     C                   Z-ADD     CLCYMD        RPTCYM            7 0
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             90
     C                   Z-ADD     CLCYMD        BEGSCY            7 0
     C                   Z-ADD     CLDATE        BEGDAT            6 0
    ?C     GETREADY      PList
    ?C                   Parm                    CLITEM
    ?C                   Parm                    CLSIZE
    ?C                   Parm                    IMWHSE
    ?C                   Parm                    READY7            7 0          CYMD
    ?C                   Parm                    CLSOWD
     C                   ENDSR
** Messages
No Item Number Found                           1
Alphabetic Sequence                            2
Numeric Sequence                               3
  *** End of Data ***                          4
