      *--------------------------------------------------------------
      *
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- FCR050
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- REP
      **APPLICATION--------- UPDATE WEEKLY CHEMICAL CONTROL FILE.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  02/18/03  ADDED FFCMOZS FILE    CAB.
      *  8/28/03 EFD ADD FILE CHMWRK FOR SORTING USE
      *
     FFCR050FM  CF   E             WORKSTN
     FFFCMCTL   UF A E           K DISK
     FFFCMPPM   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:ICALEN)
     FFFCMLAB   O  A E           K DISK
     FFFCMWRK   IF   E           K DISK
     F                                     RENAME(RCHMWRK:CHMWRK)
     FFFCMWRKA  UF A E           K DISK
     FFFCMSPY   UF A E           K DISK
CAB  FFFCMOZS   O  A E           K DISK
      *
      ** CONTROL FILE ARRAYS
     D IT              S             12    DIM(40)                              ITEM NUMBERS
     D SZ              S              3    DIM(40)                              SIZE CODES
     D PM              S              7  2 DIM(40)                              PPM
     D OZ              S              7  3 DIM(40)                              OZ/GAL
     D ML              S              7  3 DIM(40)                              ML/GAL
     D MP              S              2  0 DIM(40)                              MAX POLES
      ** SCREEN ARRAYS
     D SIT             S             12    DIM(40)                              ITEM NUMBERS
     D SDS             S             30    DIM(40)                              DESCRIPTIONS
     D SPM             S              6  2 DIM(40)                              PPM
     D SOZ             S              7  3 DIM(40)                              OZ/GAL
     D SML             S              7  3 DIM(40)                              ML/GAL
     D SMP             S              2  0 DIM(40)                              MAX POLES
      ** PPM NUMBER ARRAY
     D PPM             S              4  0 DIM(45)                              PARTS PER MILLION
      ** PPM FILE ARRAYS
     D COZ             S              7  3 DIM(45)                              FILE PPM OUNCE
     D CML             S              7  3 DIM(45)                              FILE PPM M.L.
      ** PPM DESCRIPTION ARRAYS
     D PPI             S              1    DIM(8)                               PARTS PER MILLION
     D PPO             S              1    DIM(8)                               PARTS PER MILLION
      *
      *
     D FirstScreen     S               N   INZ(*On)
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
      *********
      *  LDA  *
      *********
     D                UDS
     D  STRDAT                 1      7  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133

     D  BEGWW          S              2S 0
     D  BEGYY          S              4S 0
     D  Err            S              4S 0

      *
      ** REDEFINE FFCMCTL
     IRCHMCTL
      ** GET ITEM NUMBERS
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
      ** GET SIZE CODES
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
      ** GET PPM
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
      ** GET OUNCES
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
      ** GET ML
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
      *
      ** GET MP
     I              CHMP1                       MP(1)
     I              CHMP2                       MP(2)
     I              CHMP3                       MP(3)
     I              CHMP4                       MP(4)
     I              CHMP5                       MP(5)
     I              CHMP6                       MP(6)
     I              CHMP7                       MP(7)
     I              CHMP8                       MP(8)
     I              CHMP9                       MP(9)
     I              CHMP10                      MP(10)
     I              CHMP11                      MP(11)
     I              CHMP12                      MP(12)
     I              CHMP13                      MP(13)
     I              CHMP14                      MP(14)
     I              CHMP15                      MP(15)
     I              CHMP16                      MP(16)
     I              CHMP17                      MP(17)
     I              CHMP18                      MP(18)
     I              CHMP19                      MP(19)
     I              CHMP20                      MP(20)
     I              CHMP21                      MP(21)
     I              CHMP22                      MP(22)
     I              CHMP23                      MP(23)
     I              CHMP24                      MP(24)
     I              CHMP25                      MP(25)
     I              CHMP26                      MP(26)
     I              CHMP27                      MP(27)
     I              CHMP28                      MP(28)
     I              CHMP29                      MP(29)
     I              CHMP30                      MP(30)
     I              CHMP31                      MP(31)
     I              CHMP32                      MP(32)
     I              CHMP33                      MP(33)
     I              CHMP34                      MP(34)
     I              CHMP35                      MP(35)
     I              CHMP36                      MP(36)
     I              CHMP37                      MP(37)
     I              CHMP38                      MP(38)
     I              CHMP39                      MP(39)
     I              CHMP40                      MP(40)
      ** REDEFINE SCREEN
     ISCRNB
      ** GET ITEM NUMBERS
     I              ITM1                        SIT(1)
     I              ITM2                        SIT(2)
     I              ITM3                        SIT(3)
     I              ITM4                        SIT(4)
     I              ITM5                        SIT(5)
     I              ITM6                        SIT(6)
     I              ITM7                        SIT(7)
     I              ITM8                        SIT(8)
     I              ITM9                        SIT(9)
     I              ITM10                       SIT(10)
     I              ITM11                       SIT(11)
     I              ITM12                       SIT(12)
     I              ITM13                       SIT(13)
     I              ITM14                       SIT(14)
     I              ITM15                       SIT(15)
     I              ITM16                       SIT(16)
     I              ITM17                       SIT(17)
     I              ITM18                       SIT(18)
     I              ITM19                       SIT(19)
     I              ITM20                       SIT(20)
      ** GET PPM
     I              PPM1                        SPM(1)
     I              PPM2                        SPM(2)
     I              PPM3                        SPM(3)
     I              PPM4                        SPM(4)
     I              PPM5                        SPM(5)
     I              PPM6                        SPM(6)
     I              PPM7                        SPM(7)
     I              PPM8                        SPM(8)
     I              PPM9                        SPM(9)
     I              PPM10                       SPM(10)
     I              PPM11                       SPM(11)
     I              PPM12                       SPM(12)
     I              PPM13                       SPM(13)
     I              PPM14                       SPM(14)
     I              PPM15                       SPM(15)
     I              PPM16                       SPM(16)
     I              PPM17                       SPM(17)
     I              PPM18                       SPM(18)
     I              PPM19                       SPM(19)
     I              PPM20                       SPM(20)
      ** GET DESCRIPTIONS
     I              DES1                        SDS(1)
     I              DES2                        SDS(2)
     I              DES3                        SDS(3)
     I              DES4                        SDS(4)
     I              DES5                        SDS(5)
     I              DES6                        SDS(6)
     I              DES7                        SDS(7)
     I              DES8                        SDS(8)
     I              DES9                        SDS(9)
     I              DES10                       SDS(10)
     I              DES11                       SDS(11)
     I              DES12                       SDS(12)
     I              DES13                       SDS(13)
     I              DES14                       SDS(14)
     I              DES15                       SDS(15)
     I              DES16                       SDS(16)
     I              DES17                       SDS(17)
     I              DES18                       SDS(18)
     I              DES19                       SDS(19)
     I              DES20                       SDS(20)
      ** GET OUNCES
     I              OZ1                         SOZ(1)
     I              OZ2                         SOZ(2)
     I              OZ3                         SOZ(3)
     I              OZ4                         SOZ(4)
     I              OZ5                         SOZ(5)
     I              OZ6                         SOZ(6)
     I              OZ7                         SOZ(7)
     I              OZ8                         SOZ(8)
     I              OZ9                         SOZ(9)
     I              OZ10                        SOZ(10)
     I              OZ11                        SOZ(11)
     I              OZ12                        SOZ(12)
     I              OZ13                        SOZ(13)
     I              OZ14                        SOZ(14)
     I              OZ15                        SOZ(15)
     I              OZ16                        SOZ(16)
     I              OZ17                        SOZ(17)
     I              OZ18                        SOZ(18)
     I              OZ19                        SOZ(19)
     I              OZ20                        SOZ(20)
      ** GET ML
     I              ML1                         SML(1)
     I              ML2                         SML(2)
     I              ML3                         SML(3)
     I              ML4                         SML(4)
     I              ML5                         SML(5)
     I              ML6                         SML(6)
     I              ML7                         SML(7)
     I              ML8                         SML(8)
     I              ML9                         SML(9)
     I              ML10                        SML(10)
     I              ML11                        SML(11)
     I              ML12                        SML(12)
     I              ML13                        SML(13)
     I              ML14                        SML(14)
     I              ML15                        SML(15)
     I              ML16                        SML(16)
     I              ML17                        SML(17)
     I              ML18                        SML(18)
     I              ML19                        SML(19)
     I              ML20                        SML(20)
      *
      ** GET MP
     I              MP1                         SMP(1)
     I              MP2                         SMP(2)
     I              MP3                         SMP(3)
     I              MP4                         SMP(4)
     I              MP5                         SMP(5)
     I              MP6                         SMP(6)
     I              MP7                         SMP(7)
     I              MP8                         SMP(8)
     I              MP9                         SMP(9)
     I              MP10                        SMP(10)
     I              MP11                        SMP(11)
     I              MP12                        SMP(12)
     I              MP13                        SMP(13)
     I              MP14                        SMP(14)
     I              MP15                        SMP(15)
     I              MP16                        SMP(16)
     I              MP17                        SMP(17)
     I              MP18                        SMP(18)
     I              MP19                        SMP(19)
     I              MP20                        SMP(20)
      *
     ISCRNB2140
      ** GET ITEM NUMBERS
     I              ITM21                       SIT(21)
     I              ITM22                       SIT(22)
     I              ITM23                       SIT(23)
     I              ITM24                       SIT(24)
     I              ITM25                       SIT(25)
     I              ITM26                       SIT(26)
     I              ITM27                       SIT(27)
     I              ITM28                       SIT(28)
     I              ITM29                       SIT(29)
     I              ITM30                       SIT(30)
     I              ITM31                       SIT(31)
     I              ITM32                       SIT(32)
     I              ITM33                       SIT(33)
     I              ITM34                       SIT(34)
     I              ITM35                       SIT(35)
     I              ITM36                       SIT(36)
     I              ITM37                       SIT(37)
     I              ITM38                       SIT(38)
     I              ITM39                       SIT(39)
     I              ITM40                       SIT(40)
      ** GET PPM
     I              PPM21                       SPM(21)
     I              PPM22                       SPM(22)
     I              PPM23                       SPM(23)
     I              PPM24                       SPM(24)
     I              PPM25                       SPM(25)
     I              PPM26                       SPM(26)
     I              PPM27                       SPM(27)
     I              PPM28                       SPM(28)
     I              PPM29                       SPM(29)
     I              PPM30                       SPM(30)
     I              PPM31                       SPM(31)
     I              PPM32                       SPM(32)
     I              PPM33                       SPM(33)
     I              PPM34                       SPM(34)
     I              PPM35                       SPM(35)
     I              PPM36                       SPM(36)
     I              PPM37                       SPM(37)
     I              PPM38                       SPM(38)
     I              PPM39                       SPM(39)
     I              PPM40                       SPM(40)
      ** GET DESCRIPTIONS
     I              DES21                       SDS(21)
     I              DES22                       SDS(22)
     I              DES23                       SDS(23)
     I              DES24                       SDS(24)
     I              DES25                       SDS(25)
     I              DES26                       SDS(26)
     I              DES27                       SDS(27)
     I              DES28                       SDS(28)
     I              DES29                       SDS(29)
     I              DES30                       SDS(30)
     I              DES31                       SDS(31)
     I              DES32                       SDS(32)
     I              DES33                       SDS(33)
     I              DES34                       SDS(34)
     I              DES35                       SDS(35)
     I              DES36                       SDS(36)
     I              DES37                       SDS(37)
     I              DES38                       SDS(38)
     I              DES39                       SDS(39)
     I              DES40                       SDS(40)
      ** GET OUNCES
     I              OZ21                        SOZ(21)
     I              OZ22                        SOZ(22)
     I              OZ23                        SOZ(23)
     I              OZ24                        SOZ(24)
     I              OZ25                        SOZ(25)
     I              OZ26                        SOZ(26)
     I              OZ27                        SOZ(27)
     I              OZ28                        SOZ(28)
     I              OZ29                        SOZ(29)
     I              OZ30                        SOZ(30)
     I              OZ31                        SOZ(31)
     I              OZ32                        SOZ(32)
     I              OZ33                        SOZ(33)
     I              OZ34                        SOZ(34)
     I              OZ35                        SOZ(35)
     I              OZ36                        SOZ(36)
     I              OZ37                        SOZ(37)
     I              OZ38                        SOZ(38)
     I              OZ39                        SOZ(39)
     I              OZ40                        SOZ(40)
      ** GET ML
     I              ML21                        SML(21)
     I              ML22                        SML(22)
     I              ML23                        SML(23)
     I              ML24                        SML(24)
     I              ML25                        SML(25)
     I              ML26                        SML(26)
     I              ML27                        SML(27)
     I              ML28                        SML(28)
     I              ML29                        SML(29)
     I              ML30                        SML(30)
     I              ML31                        SML(31)
     I              ML32                        SML(32)
     I              ML33                        SML(33)
     I              ML34                        SML(34)
     I              ML35                        SML(35)
     I              ML36                        SML(36)
     I              ML37                        SML(37)
     I              ML38                        SML(38)
     I              ML39                        SML(39)
     I              ML40                        SML(40)
      *
      ** GET MP
     I              MP21                        SMP(21)
     I              MP22                        SMP(22)
     I              MP23                        SMP(23)
     I              MP24                        SMP(24)
     I              MP25                        SMP(25)
     I              MP26                        SMP(26)
     I              MP27                        SMP(27)
     I              MP28                        SMP(28)
     I              MP29                        SMP(29)
     I              MP30                        SMP(30)
     I              MP31                        SMP(31)
     I              MP32                        SMP(32)
     I              MP33                        SMP(33)
     I              MP34                        SMP(34)
     I              MP35                        SMP(35)
     I              MP36                        SMP(36)
     I              MP37                        SMP(37)
     I              MP38                        SMP(38)
     I              MP39                        SMP(39)
     I              MP40                        SMP(40)
      *
      ** REDEFINE FFCMPPM
     IRCHMPPM
      ** GET OUNCES
     I              CMOZ1                       COZ(1)
     I              CMOZ2                       COZ(2)
     I              CMOZ3                       COZ(3)
     I              CMOZ4                       COZ(4)
     I              CMOZ5                       COZ(5)
     I              CMOZ6                       COZ(6)
     I              CMOZ7                       COZ(7)
     I              CMOZ8                       COZ(8)
     I              CMOZ9                       COZ(9)
     I              CMOZ10                      COZ(10)
     I              CMOZ11                      COZ(11)
     I              CMOZ12                      COZ(12)
     I              CMOZ13                      COZ(13)
     I              CMOZ14                      COZ(14)
     I              CMOZ15                      COZ(15)
     I              CMOZ16                      COZ(16)
     I              CMOZ17                      COZ(17)
     I              CMOZ18                      COZ(18)
     I              CMOZ19                      COZ(19)
     I              CMOZ20                      COZ(20)
     I              CMOZ21                      COZ(21)
     I              CMOZ22                      COZ(22)
     I              CMOZ23                      COZ(23)
     I              CMOZ24                      COZ(24)
     I              CMOZ25                      COZ(25)
     I              CMOZ26                      COZ(26)
     I              CMOZ27                      COZ(27)
     I              CMOZ28                      COZ(28)
     I              CMOZ29                      COZ(29)
     I              CMOZ30                      COZ(30)
     I              CMOZ31                      COZ(31)
     I              CMOZ32                      COZ(32)
     I              CMOZ33                      COZ(33)
     I              CMOZ34                      COZ(34)
     I              CMOZ35                      COZ(35)
     I              CMOZ36                      COZ(36)
     I              CMOZ37                      COZ(37)
     I              CMOZ38                      COZ(38)
     I              CMOZ39                      COZ(39)
     I              CMOZ40                      COZ(40)
     I              CMOZ41                      COZ(41)
     I              CMOZ42                      COZ(42)
     I              CMOZ43                      COZ(43)
     I              CMOZ44                      COZ(44)
     I              CMOZ45                      COZ(45)
      ** GET MILLILITERS
     I              CMML1                       CML(1)
     I              CMML2                       CML(2)
     I              CMML3                       CML(3)
     I              CMML4                       CML(4)
     I              CMML5                       CML(5)
     I              CMML6                       CML(6)
     I              CMML7                       CML(7)
     I              CMML8                       CML(8)
     I              CMML9                       CML(9)
     I              CMML10                      CML(10)
     I              CMML11                      CML(11)
     I              CMML12                      CML(12)
     I              CMML13                      CML(13)
     I              CMML14                      CML(14)
     I              CMML15                      CML(15)
     I              CMML16                      CML(16)
     I              CMML17                      CML(17)
     I              CMML18                      CML(18)
     I              CMML19                      CML(19)
     I              CMML20                      CML(20)
     I              CMML21                      CML(21)
     I              CMML22                      CML(22)
     I              CMML23                      CML(23)
     I              CMML24                      CML(24)
     I              CMML25                      CML(25)
     I              CMML26                      CML(26)
     I              CMML27                      CML(27)
     I              CMML28                      CML(28)
     I              CMML29                      CML(29)
     I              CMML30                      CML(30)
     I              CMML31                      CML(31)
     I              CMML32                      CML(32)
     I              CMML33                      CML(33)
     I              CMML34                      CML(34)
     I              CMML35                      CML(35)
     I              CMML36                      CML(36)
     I              CMML37                      CML(37)
     I              CMML38                      CML(38)
     I              CMML39                      CML(39)
     I              CMML40                      CML(40)
     I              CMML41                      CML(41)
     I              CMML42                      CML(42)
     I              CMML43                      CML(43)
     I              CMML44                      CML(44)
     I              CMML45                      CML(45)
      ***********************
      ** LOAD UP DEFAULTS  **
      ***********************
     C                   MOVEL     'P4'          LPRTR
     C                   MOVEL     'LABEL'       LFORM
     C                   Z-ADD     1             LCOPY
     C                   MOVEL     'N'           LJOBQ
     C                   MOVEL     'N'           YORN
     C                   MOVEL     'X'           LCANCL
     C                   Z-ADD     1             VOUT
      ***********************
      ** START OR RESTART  **
      ***********************
     C     RSTART        TAG
     C*                    Z-ADD0         FRMDAT
     C*                    Z-ADD0         BEGYY
     C*                    Z-ADD0         BEGWW
     C                   Z-ADD     0             STRDAT
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       9899
      ** DISPLAY SCREEN
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                         99
      ** CHECK INPUT
      **
      ** CHECK DATE
     C     FRMDAT        IFLE      0
     C     BEGYY         ANDLE     0
     C     BEGWW         ANDLE     0
     C                   SETON                                        10  99
     C                   GOTO      NXTA
     C                   ENDIF
      **
     C     FRMDAT        IFGT      0
     C     FRMDAT        CHAIN     FCALEN                             92
     C   92              DO
     C                   SETON                                        1099
     C                   GOTO      NXTA
     C                   ENDDO
     C*    CL#Y          IFNE      1
     C*                  SETON                                        101199
     C*                  GOTO      NXTA
     C*                  END
     C                   MOVEL     CLCENT        BEGYY
     C                   MOVE      CLYEAR        BEGYY
     C                   Z-ADD     CLWEEK        BEGWW
     C                   Z-ADD     CLCYMD        STRDAT            7 0
     C                   ELSE                                                   FRMDAT > 0
     C                   MOVEL     BEGYY         CLCENT
     C                   MOVE      BEGYY         CLYEAR
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    BEGWW
     C                   KFLD                    CL#Y
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             92
     C   92              DO
     C                   SETON                                        2099
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        FRMDAT
     C                   Z-ADD     CLCYMD        STRDAT            7 0
     C                   END                                                    FRMDAT > 0
      ** IF FIRST TIME REDISPLAY
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   END
     C                   SETOFF                                       98
     C     STRDAT        CHAIN(N)  FFCMCTL                            96
     C   96              DO
     C                   WRITE     SCRNC
     C                   READ      SCRNC                                  90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO                                                  KG DO
     C   KA              DO
     C                   EXSR      CPYWK
     C                   ENDDO                                                  KA DO
     C                   ENDDO                                                  96 DO
      ***********************
      **  GET WEEKLY DATA  **
      ***********************
     C     RSTRTB        TAG
      *** GET CONTROL RECORD
     C     STRDAT        CHAIN     FFCMCTL                            96
     C   96              DO
     C                   CLEAR                   RCHMCTL
     C                   Z-ADD     STRDAT        CHWKDT
     C                   Z-ADD     BEGWW         CHWK#
     C                   Z-ADD     1             CHNJOB
     C                   Z-ADD     1             CHNRUN
     C                   MOVE      *BLANKS       SIT
     C                   MOVE      *BLANKS       SDS
     C                   Z-ADD     0             SPM
     C                   Z-ADD     0             SOZ
     C                   Z-ADD     0             SML
     C                   Z-ADD     0             SMP
     C                   ENDDO                                                  96 DO
     C  N96              EXSR      BLDSCR
     C                   EXSR      SETSCR
     C                   SETOFF                                       9899
     C     NXTB          TAG
     C   99              SETOFF                                       98
     C                   If        FirstScreen
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C                   Else
     C                   WRITE     SCRNB2140
     C                   READ      SCRNB2140                              90
     C                   EndIf
     C                   SETOFF                                           99
      ** CHK F KEYS
     C   06
     Cor KK              Do
     C                   ExSr      CHKSCR
     C                   If        Err = 0
     C                   Eval      FirstScreen = not FirstScreen
     C                   EndIf
     C                   Goto      NXTB
     C                   EndDo
     C   KF              GOTO      RSTRTB
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
      ** SETOF SCREEN INDICATORS
     C                   EXSR      SETSCR
      ** CHECK SCREEN
     C                   EXSR      CHKSCR
     C   99              GOTO      NXTB
     C  N98              DO
     C                   EXSR      GETALP
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   ENDDO
      ** OUTPUT THE FILE
     C   96              WRITE     RCHMCTL
     C  N96              UPDATE    RCHMCTL
      ***************
      * SCREEN D    *
      ***************
     C                   SETOFF                                       10  98
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C     NXTD          TAG
     C   99              SETOFF                                       98
     C  NKI              GOTO      END
     C                   WRITE     SCRND
     C                   READ      SCRND                                  90
     C                   SETOFF                                           99
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       10
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C                   Z-ADD     0             CNT               5 0
      **
     C     YORN          IFEQ      'N'
     C                   GOTO      END
     C                   END
     C     YORN          IFNE      'Y'
     C                   SETON                                        1099
     C                   GOTO      NXTD
     C                   ENDIF
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        5099
     C                   GOTO      NXTD
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        5199
     C                   GOTO      NXTD
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        5299
     C                   GOTO      NXTD
     C                   ENDIF
      *
     C     LCOPY         IFNE      OCOPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LCOPY         OCOPY             2 0
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        5399
     C                   GOTO      NXTD
     C                   ENDIF
      *
     C     LJOBQ         IFNE      OJOBQ
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LJOBQ         OJOBQ             1
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        5499
     C                   GOTO      NXTD
     C                   ENDIF
      *
     C     VOUT          IFNE      OOUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VOUT          OOUT              1 0
      *
     C     VOUT          IFEQ      1
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*NO '        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      2
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      3
     C                   MOVEL     '*YES'        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C   98              GOTO      NXTD
     C                   ENDIF
      *
     C                   EXSR      BLDLAB
     C                   MOVEL     *BLANKS       LCANCL
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD LABEL FILE  **
      ***********************
     C     BLDLAB        BEGSR
     C     STRDAT        CHAIN     FFCMCTL                            90
     C   90              GOTO      ENDLAB
     C                   MOVEL     '700'         SIZE              3
     C                   Z-ADD     0             P
     C     NXTLAB        TAG
     C                   ADD       1             P
     C     P             IFLE      40
     C     IT(P)         IFGT      *BLANKS
     C     ITMKEY        CHAIN     FMINVT                             90
     C  N90              DO
     C                   ExSr      WRTLAB
     C                   ENDDO                                                  N90  DO
     C                   END                                                    IT,P>' '
     C                   GOTO      NXTLAB
     C                   END                                                    P<=40
     C     ENDLAB        ENDSR
      ***********************
      ** WRITE LABEL FILE  **
      ***********************
     C     WRTLAB        BEGSR
     C                   MOVEL     IMDES1        CLDESC
     C                   MOVEL     IT(P)         CLITEM
