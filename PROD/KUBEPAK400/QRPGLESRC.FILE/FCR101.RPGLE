    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *?                                                              ?
      *??|                                                            |?
      *??|       Finished Crop Chemical Application Program           |?
      *?|                                                            |?

      *?PROGRAM NAME-------- FCR101
      *?PROGRAMMER---------- WJB
      *?APPLICATION--------- SCAN GREENHOUSE FINISHED CROP FOR SPRAY

      *?           CHANGE--DATE-------DESCRIPTION
      *?  9/01/08  WJB  Initial Programming

     FFCR101FM  CF   E             WORKSTN
     FFMINVT    IF   E           K DISK
     FFMINSER   IF   E           K DISK
     FFFCMCTL   UF   E           K DISK
     FFCSECTL1  IF   E           K DISK
     FFFINLOC   IF   E           K DISK
     FFFCMJOBITMIF   E           K DISK    RENAME(RCHMJOB:CHMJOBITM)

     FFFCMLOC   UF A E           K DISK
     FFFCMJOB   UF A E           K DISK
     FFFCMDFT   UF A E           K DISK

      *? CONTROL FILE ARRAYS
     D  NSEW           S              2A   DIM(06) CTDATA PERRCD(1) ASCEND
     D  NSEWtxt        S              9A   DIM(06) ALT(NSEW)

     D  UseTags        S               N
     D  OvrTags        S               N

     D IT              S             12    DIM(40)                              ITEM NUMBERS
     D SZ              S              3    DIM(40)                              SIZE CODES
     D PM              S              7  2 DIM(40)                              PPM
     D OZ              S              7  3 DIM(40)                              OZ/GAL
     D ML              S              7  3 DIM(40)                              ML/GAL
     D SS              S              7  0 DIM(40)                              SCREEN PPM (SAVED)
     D SDS             S             10    DIM(40)                              SCREEN CHEM DESC.(SA
     D DS              S             12    DIM(40)                              SCREEN CHEM ITEM
      *? location array
     D LocCode         DS                  INZ
     D  locSect                       2S 0
     D  locZero                       1S 0
     D  locBay                        2S 0
     D  locNorS                       1
     D  locEorW                       1
      *? Section Array
     D SSECTDS         DS                  INZ
     D  SSECT01
     D  SSECT02
     D  SSECT03
     D  SSECT04
     D  SSECT05
     D  SSECT00                       2  0 DIM(5) OVERLAY(SSECTDS)
      *? Bay Array
     D SBAYDS          DS                  INZ
     D  SBAY01
     D  SBAY02
     D  SBAY03
     D  SBAY04
     D  SBAY05
     D  SBAY06
     D  SBAY07
     D  SBAY08
     D  SBAY09
     D  SBAY10
     D  SBAY11
     D  SBAY12
     D  SBAY13
     D  SBAY14
     D  SBAY15
     D  SBAY16
     D  SBAY17
     D  SBAY18
     D  SBAY19
     D  SBAY20
     D  SBAY21
     D  SBAY22
     D  SBAY23
     D  SBAY24
     D  SBAY25
     D  SBAY26
     D  SBAY27
     D  SBAY28
     D  SBAY29
     D  SBAY30
     D  SBAY31
     D  SBAY32
     D  SBAY33
     D  SBAY34
     D  SBAY35
     D  SBAY36
     D  SBAY37
     D  SBAY38
     D  SBAY39
     D  SBAY40
     D  SBAY41
     D  SBAY42
     D  SBAY43
     D  SBAY44
     D  SBAY45
     D  SBAY46
     D  SBAY47
     D  SBAY48
     D  SBAY49
     D  SBAY50
     D  SBAY51
     D  SBAY52
     D  SBAY53
     D  SBAY54
     D  SBAY55
     D  SBAY56
     D  SBAY57
     D  SBAY58
     D  SBAY59
     D  SBAY60
     D  SBAY61
     D  SBAY62
     D  SBAY63
     D  SBAY64
     D  SBAY65
     D  SBAY66
     D  SBAY67
     D  SBAY68
     D  SBAY69
     D  SBAY70
     D  SBAY71
     D  SBAY72
     D  SBAY00                        2A   DIM(72) OVERLAY(SBAYDS)
      *? Bay Array
     D SNOSDS          DS                  INZ
     D  SNOS01
     D  SNOS02
     D  SNOS03
     D  SNOS04
     D  SNOS05
     D  SNOS06
     D  SNOS07
     D  SNOS08
     D  SNOS09
     D  SNOS10
     D  SNOS00                        2A   DIM(10) OVERLAY(SNOSDS)
      *? SCREEN PPM ARRAY
     D SPPM            DS                  INZ
     D  PPM01
     D  PPM02
     D  PPM03
     D  PPM04
     D  PPM05
     D  PPM06
     D  PPM07
     D  PPM08
     D  PPM09
     D  PPM10
     D  PPM11
     D  PPM12
     D  PPM13
     D  PPM14
     D  PPM15
     D  PPM16
     D  PPM17
     D  PPM18
     D  PPM19
     D  PPM20
     D  PPM21
     D  PPM22
     D  PPM23
     D  PPM24
     D  PPM25
     D  PPM26
     D  PPM27
     D  PPM28
     D  PPM29
     D  PPM30
     D  PPM31
     D  PPM32
     D  PPM33
     D  PPM34
     D  PPM35
     D  PPM36
     D  PPM37
     D  PPM38
     D  PPM39
     D  PPM40
     D  SC                            7S 2
     D                                     DIM(40) OVERLAY(SPPM)                SCREEN PPM
      *? SCREEN PPM ARRAY
     D SCHM            DS                  INZ
     D  CHM01
     D  CHM02
     D  CHM03
     D  CHM04
     D  CHM05
     D  CHM06
     D  CHM07
     D  CHM08
     D  CHM09
     D  CHM10
     D  CHM11
     D  CHM12
     D  CHM13
     D  CHM14
     D  CHM15
     D  CHM16
     D  CHM17
     D  CHM18
     D  CHM19
     D  CHM20
     D  CHM21
     D  CHM22
     D  CHM23
     D  CHM24
     D  CHM25
     D  CHM26
     D  CHM27
     D  CHM28
     D  CHM29
     D  CHM30
     D  CHM31
     D  CHM32
     D  CHM33
     D  CHM34
     D  CHM35
     D  CHM36
     D  CHM37
     D  CHM38
     D  CHM39
     D  CHM40
     D  SD                           10A
     D                                     DIM(40) OVERLAY(SCHM)                SCREEN CHEM DESC.
     D                 DS
     D  CSRFLD                 1     10
     D  CSRFL#                 4      5  0

     D                 DS
     D  NOS                    1      2
     D  NORS                   1      1
     D  EORW                   2      2

     D                SDS
     D  PROGID                 1     10                                         PROGRAM NAME
     D  RLIBR                 81     90                                         RUN LIBRARY
     d  @JOB                 244    253
     D  USERID               254    263                                         USER I.D.
     D  SLIBR                314    323                                         SOURCE LIBRARY

      *? Field Definitions
     D  BayX           S              2S 0
     D  NoSX           S              2S 0
     D  User           S             10A
     D  Today          S              6S 0
     D  Now            S              6S 0
     D  CurrentPole    S                   Like( CLPOLE )
     D  CLWKTR         S              3S 0
     D  STRDAT         S              7S 0
     D  x              S              3S 0
     D  RepeatScrn01   S               N

      *? Copy Books
    ?D/COPY QFunctDefn,$ErrMsg

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$WeekDay
    ?D/COPY QFunctDefn,$isDate#
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Now

     d Format          s              8A   Inz('DEVD0600')
     d ipaddress       s             15a
     d Rcvar           S           5000A   Inz
     d Varlen          S             10i 0 Inz(5000)

     d $getipaddress   pr                  extpgm('QDCRDEVD')
     d   rcvar                     5000
     d   varlen                      10i 0
     d   format                       8
     d   @job                        10
     d   apierror                   256

     d APIError        ds                  Qualified
     d  BytesP                 1      4I 0 inz(%size(apiError))
     d  BytesA                 5      8I 0 inz(0)
     d  Messageid              9     15
     d  Reserved              16     16
     d  messagedta            17    256






      *? REDEFINE FFCMCTL
     IRCHMCTL
      *? GET ITEM NUMBERS
     I              CHIT1                       IT(1)
     I              CHIT2                       IT(2)
     I              CHIT3                       IT(3)
     I              CHIT4                       IT(4)
     I              CHIT5                       IT(5)
     I              CHIT6                       IT(6)
     I              CHIT7                       IT(7)
     I              CHIT8                       IT(8)
     I              CHIT9                       IT(9)
     I              CHIT10                      IT(10)
     I              CHIT11                      IT(11)
     I              CHIT12                      IT(12)
     I              CHIT13                      IT(13)
     I              CHIT14                      IT(14)
     I              CHIT15                      IT(15)
     I              CHIT16                      IT(16)
     I              CHIT17                      IT(17)
     I              CHIT18                      IT(18)
     I              CHIT19                      IT(19)
     I              CHIT20                      IT(20)
     I              CHIT21                      IT(21)
     I              CHIT22                      IT(22)
     I              CHIT23                      IT(23)
     I              CHIT24                      IT(24)
     I              CHIT25                      IT(25)
     I              CHIT26                      IT(26)
     I              CHIT27                      IT(27)
     I              CHIT28                      IT(28)
     I              CHIT29                      IT(29)
     I              CHIT30                      IT(30)
     I              CHIT31                      IT(31)
     I              CHIT32                      IT(32)
     I              CHIT33                      IT(33)
     I              CHIT34                      IT(34)
     I              CHIT35                      IT(35)
     I              CHIT36                      IT(36)
     I              CHIT37                      IT(37)
     I              CHIT38                      IT(38)
     I              CHIT39                      IT(39)
     I              CHIT40                      IT(40)
      *? GET SIZE CODES
     I              CHSZ1                       SZ(1)
     I              CHSZ2                       SZ(2)
     I              CHSZ3                       SZ(3)
     I              CHSZ4                       SZ(4)
     I              CHSZ5                       SZ(5)
     I              CHSZ6                       SZ(6)
     I              CHSZ7                       SZ(7)
     I              CHSZ8                       SZ(8)
     I              CHSZ9                       SZ(9)
     I              CHSZ10                      SZ(10)
     I              CHSZ11                      SZ(11)
     I              CHSZ12                      SZ(12)
     I              CHSZ13                      SZ(13)
     I              CHSZ14                      SZ(14)
     I              CHSZ15                      SZ(15)
     I              CHSZ16                      SZ(16)
     I              CHSZ17                      SZ(17)
     I              CHSZ18                      SZ(18)
     I              CHSZ19                      SZ(19)
     I              CHSZ20                      SZ(20)
     I              CHSZ21                      SZ(21)
     I              CHSZ22                      SZ(22)
     I              CHSZ23                      SZ(23)
     I              CHSZ24                      SZ(24)
     I              CHSZ25                      SZ(25)
     I              CHSZ26                      SZ(26)
     I              CHSZ27                      SZ(27)
     I              CHSZ28                      SZ(28)
     I              CHSZ29                      SZ(29)
     I              CHSZ30                      SZ(30)
     I              CHSZ31                      SZ(31)
     I              CHSZ32                      SZ(32)
     I              CHSZ33                      SZ(33)
     I              CHSZ34                      SZ(34)
     I              CHSZ35                      SZ(35)
     I              CHSZ36                      SZ(36)
     I              CHSZ37                      SZ(37)
     I              CHSZ38                      SZ(38)
     I              CHSZ39                      SZ(39)
     I              CHSZ40                      SZ(40)
      *? GET PPM
     I              CHPM1                       PM(1)
     I              CHPM2                       PM(2)
     I              CHPM3                       PM(3)
     I              CHPM4                       PM(4)
     I              CHPM5                       PM(5)
     I              CHPM6                       PM(6)
     I              CHPM7                       PM(7)
     I              CHPM8                       PM(8)
     I              CHPM9                       PM(9)
     I              CHPM10                      PM(10)
     I              CHPM11                      PM(11)
     I              CHPM12                      PM(12)
     I              CHPM13                      PM(13)
     I              CHPM14                      PM(14)
     I              CHPM15                      PM(15)
     I              CHPM16                      PM(16)
     I              CHPM17                      PM(17)
     I              CHPM18                      PM(18)
     I              CHPM19                      PM(19)
     I              CHPM20                      PM(20)
     I              CHPM21                      PM(21)
     I              CHPM22                      PM(22)
     I              CHPM23                      PM(23)
     I              CHPM24                      PM(24)
     I              CHPM25                      PM(25)
     I              CHPM26                      PM(26)
     I              CHPM27                      PM(27)
     I              CHPM28                      PM(28)
     I              CHPM29                      PM(29)
     I              CHPM30                      PM(30)
     I              CHPM31                      PM(31)
     I              CHPM32                      PM(32)
     I              CHPM33                      PM(33)
     I              CHPM34                      PM(34)
     I              CHPM35                      PM(35)
     I              CHPM36                      PM(36)
     I              CHPM37                      PM(37)
     I              CHPM38                      PM(38)
     I              CHPM39                      PM(39)
     I              CHPM40                      PM(40)
      *? GET OUNCES
     I              CHOZ1                       OZ(1)
     I              CHOZ2                       OZ(2)
     I              CHOZ3                       OZ(3)
     I              CHOZ4                       OZ(4)
     I              CHOZ5                       OZ(5)
     I              CHOZ6                       OZ(6)
     I              CHOZ7                       OZ(7)
     I              CHOZ8                       OZ(8)
     I              CHOZ9                       OZ(9)
     I              CHOZ10                      OZ(10)
     I              CHOZ11                      OZ(11)
     I              CHOZ12                      OZ(12)
     I              CHOZ13                      OZ(13)
     I              CHOZ14                      OZ(14)
     I              CHOZ15                      OZ(15)
     I              CHOZ16                      OZ(16)
     I              CHOZ17                      OZ(17)
     I              CHOZ18                      OZ(18)
     I              CHOZ19                      OZ(19)
     I              CHOZ20                      OZ(20)
     I              CHOZ21                      OZ(21)
     I              CHOZ22                      OZ(22)
     I              CHOZ23                      OZ(23)
     I              CHOZ24                      OZ(24)
     I              CHOZ25                      OZ(25)
     I              CHOZ26                      OZ(26)
     I              CHOZ27                      OZ(27)
     I              CHOZ28                      OZ(28)
     I              CHOZ29                      OZ(29)
     I              CHOZ30                      OZ(30)
     I              CHOZ31                      OZ(31)
     I              CHOZ32                      OZ(32)
     I              CHOZ33                      OZ(33)
     I              CHOZ34                      OZ(34)
     I              CHOZ35                      OZ(35)
     I              CHOZ36                      OZ(36)
     I              CHOZ37                      OZ(37)
     I              CHOZ38                      OZ(38)
     I              CHOZ39                      OZ(39)
     I              CHOZ40                      OZ(40)
      *? GET ML
     I              CHML1                       ML(1)
     I              CHML2                       ML(2)
     I              CHML3                       ML(3)
     I              CHML4                       ML(4)
     I              CHML5                       ML(5)
     I              CHML6                       ML(6)
     I              CHML7                       ML(7)
     I              CHML8                       ML(8)
     I              CHML9                       ML(9)
     I              CHML10                      ML(10)
     I              CHML11                      ML(11)
     I              CHML12                      ML(12)
     I              CHML13                      ML(13)
     I              CHML14                      ML(14)
     I              CHML15                      ML(15)
     I              CHML16                      ML(16)
     I              CHML17                      ML(17)
     I              CHML18                      ML(18)
     I              CHML19                      ML(19)
     I              CHML20                      ML(20)
     I              CHML21                      ML(21)
     I              CHML22                      ML(22)
     I              CHML23                      ML(23)
     I              CHML24                      ML(24)
     I              CHML25                      ML(25)
     I              CHML26                      ML(26)
     I              CHML27                      ML(27)
     I              CHML28                      ML(28)
     I              CHML29                      ML(29)
     I              CHML30                      ML(30)
     I              CHML31                      ML(31)
     I              CHML32                      ML(32)
     I              CHML33                      ML(33)
     I              CHML34                      ML(34)
     I              CHML35                      ML(35)
     I              CHML36                      ML(36)
     I              CHML37                      ML(37)
     I              CHML38                      ML(38)
     I              CHML39                      ML(39)
     I              CHML40                      ML(40)
      *?
     C                   DoW       *InLR <> *On
    ?C                   Select
    ?C                   When      Screen = 01
    ?C                   ExSr      Edit01
    ?C                   When      Screen = 02
    ?C                   ExSr      Edit02
    ?C                   When      Screen = 03
    ?C                   ExSr      Edit03
    ?C                   When      Screen = 04
    ?C                   ExSr      Edit04
    ?C                   When      Screen = 05
    ?C                   ExSr      Edit05
    ?C                   When      Screen = 06
    ?C                   ExSr      Edit06
    ?C                   When      Screen = 07
    ?C                   ExSr      Edit07
    ?C                   When      Screen = 08
    ?C                   ExSr      Edit08
    ?C                   When      Screen = 09
    ?C                   ExSr      Edit09
    ?C                   When      Screen = 10
    ?C                   ExSr      Edit10
    ?C                   When      Screen = 11
    ?C                   ExSr      Edit11
    ?C                   When      Screen = 12
    ?C                   ExSr      Edit13
    ?C                   When      Screen = 13
    ?C                   ExSr      Edit13
    ?C                   Other
     C                   Eval      *InLR = *On
    ?C                   EndSL
     C                   EndDo

     C                   Return


      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?
     C                   MOVE      *BLANKS       OPROD
     C                   MOVE      *BLANKS       UPDATE            1
     C                   Z-ADD     0             OPPM
     C                   Eval      RepeatScrn01 = *Off
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       9899
      /free

           $getipaddress( rcvar   :
                          varlen  :
                          format  :
                          @job    :
                          Apierror
                                   );
           ipaddress = %subst( rcvar:878:15);
         //dsply ipaddress ' ';

      /end-free
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?
     C                   Eval      STRDAT = $Date7($DateMDY(FRMDAT))
    ?C     STRDAT        CHAIN(N)  FFCMCTL
    ?C                   If        not %Found(FFCMCTL)
     C                   Eval      $ERR_MsgID = 'DATE910'
     C                   Eval      $ERR_MsgData = *Blanks
    ?C                   ExSr      $SndError
     C                   Eval      RepeatScrn01 = *On
    ?C                   ExSr      Scrn01
     C                   EndIf
     C                   Eval      RANGE = 0
     C                   Reset                   LocCode
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load03 - Load Screen 03                            :
      *?  :.........................................................:
    ?C     Load03        BegSr                                                  ?
     C                   Eval      Sect  = 0
     C                   Eval      SSect00(1) = (Range * 5) - 4
     C                   Eval      SSect00(2) = (Range * 5) - 3
     C                   Eval      SSect00(3) = (Range * 5) - 2
     C                   Eval      SSect00(4) = (Range * 5) - 1
     C                   Eval      SSect00(5) = (Range * 5)
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load04 - Load Screen 04                            :
      *?  :.........................................................:
    ?C     Load04        BegSr                                                  ?

     C                   Eval      BayX = *Zero
     C                   Clear                   SBAY00
    ?C     Sect          SetLL     FCSECTL1                                     ?
    ?C     Sect          ReadE     FCSECTL1                                     ?
     C                   DoW       not %EOF(FCSECTL1)
     C                   Eval      Bay  = GHBAY
     C                   Eval      BayX = BayX + 1
     C                   Eval      SBay00(BayX) = %Char(GHBAY)
    ?C     SectBay       SetGT     FCSECTL1                                     ?
    ?C     Sect          ReadE     FCSECTL1                                     ?
     C                   EndDo

     C                   Eval      Bay  = *Zero

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load05 - Load Screen 05                            :
      *?  :.........................................................:
    ?C     Load05        BegSr                                                  ?

     C                   Eval      NoSX = *Zero
     C                   Clear                   SNoS00
    ?C     SectBay       SetLL     FCSECTL1
    ?C     SectBay       ReadE     FCSECTL1
     C                   DoW       not %EOF(FCSECTL1)
     C                   Eval      NoSX = NoSX + 1
     C                   Eval      NORS = GHNORS
     C                   Eval      EORW = GHEORW
     C                   Eval      SNoS00(NoSX) = GHNORS + %Trim(GHEORW)
    ?C     SectBaySide   SetGT     FCSECTL1
    ?C     SectBay       ReadE     FCSECTL1
     C                   EndDo

     C                   Eval      NOS = *Blanks

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load06 - Load Screen 06                            :
      *?  :.........................................................:
    ?C     Load06        BegSr                                                  ?

     C                   Z-ADD     1             X
     C     NOS           LOOKUP    NSEW(X)                            90  90
     C   90              Eval      NSEWtext = NSEWtxt(X)
     C  N90              Eval      NSEWtext = 'Not Valid'

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load07 - Load Screen 07                            :
      *?  :.........................................................:
    ?C     Load07        BegSr                                                  ?

     C                   Eval       TAG# = *Zero
     C*                  If         UseTags
     C*                  Reset                   Sect
     C*                  EndIf

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load08 - Load Screen 08                            :
      *?  :.........................................................:
    ?C     Load08        BegSr                                                  ?

     C                   If        UseTags and not OvrTags
     C                   Eval      Sect = FLSECT
     C                   Eval      Bay  = FLBAY
     C                   Eval      NORS = FLNORS
     C                   Eval      EORW = FLEORW

     C                   Eval      GHSect = FLSECT
     C                   Eval      GHBay  = FLBAY
     C                   Eval      GHNORS = FLNORS
     C                   Eval      GHEORW = FLEORW

     C                   Eval      locSect = FLSECT
     C                   Eval      locBay  = FLBAY
     C                   Eval      locNORS = FLNORS
     C                   Eval      locEORW = FLEORW

     C                   Eval      Pole = FLSRTP
     C                   Eval      OvrTags = *Off
     C                   EndIf

    ?C     ItemSize      Chain     FMINVT
     C                   Eval      DES1 = IMDES1
     C                   Eval      TRAYIN = FLQTY
     C                   Eval      POLEIN = FLTOTP

     C                   Eval      PROD = *Blanks
     C                   Eval      PPM = *Zeros

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load09 - Load Screen 09                            :
      *?  :.........................................................:
    ?C     Load09        BegSr                                                  ?
      *?  Stop using default and make program go directly to Prompt for Chem
     C   99
     CanN99              Do
     C                   MOVE      *BLANKS       OPROD             4
     C                   Z-ADD     0             OPPM              7 2
     C                   MOVE      *BLANKS       SPDES1
     C                   Eval      PROD = *Blanks
     C*                  Eval      PPMI = *Zero
     C                   Eval      PPM = *Zero
    ?C     DFTKEY        CHAIN     FFCMDFT                            31
     C   31              MOVE      *BLANKS       PROD
     C  N31              MOVEL     CDCHEM        PROD
    ?C  N31CHMKEY        CHAIN     FMINVT                             32
     C                   If        not *In31 and not *In32
     C                   MOVEL     IMDES1        SPDES1
     C                   If        IMDES2 <> *Blanks
     C                   Z-ADD     1             X
     C     CDCHEM        LOOKUP    IT(x)                                  90
     C   90              Eval      PPM = PM(x)
     C*  90              Eval      PPMi = PPM / 100
     C  N90              Eval      PPM = *Zero
     C* N90              Eval      PPMi = *Zero
     C                   EndIf
     C                   EndIf
     C                   EndDo
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load10 - Load Screen 10                            :
      *?  :.........................................................:
    ?C     Load10        BegSr                                                  ?
     C                   Z-ADD     1             X
     C                   Z-ADD     1             Y                 2 0
     C     X             DOUGT     40
     C     IT(X)         IFNE      SVIT
     C     IT(X)         ANDNE     *BLANKS
     C                   MOVE      IT(X)         SVIT             12
     C                   MOVE      SVIT          ITKEY            12
     C                   MOVE      '700'         SZKEY             3
    ?C     SCMKEY        CHAIN     FMINVT                             33
     C   33              MOVEL     *BLANKS       SD(Y)
     C   33              MOVEL     *BLANKS       SDS(Y)
     C  N33              MOVEL     IMDES1        SD(Y)
     C  N33              MOVEL     IMDES1        SDS(Y)
     C  N33              MOVE      IMITEM        DS(Y)
     C                   ADD       1             Y
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load11 - Load Screen 11                            :
      *?  :.........................................................:
    ?C     Load11        BegSr                                                  ?
     C                   CLEAR                   SPPM
     C                   Z-ADD     1             X
     C                   Z-ADD     1             Y                 2 0
     C     X             DOUGT     40
     C     IT(X)         IFEQ      PROD
     C                   Z-ADD     PM(X)         SC(Y)
     C                   ADD       1             Y
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
     C                   MOVEA     SC            SS
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load12 - Load Screen 12                            :
      *?  :.........................................................:
    ?C     Load12        BegSr                                                  ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load13 - Load Screen 13                            :
      *?  :.........................................................:
    ?C     Load13        BegSr                                                  ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
     C                   Eval      *In50 = *On
     C                   Eval      *In92 = *On
    ?C                   Write     ASSUME                                       ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FCR10101                                     ?
    ?C                   ExSr      $ClrError                                    ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
    ?C                   Write     ASSUME                                       ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FCR10102                                     ?
    ?C                   ExSr      $ClrError                                    ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn03 - Display Screen 03                         :
      *?  :.........................................................:
    ?C     Scrn03        BegSr                                                  ?
     C                   Z-Add     03            Screen            3 0          ?Screen  Number
    ?C                   Write     ASSUME                                       ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FCR10103                                     ?
    ?C                   ExSr      $ClrError                                    ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn04 - Display Screen 04                         :
      *?  :.........................................................:
    ?C     Scrn04        BegSr                                                  ?
     C                   Z-Add     04            Screen            3 0          ?Screen  Number
    ?C                   Write     ASSUME                                       ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FCR10104                                     ?
    ?C                   ExSr      $ClrError                                    ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn05 - Display Screen 05                         :
      *?  :.........................................................:
    ?C     Scrn05        BegSr                                                  ?
     C                   Z-Add     05            Screen            3 0          ?Screen  Number
    ?C                   Write     ASSUME                                       ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FCR10105                                     ?
    ?C                   ExSr      $ClrError                                    ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn06 - Display Screen 06                         :
      *?  :.........................................................:
    ?C     Scrn06        BegSr                                                  ?
     C                   Z-Add     06            Screen            3 0          ?Screen  Number
    ?C                   Write     ASSUME                                       ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FCR10106                                     ?
    ?C                   ExSr      $ClrError                                    ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn07 - Display Screen 07                         :
      *?  :.........................................................:
    ?C     Scrn07        BegSr                                                  ?
     C                   Z-Add     07            Screen            3 0          ?Screen  Number
    ?C                   Write     ASSUME                                       ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FCR10107                                     ?
    ?C                   ExSr      $ClrError                                    ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn08 - Display Screen 08                         :
      *?  :.........................................................:
    ?C     Scrn08        BegSr                                                  ?
     C                   Z-Add     08            Screen            3 0          ?Screen  Number
    ?C                   Write     ASSUME                                       ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FCR10108                                     ?
    ?C                   ExSr      $ClrError                                    ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn09 - Display Screen 09                         :
      *?  :.........................................................:
    ?C     Scrn09        BegSr                                                  ?
     C                   Z-Add     09            Screen            3 0          ?Screen  Number
    ?C                   Write     ASSUME                                       ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FCR10109                                     ?
    ?C                   ExSr      $ClrError                                    ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn10 - Display Screen 10                         :
      *?  :.........................................................:
    ?C     Scrn10        BegSr                                                  ?
     C                   Z-Add     10            Screen            3 0          ?Screen  Number
    ?C                   Write     ASSUME                                       ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FCR10110                                     ?
    ?C                   ExSr      $ClrError                                    ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn11 - Display Screen 11                         :
      *?  :.........................................................:
    ?C     Scrn11        BegSr                                                  ?
     C                   Z-Add     11            Screen            3 0          ?Screen  Number
    ?C                   Write     ASSUME                                       ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FCR10111                                     ?
    ?C                   ExSr      $ClrError                                    ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn12 - Display Screen 12                         :
      *?  :.........................................................:
    ?C     Scrn12        BegSr                                                  ?
     C                   Z-Add     12            Screen            3 0          ?Screen  Number
    ?C                   Write     ASSUME                                       ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FCR10112                                     ?
    ?C                   ExSr      $ClrError                                    ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn13 - Display Screen 13                         :
      *?  :.........................................................:
    ?C     Scrn13        BegSr                                                  ?
     C                   Z-Add     13            Screen            3 0          ?Screen  Number
    ?C                   Write     ASSUME                                       ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FCR10113                                     ?
    ?C                   ExSr      $ClrError                                    ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit01 - Edit Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       1299
     C
      *? CHK F KEYS
    ?C                   Select
    ?C                   When      *InKB or *InKF
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
    ?C                   When      *InKC or *InKG
     C                   Eval      *InLR = *On
     C                   Return
      *? CHECK INPUT
    ?C                   When      FrmDat  = *Zeros                             ?No Date Entered
     C                   Eval      $ERR_MsgID = 'DATE902'
     C                   Eval      $ERR_MsgData = 'Spray Week Monday'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn01
    ?C                   When      not $isDate#(FRMDAT:'*MDY')
     C                   Eval      $ERR_MsgID = 'DATE901'
     C                   Eval      $ERR_MsgData = %Char(FRMDAT)
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn01
    ?C*                  When      $WeekDay($DateMDY(FrmDat ):'MON') <> 1       ?Date not a Monday
     C*                  Eval      $ERR_MsgID = 'DATE904'
     C*                  Eval      $ERR_MsgData = %EditW(FrmDat :'  /  /  ')
     C*                  Eval      FrmDat =
     C*                            $MDYDate($Monday($DateMDY(FrmDat ):'MON'))
     C*                  Eval      $ERR_MsgData = %Trim($ERR_MsgData) +
     C*                            %EditW(FrmDat :'  /  /  ')
    ?C*                  ExSr      $SndError
    ?C*                  ExSr      Scrn01
      **
    ?C                   Other                                                  ?
    ?C                   ExSr      Load02
     C                   If        not RepeatScrn01
    ?C                   ExSr      Scrn02
     C                   EndIf
    ?C                   EndSl                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit02 - Edit Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?Select G/H Range

    ?C                   Select                                                 ?

    ?C                   When      *InKB
    ?C                   ExSr      Scrn01

    ?C                   When      *InKC or *InKG
     C                   Eval      *InLR = *On

    ?C                   When      *InKF
     C                   Eval      UseTags = *On
    ?C                   ExSr      Load07
    ?C                   ExSr      Scrn07

    ?C                   When      Range <> 0 and SRANGE <> 0
     C                   Eval      $ERR_MsgID = 'FCR1010'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn02

    ?C                   When          LocCode <> *Blanks
    ?C                             and LocCode <> '00000  '
    ?C     SectBaySide3  Chain     FCSECTL1                                     ?

     C                   Eval      Range  = GHOUSE
     C                   Eval      Sect   = locSect
    ?C                   ExSr      Load03
     C                   Eval      Sect   = locSect
     C                   Eval      GHSECT = locSect

     C                   Eval      Bay    = locBay
    ?C                   ExSr      Load04
     C                   Eval      Bay    = locBay
     C                   Eval      GHBAY  = locBay

     C                   Eval      NOS    = locNorS + locEorW
     C                   Eval      NorS   = locNorS
     C                   Eval      EorW   = locEorW
    ?C                   ExSr      Load05
     C                   Eval      NOS    = locNorS + locEorW
     C                   Eval      NorS   = locNorS
     C                   Eval      EorW   = locEorW
     C                   Eval      GHNORS = locNorS
     C                   Eval      GHEORW = locEorW

     C                   Clear                   LocCode

    ?C                   ExSr      Load06
    ?C                   ExSr      Scrn06

    ?C                   When      Range = *Zero and SRANGE = *Zero             ?
     C                   Eval      $ERR_MsgID = 'FCR1001'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn02

    ?C                   When      ( Range < 1 or Range > 3 ) and SRANGE = *Zero             ?
     C                   Eval      $ERR_MsgID = 'FCR1002'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn02

    ?C                   Other

     C                   If        Range = 0 and SRANGE <> 0
     C                   Eval      RANGE = SRANGE
     C                   EndIf

     C                   Eval      GHOUSE = RANGE

    ?C                   ExSr      Load03
    ?C                   ExSr      Scrn03

    ?C                   EndSl

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit03 - Edit Screen 03                            :
      *?  :.........................................................:
    ?C     Edit03        BegSr                                                  ?Edit G/H Section

    ?C                   Select                                                 ?

    ?C                   When      *InKB
    ?C                   ExSr      Scrn02

    ?C                   When      *InKC or *InKG
     C                   Eval      *InLR = *On

    ?C                   When      Sect  = *Zero and SSect  = *Zero             ?
     C                   Eval      $ERR_MsgID = 'FCR1003'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn03

    ?C                   When      Sect <> *Zero and SSect <> *Zero             ?
     C                   Eval      $ERR_MsgID = 'FCR1010'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn03

    ?C                   When      (Sect < SSect00(1) or Sect > SSect00(5))
    ?C                             and SSect  = *Zero
     C                   Eval      $ERR_MsgID = 'FCR1004'
     C                   Eval      $ERR_MsgData = %EditW(SSect00(1):'  ')
     C                                          + %EditW(SSect00(5):'  ')
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn03

    ?C                   Other

     C                   If        Sect  = *Zero and SSect  <> *Zero             ?
     C                   Eval      Sect  = SSect00(SSect)
     C                   EndIf

     C                   Eval      GHSECT  = Sect
     C                   Eval      locSect = Sect
    ?C                   ExSr      Load04
    ?C                   ExSr      Scrn04

    ?C                   EndSl

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit04 - Edit Screen 04                            :
      *?  :.........................................................:
    ?C     Edit04        BegSr                                                  ?Select Bay

    ?C                   Select                                                 ?

    ?C                   When      *InKB
    ?C                   ExSr      Scrn03

    ?C                   When      *InKC or *InKG
     C                   Eval      *InLR = *On

    ?C                   When      Bay   = *Zero and SBay   = *Zero             ?
     C                   Eval      $ERR_MsgID = 'FCR1005'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn04

    ?C                   When      Bay  <> *Zero and SBay  <> *Zero             ?
     C                   Eval      $ERR_MsgID = 'FCR1010'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn04

    ?C                   When      Bay <> *Zero and
    ?C                             ( %Char(Bay) < Sbay00(1) or
    ?C                               %Char(Bay) > SBay00(BayX) )
     C                   Eval      $ERR_MsgID = 'FCR1006'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn04

    ?C                   When      SBay <> *Zero and
    ?C                             %Len(%Trim(SBay00(SBay))) <= *Zero
     C                   Eval      $ERR_MsgID = 'FCR1005'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn04

    ?C                   Other

     C                   If        Bay   = *Zero and SBay   <> *Zero             ?
     C                   Eval      Bay   = %Int(SBay00(SBay))
     C                   EndIf

     C                   Eval      locBay = Bay
     C                   Eval      GHBAY  = Bay
    ?C                   ExSr      Load05
    ?C                   ExSr      Scrn05

    ?C                   EndSl
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit05 - Edit Screen 05                            :
      *?  :.........................................................:
    ?C     Edit05        BegSr                                                  ?N, S, E, W.

    ?C     SectBaySide2  Chain     FCSECTL1                                     ?

    ?C                   Select                                                 ?

    ?C                   When      *InKB
    ?C                   ExSr      Scrn04

    ?C                   When      *InKC or *InKG
     C                   Eval      *InLR = *On

    ?C                   When      SNOS <> *Zero and NOS <> *Blanks
     C                   Eval      $ERR_MsgID = 'FCR1007'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn05

    ?C                   When      SNOS  = *Zero and NOS  = *Blanks
     C                   Eval      $ERR_MsgID = 'FCR1010'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn05

    ?C                   When      NOS <> *Blanks and not %Found(FCSECTL1)
     C                   Eval      $ERR_MsgID = 'FCR1007'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn05

    ?C                   Other

     C                   If        SNOS <> *Zero and NOS = *Blanks
     C                   Eval      NOS   = SNOS00(SNOS)
     C                   Z-ADD     1             X
     C     NOS           LOOKUP    NSEW(X)                            90  90
     C   90              Eval      NSEWtext = NSEWtxt(X)
     C  N90              Eval      NSEWtext = 'Not Valid'
     C                   EndIf

     C                   Eval      GHNORS = %Subst(NOS:1:1)
     C                   Eval      GHEORW = %Subst(NOS:2:1)
     C                   Eval      locNorS= %Subst(NOS:1:1)
     C                   Eval      locEorW= %Subst(NOS:2:1)
    ?C                   ExSr      Load06
    ?C                   ExSr      Scrn06

    ?C                   EndSl
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit06 - Edit Screen 06                            :
      *?  :.........................................................:
    ?C     Edit06        BegSr                                                  ?Pole
    ?C                   Select                                                 ?

    ?C                   When      *InKB
    ?C                   ExSr      Scrn05

    ?C                   When      *InKC or *InKG
     C                   Eval      *InLR = *On

    ?C                   Other

    ?C                   ExSr      Load07
    ?C                   ExSr      Scrn07

    ?C                   EndSl
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit07 - Edit Screen 07                            :
      *?  :.........................................................:
    ?C     Edit07        BegSr                                                  ?Tag #

    ?C     Tag#          Chain     FFINLOC                                      ?
     C                   Z-add     FLGHSE        GHSE              2 0
    ?C     LocationKey   Chain     FFCMJOBITM                                   ?

    ?C                   Select                                                 ?

    ?C                   When      *InKB and %Found(FFINLOC)
     C                   Eval      Range  = GHOUSE
     C                   Eval      Sect   = GHSECT
     C                   Eval      locSect= GHSECT
    ?C                   ExSr      Load03
     C                   Eval      Range = GHOUSE
     C                   Eval      Sect  = GHSECT
     C                   Eval      locSect= GHSECT

     C                   Eval      Bay    = GHBAY
    ?C                   ExSr      Load04
     C                   Eval      Bay    = GHBAY
     C                   Eval      locBay = GHBAY

     C                   Eval      NOS    = GHNORS + GHEORW
     C                   Eval      NorS   = GHNORS
     C                   Eval      EorW   = GHEORW
    ?C                   ExSr      Load05
     C                   Eval      NOS    = GHNORS + GHEORW
     C                   Eval      NorS   = GHNORS
     C                   Eval      EorW   = GHEORW
     C                   Eval      locNorS= GHNORS
     C                   Eval      locEorW= GHEORW

    ?C                   ExSr      Load06
     C                   If        UseTags
     C                   Eval      OvrTags = *On
     C                   EndIf
    ?C                   ExSr      Scrn06

    ?C                   When      *InKB and not %Found(FFINLOC)
    ?C                   ExSr      Scrn06

    ?C                   When      *InKC or *InKG
     C                   Eval      *InLR = *On

    ?C                   When      not %Found(FFINLOC)
     C                   Eval      $ERR_MsgID = 'FCR1008'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn07

    ?C*                  When      %Found(FFCMJOBITM)
     C*                  Eval      $ERR_MsgID = 'FCR1009'
    ?C*                  ExSr      $SndError
    ?C*                  ExSr      Scrn07

    ?C                   Other

    ?C                   ExSr      Load08
    ?C                   ExSr      Scrn08

    ?C                   EndSl
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit08 - Edit Screen 08                            :
      *?  :.........................................................:
    ?C     Edit08        BegSr                                                  ?Trays and Poles
    ?C                   Select                                                 ?

    ?C                   When      *InKB
    ?C                   ExSr      Scrn07

    ?C                   When      *InKC or *InKG
     C                   Eval      *InLR = *On

    ?C                   Other

     C                   Select
     C                   When      PROD <> *Blanks and PPM <> 0
    ?C                   ExSr      Load09
    ?C                   ExSr      Scrn09

     C                   When      PROD = *Blanks
    ?C                   ExSr      Load10
    ?C                   ExSr      Scrn10

     C                   When      PPM = 0
    ?C                   ExSr      Load11
    ?C                   ExSr      Scrn11
     C                   EndSl

    ?C                   EndSl
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit09 - Edit Screen 09                            :
      *?  :.........................................................:
    ?C     Edit09        BegSr                                                  ?Chemical and PPM
    ?C                   Select                                                 ?

    ?C                   When      *InKB
    ?C                   ExSr      Scrn08

    ?C                   When      *InKC or *InKG
     C                   Eval      *InLR = *On

    ?C                   When      PROD = *Blanks
    ?C                   ExSr      Load10
    ?C                   ExSr      Scrn10

    ?C                   When      PPM  = *Zero
    ?C                   ExSr      Load11
    ?C                   ExSr      Scrn11

    ?C                   Other

      *?     Write the records for this item and prepare for the next item tag.
    ?C                   ExSr      WriteRecs
     C                   Eval      LastTag# = Tag#
    ?C                   ExSr      Load07
    ?C                   ExSr      Scrn07

    ?C                   EndSl
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit10 - Edit Screen 10                            :
      *?  :.........................................................:
    ?C     Edit10        BegSr                                                  ?Chemical Selection
    ?C                   Select                                                 ?

    ?C                   When      *InKB
    ?C                   ExSr      Load09
    ?C                   ExSr      Scrn09

    ?C                   When      *InKC or *InKG
     C                   Eval      *InLR = *On

    ?C     CSRFLD        WhenGE    'CHM01'
    ?C     CSRFLD        ANDLE     'CHM40'
     C                   MOVE      CSRFL#        X
     C                   MOVEL     DS(X)         PROD
     C                   MOVEL     SDS(X)        SPDES1
     C                   If        PPM = *Zero
    ?C                   ExSr      Load11
    ?C                   ExSr      Scrn11
     C                   Else
    ?C                   ExSr      Scrn09
     C                   EndIf

    ?C                   Other

    ?C                   ExSr      Scrn10

    ?C                   EndSl

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit11 - Edit Screen 11                            :
      *?  :.........................................................:
    ?C     Edit11        BegSr                                                  ?PPM Selection
    ?C                   Select                                                 ?

    ?C                   When      *InKB
    ?C                   ExSr      Load10
    ?C                   ExSr      Scrn10

    ?C                   When      *InKC or *InKG
     C                   Eval      *InLR = *On

    ?C                   When      CSRFLD >= 'PPM01' and
    ?C                             CSRFLD <= 'PPM40'
     C                   MOVE      CSRFL#        X
     C                   Z-ADD     SC(X)         PPM
     C*                  Eval      PPMI = PPM / 100
    ?C                   ExSr      Scrn09

    ?C                   Other

    ?C                   ExSr      Load11
    ?C                   ExSr      Scrn11

    ?C                   EndSl
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit12 - Edit Screen 12                            :
      *?  :.........................................................:
    ?C     Edit12        BegSr                                                  ?
    ?C                   Select                                                 ?

    ?C                   When      *InKB
    ?C                   ExSr      Scrn11

    ?C                   When      *InKC or *InKG
     C                   Eval      *InLR = *On

    ?C                   Other

    ?C                   ExSr      Load13
    ?C                   ExSr      Scrn13

    ?C                   EndSl
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit13 - Edit Screen 13                            :
      *?  :.........................................................:
    ?C     Edit13        BegSr                                                  ?
    ?C                   Select                                                 ?

    ?C                   When      *InKB
    ?C                   ExSr      Scrn12

    ?C                   When      *InKC or *InKG
     C                   Eval      *InLR = *On

    ?C                   Other

    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01

    ?C                   EndSl
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      WriteRecs - Write / Update output files            :
      *?  :.........................................................:
    ?C     WriteRecs     BegSr                                                  ?

     C                   Eval      Now   = $Now()

      *?                 Update FFCCTL
    ?C     STRDAT        CHAIN     FFCMCTL                            91
     C                   Z-ADD     CHNJOB        JOB#              6 0
     C                   ADD       1             CHNJOB
    ?C  N91              UPDATE    RCHMCTL

      *?                 Write/Update FFCMLOC
     C*                  Clear                   RCHMLOC
     C                   Eval      CurrentPole = FLSRTP
     C                   Eval      CLTRAY = *Zero                               ?# TRAYS
     C                   DoW       CurrentPole <= (FLSRTP + POLEIN)
    ?C     Location      Chain     RCHMLOC
     C                   Eval      CLWKDT = STRDAT                              ?WEEK DATE CYMD
     C                   Eval      CLSECT = FLSECT                              ?SECTION #
     C                   Eval      CLBAY  = FLBAY                               ?BAY #
     C                   Eval      CLNOS  = FLNORS                              ?NORTH/SOUTH
     C                   Eval      CLPOLE = CurrentPole                         ?POLE #
     C                   Eval      CLEOW  = FLEORW                              ?E/W
     C                   Eval      CLPLKY = CurrentPole                         ?POLE KEY #
     C                   Eval      CLTRAY = CLTRAY + 1                          ?# TRAYS
     C                   Eval      CLPOLS = *Zeros                              ?# POLES
     C                   Eval      CLDTLA = Today                               ?LAST ACTIVITY
     C                   Eval      CLTIME = Now                                 ?TIME
     C                   Eval      CLUSER = User                                ?USER
     C                   If        %Found(FFCMLOC)
    ?C                   Update    RCHMLOC
     C                   Else
    ?C                   Write     RCHMLOC
     C                   EndIf
     C                   Eval      CurrentPole = CurrentPole + 1
     C                   EndDo

      *?                 Write FFCMJOB
    ?C                   Clear                   RMINSER                        ?
    ?C     FLITEM        Chain     FMINSER
     C                   Eval      CJWKDT = STRDAT                              ?WEEK DATE CYMD
     C                   Eval      CJSTAT = *Blanks                             ?STATUS
     C                   Eval      CJJOB# = Job#                                ?JOB #
     C                   Eval      CJSPIT = PROD                                ?CHEMICAL ITEM #
     C                   Eval      CJSPSZ = '700'                               ?CHEMICAL SIZE
     C                   Eval      CJPPM  = PPM                                 ?PPM
     C                   Eval      CJITEM = FLITEM                              ?ITEM #
     C                   Eval      CJSIZE = FLSIZE                              ?SIZE CODE
     C                   Eval      CJLOOK = DES1                                ?ALPHA SEARCH
     C                   Eval      CJLOPT = *Blanks                             ?ALPHA USED AS LIMIT
     C                   Eval      CJSERI = ISCODE                              ?SERIES CODE
     C                   Eval      CJRDYD = $MDYDate(FLDATE)                    ?READY DATE
     C                   Eval      CJSPRY = *Blanks                             ?SPRAYER
     C                   Eval      CJTRAY = TRAYIN                              ?# TRAYS
     C                   Eval      CJPOLE = POLEIN                              ?# POLES
     C                   Eval      CJHSE  = %int((FLSECT+4)/5)                  ?HOUSE #
     C                   Eval      CJSECT = SECT                                ?SECTION #
     C                   Eval      CJBAY  = BAY                                 ?BAY #
     C                   Eval      CJNOS  = %Subst(NOS:1:1)                     ?NORTH/SOUTH
     C                   Eval      CJSPOL = POLE                                ?START POLE #
     C                   Eval      CJSEOW = %Subst(NOS:2:1)                     ?START L/R
     C                   Eval      CJTRBP = *Zero                               ?# TRAYS BEG. POLE
     C                   Eval      CJSPKY = POLE                                ?START POLE KEY #
     C                   Eval      CJEPOL = %Int(POLE + POLEIN)                 ?END POLE #
     C                   Eval      CJEEOW = %Subst(NOS:2:1)                     ?END L/R
     C                   Eval      CJTREP = *Zero                               ?# TRAYS END POLE
     C                   Eval      CJEPKY = %Int(POLE + POLEIN)                 ?END POLE KEY #
     C                   Eval      CJRUN# = *Zeros                              ?SPRAYER RUN #
     C                   Eval      CJDTLA = Today                               ?LAST ACTIVITY DATE
     C                   Eval      CJTIME = Now                                 ?TIME
     C                   Eval      CJUSER = User                                ?USER
    ?C                   Write     RCHMJOB

      *?                 Write FFCMLOC
    ?C     DefaultKey    CHAIN     FFCMDFT
     C                   Eval      CDITEM = FLITEM                              ?Item Number
     C                   Eval      CDSIZE = FLSIZE                              ?Item Size
     C                   Eval      CDCHEM = PROD                                ?Default Chemical
     C                   Eval      CDCSIZ = '700'                               ?Chem. Size Code
     C                   If        %Found(FFCMDFT)
    ?C                   Update    RCHMDFT
     C                   Else
    ?C                   Write     RCHMDFT
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?*********************
      *? SCREEN "G" LOGIC  **
      *?*********************
    ?C     DISP10        BEGSR
      *? Process Screen G until F-Key or CHEMICAL selected
     C     *INKB         DOUEQ     *ON
     C     *INKC         OREQ      *ON
     C     CSRFLD        ORGE      'CHM01'
     C     CSRFLD        ANDLE     'CHM14'
     C     PROD          ANDNE     *BLANKS

     C                   EXFMT     FCR10109

     C     CSRFLD        IFGE      'CHM01'
     C     CSRFLD        ANDLE     'CHM14'
     C     *INKB         ANDNE     *ON
     C     *INKC         ANDNE     *ON
     C                   MOVE      CSRFL#        X
     C                   MOVEL     DS(X)         PROD
     C                   MOVEL     SDS(X)        SPDES1
     C                   ENDIF

     C                   ENDDO

    ?C                   ENDSR
      *?*********************
      *? SCREEN "H" LOGIC  **
      *?*********************

    ?C     DISP11        BEGSR

      *? Process Screen 08 Until F-Key or PPM selected
     C     *INKB         DOUEQ     *ON
     C     *INKC         OREQ      *ON
     C     CSRFLD        ORGE      'PPM01'
     C     CSRFLD        ANDLE     'PPM40'
     C     PPM           ANDNE     *ZERO

     C                   EXFMT     FCR10108

     C     CSRFLD        IFGE      'PPM01'
     C     CSRFLD        ANDLE     'PPM40'
     C     *INKB         ANDNE     *ON
     C     *INKC         ANDNE     *ON
     C                   MOVE      CSRFL#        X
     C                   Z-ADD     pm(X)         PPM
     C                   ENDIF

     C                   ENDDO

    ?C                   ENDSR


      *?  ...........................................................
      *?  :      GETLOC - Update Location                           :
      *?  :.........................................................:

    ?C     GETLOC        BEGSR

    ?C     LOCOUT        CHAIN     FFCMLOC                            92
     C   92              Z-ADD     0             CLTRAY
     C                   ADD       CLWKTR        CLTRAY
     C                   TIME                    CLTIME
     C*                  Z-ADD     TDATE         CLDTLA
     C                   Z-ADD     Today         CLDTLA
     C                   MOVEL     USERID        CLUSER
    ?C   92              WRITE     RCHMLOC
    ?C  N92              UPDATE    RCHMLOC
     C     *LIKE         DEFINE    CLSECT        NXSECT                         ?SECTION #
     C     *LIKE         DEFINE    CLBAY         NXBAY                          ?BAY #
     C     *LIKE         DEFINE    CLNOS         NXNOS                          ?NORTH/SOUTH
     C     *LIKE         DEFINE    CLPOLE        NXPOLE                         ?POLE #
     C     *LIKE         DEFINE    CLPLKY        NXPLKY                         ?POLE KEY #
     C     *LIKE         DEFINE    CLEOW         NXEOW                          ?L/R
     C                   Z-ADD     CLSECT        NXSECT
     C                   Z-ADD     CLBAY         NXBAY
     C                   MOVE      CLNOS         NXNOS
     C                   Z-ADD     CLPOLE        NXPOLE
     C                   Z-ADD     CLPLKY        NXPLKY
     C                   MOVE      CLEOW         NXEOW

    ?C                   ENDSR

      *?  ...........................................................
      *?  :      ERRMSG - Error Message Handling Subroutines        :
      *?  :.........................................................:
    ?D/COPY QFunctDefn,$ErrMsgSr

      *?  ...........................................................
      *?  :      ExitSR - Exit Subroutine                           :
      *?  :.........................................................:

    ?C     ExitSR        BegSr

     C                   Eval      *InLr = *On
     C                   Return

    ?C                   EndSr

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

    ?C     *InzSR        BegSr

     C                   Eval      Today = $MDYDate($Date(0))
     C                   Eval      User  = $User()

     C                   Eval      $ERR_PROG  = 'FCR101    '                    ?Pgm Msg Queue
     C                   Eval      $ERR_MSGF  = 'KPMSGF'                        ?Message File
     C                   Eval      $ERR_LIBR  = '*LIBL'                         ?Library

    ?C     *HiVal        SetGT     FFCMCTL
    ?C                   ReadP(N)  FFCMCTL
     C                   If        $Monday($Date(0):'SAT') > $Date(CHWKDT)
     C                   Eval      FrmDat  = $MDYDate($Monday($Date(0):'SAT'))
     C                   Else
     C                   Eval      FrmDat  = $MDYDate($Date(CHWKDT))
     C                   EndIf

    ?C                   ExSr      $ClrError
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01

    ?C     SectBay       KList                                                  ?
    ?C                   KFld                    SECT                         ?
    ?C                   KFld                    BAY                          ?

    ?C     SectBaySide   KList
    ?C                   KFld                    SECT
    ?C                   KFld                    BAY
    ?C                   KFld                    NORS
    ?C                   KFld                    EORW

    ?C     SectBaySide2  KList                                                  ?
    ?C                   KFld                    SECT                         ?
    ?C                   KFld                    BAY                          ?
    ?C                   KFld                    NORS                           ?
    ?C                   KFld                    EORW                         ?

    ?C     SectBaySide3  KList                                                  ?
    ?C                   KFld                    locSect                        ?
    ?C                   KFld                    locBay                         ?
    ?C                   KFld                    locNorS                        ?
    ?C                   KFld                    locEorW                      ?

    ?C     ItemSize      KList                                                  ?
    ?C                   KFld                    FLITEM                         ?
    ?C                   KFld                    FLSIZE                         ?

    ?C     DFTKEY        KLIST
    ?C                   KFLD                    FLITEM
    ?C                   KFLD                    FLSIZE

    ?C     CHMKEY        KLIST
    ?C                   KFLD                    CDCHEM
    ?C                   KFLD                    CDCSIZ

    ?C     SCMKEY        KLIST                                                  SCREEN CHEM KEY
    ?C                   KFLD                    ITKEY            12
    ?C                   KFLD                    SZKEY             3


    ?C     LocationKey   KList
    ?C                   KFld                    STRDAT
    ?C                   KFld                    GHSE
    ?C                   KFld                    FLSECT
    ?C                   KFld                    FLBAY
    ?C                   KFld                    FLNORS
    ?C                   KFld                    FLEORW
    ?C                   KFld                    FLSRTP
    ?C                   KFld                    FLEORW
    ?C                   KFld                    FLENDP
    ?C                   KFld                    FLITEM
    ?C                   KFld                    FLSIZE

    ?C     Location      KLIST
    ?C                   KFLD                    STRDAT
    ?C                   KFLD                    FLSECT
    ?C                   KFLD                    FLBAY
    ?C                   KFLD                    FLNORS
    ?C                   KFLD                    FLEORW
    ?C                   KFLD                    CurrentPole

    ?C     DefaultKey    KLIST                                                  ?
    ?C                   KFLD                    FLITEM                         ?
    ?C                   KFLD                    FLSIZE                         ?

    ?C     LOCOUT        KLIST
    ?C                   KFLD                    CLWKDT
    ?C                   KFLD                    CLSECT
    ?C                   KFLD                    CLBAY
    ?C                   KFLD                    CLNOS
    ?C                   KFLD                    CLEOW
    ?C                   KFLD                    CLPOLE

    ?C                   EndSr
**
N North
NENortheast
NWNorthwest
S South
SESoutheast
SWSouthwest