CAB  C                   MOVEL     IT(P)         COITEM
     C                   Z-ADD     PM(P)         CLPPM
CAB  C                   Z-ADD     PM(P)         COPPM
CAB  C                   Z-ADD     OZ(P)         COOUNS
CAB  C                   Z-ADD     ML(P)         COPPML
     C                   MOVE      CLPPM         CLPPW             7
     C                   MOVEA     CLPPW         PPI
     C                   Z-ADD     1             L                 2 0
     C                   Z-ADD     1             L1                2 0
     C                   MOVEL     'N'           SIGDGT            1
     C                   MOVE      *BLANKS       PPO
     C     NXTL          TAG
     C                   ADD       1             L
     C                   ADD       1             L1
     C     L             IFLT      8
     C     L             IFEQ      6
     C                   MOVEL     '.'           PPO(L1)
     C                   MOVEL     'Y'           SIGDGT
     C                   ADD       1             L1
     C                   END
     C     PPI(L)        IFLE      '0'
     C     SIGDGT        ANDEQ     'N'
     C                   GOTO      NXTL
     C                   END                                                    PPI,L<0
     C                   MOVEL     PPI(L)        PPO(L1)
     C                   MOVEL     'Y'           SIGDGT
     C                   GOTO      NXTL
     C                   END                                                    L<9
     C                   MOVEA     PPO           CLPPMD
     C                   WRITE     RCHMLAB
CAB  C                   WRITE     RCHMOZS
     C                   EndSr
      ***********************
      ** COPY LAST WEEK    **
      ***********************
     C     CPYWK         BEGSR
     C     STRDAT        SETLL     FFCMCTL
     C                   READP     FFCMCTL                                90
     C  N90              DO
     C                   Z-ADD     STRDAT        CHWKDT
     C                   Z-ADD     BEGWW         CHWK#
     C                   Z-ADD     1             CHNJOB
     C                   Z-ADD     1             CHNRUN
     C                   WRITE     RCHMCTL
     C                   ENDDO                                                  N90  DO
     C                   ENDSR
      ****************************
      ** BUILD SCREEN FROM FILE **
      ****************************
     C     BLDSCR        BEGSR
     C                   Z-ADD     0             P
     C                   MOVE      *BLANKS       SIT
     C                   MOVE      *BLANKS       SDS
     C                   Z-ADD     0             SPM
     C                   Z-ADD     0             SOZ
     C                   Z-ADD     0             SML
     C                   Z-ADD     0             SMP
     C     NXTBLD        TAG
     C                   ADD       1             P
     C     P             IFLE      40
     C     IT(P)         IFGT      *BLANKS
     C     ITMKEY        KLIST
     C                   KFLD                    IT(P)
     C                   KFLD                    SIZE
     C                   MOVEL     '700'         SIZE              3
     C     ITMKEY        CHAIN     FMINVT                             90
     C  N90              MOVEL     IMDES1        SDS(P)
     C                   MOVEL     IT(P)         SIT(P)
     C                   Z-ADD     PM(P)         SPM(P)
     C                   Z-ADD     OZ(P)         SOZ(P)
     C                   Z-ADD     ML(P)         SML(P)
     C                   Z-ADD     MP(P)         SMP(P)
     C     SMP(P)        IFLE      0
     C                   Z-ADD     24            SMP(P)
     C                   END
     C                   END                                                    IT,P>' '
     C                   GOTO      NXTBLD
     C                   END                                                    P>=40
     C                   ENDSR
      ****************************
      ** CHECK SCREEN INPUT     **
      ****************************
     C     CHKSCR        BEGSR
     C                   Z-add     0             Err
     C                   Z-ADD     0             P
     C     NXTCHK        TAG
     C                   ADD       1             P
     C     P             IFLE      40
      ** CHECK IF ANY CHANGE
     C     SIT(P)        IFNE      IT(P)
     C     SPM(P)        ORNE      PM(P)
rpaddC*          SMP,P     ORNE MP,P
      ** IF HERE THERE IS A CHANGE
     C                   SETOFF                                       98
     C                   END                                                    SIT,P=IT,P
     C     SIT(P)        IFGT      *BLANKS
     C                   MOVEL     SIT(P)        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       IMLOOK
     C                   MOVEL     'CHEM'        IMLOOK
     C                   MOVE      *BLANKS       IMWHSE
     C                   MOVEL     '700'         IMSIZE
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
     C     IMITEM        IFGT      *BLANKS
     C                   MOVEL     IMITEM        SIT(P)
     C                   ELSE
     C                   GOTO      NXTCHK
     C                   END
     C                   ENDIF                                                  TST1=?/
     C     MINKEY        KLIST
     C                   KFLD                    SIT(P)
     C                   KFLD                    SIZE
     C                   MOVEL     '700'         SIZE              3
     C     MINKEY        CHAIN     FMINVT                             90
     C  N90              MOVEL     IMDES1        SDS(P)
      ** IF ERROR SET INDICATORS
     C   90              DO
     C                   SETON                                        1099
     C     P             ADD       10            P1                5 0
     C                   MOVEL     '1'           *IN(P1)
     C                   Add       1             Err
     C                   MOVE      *BLANKS       SDS(P)
     C                   ENDDO
     C  N90              MOVEL     SIT(P)        IT(P)
     C                   ELSE                                                   SIT,P>" "
     C                   MOVE      *BLANKS       SDS(P)
     C                   Z-ADD     0             SPM(P)
     C                   Z-ADD     0             SOZ(P)
     C                   Z-ADD     0             SML(P)
     C                   Z-ADD     0             SMP(P)
     C                   MOVEL     SIT(P)        IT(P)
     C                   END                                                    SIT,P> " "
      ** CHECK PPM
     C     SIT(P)        IFGT      *BLANKS
     C     SPM(P)        ANDLE     0
     C                   SETON                                        0999
     C     P             ADD       30            P1
     C                   MOVEL     '1'           *IN(P1)
     C                   Add       1             Err
     C                   Z-ADD     0             SOZ(P)
     C                   Z-ADD     0             SML(P)
RPCHGC*                    Z-ADD0         SMP,P
     C                   GOTO      NXTCHK
     C                   ENDIF
     C                   Z-ADD     SPM(P)        PM(P)
      ** GET PPM FILE
     C     MINKEY        CHAIN     FFCMPPM                            90
     C   90              DO
     C                   Z-ADD     0             SOZ(P)
     C                   Z-ADD     0             SML(P)
RPCHGC*                    Z-ADD0         SMP,P
     C                   GOTO      NXTCHK
     C                   END
      ** CHECK MP
     C     SIT(P)        IFGT      *BLANKS
     C     SMP(P)        ANDLE     0
     C                   SETON                                          99
     C     P             ADD       60            P1
     C                   MOVEL     '1'           *IN(P1)
     C                   Add       1             Err
     C                   Z-ADD     0             SMP(P)
     C                   GOTO      NXTCHK
     C                   ENDIF
      ** GET OZ AND ML FOR PPM
     C                   Z-ADD     0             FROZ              7 3
     C                   Z-ADD     0             FRML              7 3
     C                   MOVE      SPM(P)        TST22             2 2
     C     TST22         IFGT      .00
      ** WE HAVE A FRACTION
     C                   SETON                                        05
     C                   ELSE
     C                   SETOFF                                       05
     C                   END
      ** GET FRACTION BY USING 1PPM IF THERE
     C   05COZ(1)        IFGT      .00
     C     COZ(1)        MULT(H)   TST22         FROZ
     C     CML(1)        MULT(H)   TST22         FRML
     C                   ELSE
     C                   Z-ADD     100           SEARCH            4 0
     C                   Z-ADD     1             X                 5 0
     C     SEARCH        LOOKUP    PPM(X)                                 60
     C   60              DO
     C     PPM(X)        DIV(H)    100           WRKMLT            7 4
     C     WRKMLT        MULT(H)   TST22         FROZ
     C     WRKMLT        MULT(H)   TST22         FRML
     C                   ENDDO                                                   60 DO
     C                   ENDIF                                                   COZ,1>0
      ** NOW GET WHOLE NUMBERS
     C                   MOVEL     SPM(P)        SEARCH
     C                   Z-ADD     1             X                 5 0
     C     SEARCH        LOOKUP    PPM(X)                                 60
     C   60              DO
     C                   Z-ADD     COZ(X)        SOZ(P)
     C                   Z-ADD     CML(X)        SML(P)
     C                   ADD       FROZ          SOZ(P)
     C                   ADD       FRML          SML(P)
     C                   GOTO      NXTCHK
     C                   ENDDO                                                   60 DO
      ** IF HERE NO HIT ON WHOLE NUMBER
     C     SEARCH        IFGT      100
     C     SEARCH        DIV(H)    100           SCWRK             7 2
     C     COZ(19)       MULT(H)   SCWRK         SOZ(P)
     C     CML(19)       MULT(H)   SCWRK         SML(P)
     C                   ADD       FROZ          SOZ(P)
     C                   ADD       FRML          SML(P)
     C                   GOTO      NXTCHK
     C                   ELSE                                                    SEARCH>100
     C     SEARCH        DIV(H)    10            SCWRK             7 2
     C     COZ(10)       MULT(H)   SCWRK         SOZ(P)
     C     CML(10)       MULT(H)   SCWRK         SML(P)
     C                   ADD       FROZ          SOZ(P)
     C                   ADD       FRML          SML(P)
     C                   GOTO      NXTCHK
     C                   END                                                     SEARCH>100
     C                   Z-ADD     FROZ          SOZ(P)
     C                   Z-ADD     FRML          SML(P)
     C                   GOTO      NXTCHK
     C                   END
     C     ENDCHK        TAG
      ** GET FILE ARRAYS IN SYNC
rpchgC*                    Z-ADDSML       ML
rpchgC*                    Z-ADDSMP       MP
rpchgC*                    Z-ADDSOZ       OZ
rpchgC                   Z-ADD     SML           ML
rpchgC                   Z-ADD     SMP           MP
rpchgC                   Z-ADD     SOZ           OZ
     C                   ENDSR
      ************************
      ** SET OFF INDICATORS **
      ************************
     C     SETSCR        BEGSR
     C                   Z-ADD     1             P
     C     P             DOUGT     40
     C                   MOVEL     '0'           *IN(P)
     C                   ADD       1             P
     C                   ENDDO
     C                   Z-ADD     60            P
     C     P             DOUGT     80
     C                   MOVEL     '0'           *IN(P)
     C                   ADD       1             P
     C                   ENDDO
     C                   ENDSR
RPADD ******************************
RPADD ** UPDATE SPRAY MASTER FILE **
RPADD ******************************
RPADDC     UPDSPY        BEGSR
RPADDC                   MOVEL     SIT(W)        ITEM              8
RPADDC                   MOVE      SPM(W)        PTSPM             7 2
RPADDC     SPYKEY        CHAIN     FFCMSPY                            70
RPADDC                   MOVE      SMP(W)        CSXPL
RPADDC     *IN70         IFEQ      *OFF
RPADDC                   UPDATE    RCHMSPY
RPADDC                   ENDIF
RPADDC     *IN70         IFEQ      *ON
RPADDC                   MOVEL     ITEM          CSITEM
RPADDC                   MOVE      SIZE          CSSIZE
RPADDC                   MOVE      PTSPM         CSPPM
RPADDC                   MOVE      CHWKDT        CSWKDT
RPADDC                   MOVE      CHWK#         CSWK#
RPADDC*                    MOVE 'A'       CSSTAT
RPADDC*                    MOVE CHNJOB    CSJOB
RPADDC*                    MOVE CHNRUN    CSRUN
RPADDC                   MOVE      TDATE         CSDTLA
RPADDC                   Z-ADD     0             CSTIME
RPADDC                   MOVE      USERID        CSUSER
RPADDC                   WRITE     RCHMSPY
RPADDC                   ENDIF
RPADDC                   ENDSR
      *********************
      ** SET UP PPM ARRAY *
      *********************
     C     GETPPM        BEGSR
     C                   Z-ADD     0             P                 5 0
     C                   Z-ADD     0             ##PPM             4 0
     C                   Z-ADD     0             PPM
     C     NXTPPM        TAG
     C                   ADD       1             P
     C     P             IFGT      45
     C                   GOTO      ENDPPM
     C                   END
     C     ##PPM         IFLT      10
     C                   ADD       1             ##PPM
     C                   Z-ADD     ##PPM         PPM(P)
     C                   GOTO      NXTPPM
     C                   END
     C     ##PPM         IFLT      50
     C                   ADD       5             ##PPM
     C                   Z-ADD     ##PPM         PPM(P)
     C                   GOTO      NXTPPM
     C                   END
     C     ##PPM         IFLE      950
     C                   ADD       50            ##PPM
     C                   Z-ADD     ##PPM         PPM(P)
     C                   GOTO      NXTPPM
     C                   END
      ** FROM HERE ALWAYS ADD 500
     C                   ADD       500           ##PPM
     C                   Z-ADD     ##PPM         PPM(P)
     C                   GOTO      NXTPPM
     C     ENDPPM        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   EXSR      GETPPM
     C     TDATE         CHAIN     FCALEN                             90
     C     CALKY1        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C                   Z-ADD     1             CL#Y
     C     CALKY1        CHAIN     FCALEX                             92
     C                   Z-ADD     CLDATE        FRMDAT
     C                   MOVEL     CLCENT        BEGYY
     C                   MOVE      CLYEAR        BEGYY
     C                   Z-ADD     CLWEEK        BEGWW
     C     SPYKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C                   KFLD                    PTSPM
     C                   ENDSR
      ***********************
      ** GET ARRAY IN ALPHA *
      ***********************
     C     GETALP        BEGSR
      ** DUMMY READ
     C                   READ      CHMWRK                                 90
     C                   MOVE      *BLANKS       ALPH             15
     C     ALPH          SETLL     FFCMWRKA
     C     NXTDEL        TAG
     C                   READ      FFCMWRKA                               90
     C  N90              DO
     C                   DELETE    RCHMWRK
     C                   GOTO      NXTDEL
     C                   ENDDO
     C                   Z-ADD     0             W                    20
     C     NXTW          TAG
     C                   ADD       1             W
     C     SIT(W)        IFGT      *BLANKS
     C     WRKKEY        KLIST
     C                   KFLD                    SIT(W)
     C                   KFLD                    SIZE
     C                   MOVEL     '700'         SIZE
     C     WRKKEY        CHAIN     FMINVT                             55
     C                   MOVEL     IMITEM        CWITEM
     C                   MOVEL     IMSIZE        CWSIZE
     C                   MOVEL     IMLOOK        CWALPH
     C                   Z-ADD     SPM(W)        CWPPM
     C                   Z-ADD     SMP(W)        CWMP
     C                   Z-ADD     SML(W)        CWML
     C                   Z-ADD     SOZ(W)        CWOZ
     C                   WRITE     RCHMWRK
     C                   END
     C     W             IFLT      40
     C                   GOTO      NXTW
     C                   END
      ** NOW GET ARRAYS BUILT
     C                   MOVE      *BLANKS       SIT
     C                   MOVE      *BLANKS       SDS
     C                   Z-ADD     0             SPM
     C                   Z-ADD     0             SOZ
     C                   Z-ADD     0             SML
rpaddC                   Z-ADD     0             SMP
     C                   Z-ADD     0             W
     C                   MOVE      *BLANKS       CWALPH
     C     CWALPH        SETLL     FFCMWRKA
     C                   Z-ADD     0             P
     C                   MOVE      *BLANKS       SIT
     C                   MOVE      *BLANKS       SDS
     C                   Z-ADD     0             SPM
     C                   Z-ADD     0             SOZ
     C                   Z-ADD     0             SML
     C                   Z-ADD     0             SMP
     C     NXTW1         TAG
     C                   READ      FFCMWRKA                               90
     C   90              GOTO      ENDW1
     C                   ADD       1             W                 2 0
     C     W             IFLE      40
     C     CWITEM        IFGT      *BLANKS
     C     ITMKY1        KLIST
     C                   KFLD                    CWITEM
     C                   KFLD                    SIZE
     C                   MOVEL     '700'         SIZE              3
     C     ITMKY1        CHAIN     FMINVT                             90
     C  N90              MOVEL     IMDES1        SDS(W)
     C                   MOVEL     CWITEM        SIT(W)
     C                   Z-ADD     CWMP          SMP(W)
     C                   Z-ADD     CWPPM         SPM(W)
     C                   Z-ADD     CWOZ          SOZ(W)
     C                   Z-ADD     CWML          SML(W)
RPADDC                   EXSR      UPDSPY
     C                   END                                                    IT,P>' '
     C                   GOTO      NXTW1
     C                   END                                                    P>=40
     C     ENDW1         TAG
     C                   CLEAR                   RCHMWRK
     C                   ENDSR
