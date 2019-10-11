      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2003
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- FCR052
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- BUILD NEW CHMOZS FILE.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFFCMCTL   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFFCMOZS   O  A E           K DISK
      *
      ** CONTROL FILE ARRAYS
     D IT              S             12    DIM(40)                              ITEM NUMBERS
     D SZ              S              3    DIM(40)                              SIZE CODES
     D PM              S              7  2 DIM(40)                              PPM
     D OZ              S              7  3 DIM(40)                              OZ/GAL
     D ML              S              7  3 DIM(40)                              ML/GAL

     D OZG             S              7  3 DIM(45)
     D MLG             S              7  3 DIM(45)
      *
     D SZ700           S                   Like(IMSIZE) Inz('700')
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

    ? ** REDEFINE FFCMCTL
    ?IRCHMCTL
    ? ** GET ITEM NUMBERS
    ?I              CHIT1                       IT(1)
    ?I              CHIT2                       IT(2)
    ?I              CHIT3                       IT(3)
    ?I              CHIT4                       IT(4)
    ?I              CHIT5                       IT(5)
    ?I              CHIT6                       IT(6)
    ?I              CHIT7                       IT(7)
    ?I              CHIT8                       IT(8)
    ?I              CHIT9                       IT(9)
    ?I              CHIT10                      IT(10)
    ?I              CHIT11                      IT(11)
    ?I              CHIT12                      IT(12)
    ?I              CHIT13                      IT(13)
    ?I              CHIT14                      IT(14)
    ?I              CHIT15                      IT(15)
    ?I              CHIT16                      IT(16)
    ?I              CHIT17                      IT(17)
    ?I              CHIT18                      IT(18)
    ?I              CHIT19                      IT(19)
    ?I              CHIT20                      IT(20)
    ?I              CHIT21                      IT(21)
    ?I              CHIT22                      IT(22)
    ?I              CHIT23                      IT(23)
    ?I              CHIT24                      IT(24)
    ?I              CHIT25                      IT(25)
    ?I              CHIT26                      IT(26)
    ?I              CHIT27                      IT(27)
    ?I              CHIT28                      IT(28)
    ?I              CHIT29                      IT(29)
    ?I              CHIT30                      IT(30)
    ?I              CHIT31                      IT(31)
    ?I              CHIT32                      IT(32)
    ?I              CHIT33                      IT(33)
    ?I              CHIT34                      IT(34)
    ?I              CHIT35                      IT(35)
    ?I              CHIT36                      IT(36)
    ?I              CHIT37                      IT(37)
    ?I              CHIT38                      IT(38)
    ?I              CHIT39                      IT(39)
    ?I              CHIT40                      IT(40)
    ? ** GET SIZE CODES
    ?I              CHSZ1                       SZ(1)
    ?I              CHSZ2                       SZ(2)
    ?I              CHSZ3                       SZ(3)
    ?I              CHSZ4                       SZ(4)
    ?I              CHSZ5                       SZ(5)
    ?I              CHSZ6                       SZ(6)
    ?I              CHSZ7                       SZ(7)
    ?I              CHSZ8                       SZ(8)
    ?I              CHSZ9                       SZ(9)
    ?I              CHSZ10                      SZ(10)
    ?I              CHSZ11                      SZ(11)
    ?I              CHSZ12                      SZ(12)
    ?I              CHSZ13                      SZ(13)
    ?I              CHSZ14                      SZ(14)
    ?I              CHSZ15                      SZ(15)
    ?I              CHSZ16                      SZ(16)
    ?I              CHSZ17                      SZ(17)
    ?I              CHSZ18                      SZ(18)
    ?I              CHSZ19                      SZ(19)
    ?I              CHSZ20                      SZ(20)
    ?I              CHSZ21                      SZ(21)
    ?I              CHSZ22                      SZ(22)
    ?I              CHSZ23                      SZ(23)
    ?I              CHSZ24                      SZ(24)
    ?I              CHSZ25                      SZ(25)
    ?I              CHSZ26                      SZ(26)
    ?I              CHSZ27                      SZ(27)
    ?I              CHSZ28                      SZ(28)
    ?I              CHSZ29                      SZ(29)
    ?I              CHSZ30                      SZ(30)
    ?I              CHSZ31                      SZ(31)
    ?I              CHSZ32                      SZ(32)
    ?I              CHSZ33                      SZ(33)
    ?I              CHSZ34                      SZ(34)
    ?I              CHSZ35                      SZ(35)
    ?I              CHSZ36                      SZ(36)
    ?I              CHSZ37                      SZ(37)
    ?I              CHSZ38                      SZ(38)
    ?I              CHSZ39                      SZ(39)
    ?I              CHSZ40                      SZ(40)
    ? ** GET PPM
    ?I              CHPM1                       PM(1)
    ?I              CHPM2                       PM(2)
    ?I              CHPM3                       PM(3)
    ?I              CHPM4                       PM(4)
    ?I              CHPM5                       PM(5)
    ?I              CHPM6                       PM(6)
    ?I              CHPM7                       PM(7)
    ?I              CHPM8                       PM(8)
    ?I              CHPM9                       PM(9)
    ?I              CHPM10                      PM(10)
    ?I              CHPM11                      PM(11)
    ?I              CHPM12                      PM(12)
    ?I              CHPM13                      PM(13)
    ?I              CHPM14                      PM(14)
    ?I              CHPM15                      PM(15)
    ?I              CHPM16                      PM(16)
    ?I              CHPM17                      PM(17)
    ?I              CHPM18                      PM(18)
    ?I              CHPM19                      PM(19)
    ?I              CHPM20                      PM(20)
    ?I              CHPM21                      PM(21)
    ?I              CHPM22                      PM(22)
    ?I              CHPM23                      PM(23)
    ?I              CHPM24                      PM(24)
    ?I              CHPM25                      PM(25)
    ?I              CHPM26                      PM(26)
    ?I              CHPM27                      PM(27)
    ?I              CHPM28                      PM(28)
    ?I              CHPM29                      PM(29)
    ?I              CHPM30                      PM(30)
    ?I              CHPM31                      PM(31)
    ?I              CHPM32                      PM(32)
    ?I              CHPM33                      PM(33)
    ?I              CHPM34                      PM(34)
    ?I              CHPM35                      PM(35)
    ?I              CHPM36                      PM(36)
    ?I              CHPM37                      PM(37)
    ?I              CHPM38                      PM(38)
    ?I              CHPM39                      PM(39)
    ?I              CHPM40                      PM(40)
    ? ** GET OUNCES
    ?I              CHOZ1                       OZ(1)
    ?I              CHOZ2                       OZ(2)
    ?I              CHOZ3                       OZ(3)
    ?I              CHOZ4                       OZ(4)
    ?I              CHOZ5                       OZ(5)
    ?I              CHOZ6                       OZ(6)
    ?I              CHOZ7                       OZ(7)
    ?I              CHOZ8                       OZ(8)
    ?I              CHOZ9                       OZ(9)
    ?I              CHOZ10                      OZ(10)
    ?I              CHOZ11                      OZ(11)
    ?I              CHOZ12                      OZ(12)
    ?I              CHOZ13                      OZ(13)
    ?I              CHOZ14                      OZ(14)
    ?I              CHOZ15                      OZ(15)
    ?I              CHOZ16                      OZ(16)
    ?I              CHOZ17                      OZ(17)
    ?I              CHOZ18                      OZ(18)
    ?I              CHOZ19                      OZ(19)
    ?I              CHOZ20                      OZ(20)
    ?I              CHOZ21                      OZ(21)
    ?I              CHOZ22                      OZ(22)
    ?I              CHOZ23                      OZ(23)
    ?I              CHOZ24                      OZ(24)
    ?I              CHOZ25                      OZ(25)
    ?I              CHOZ26                      OZ(26)
    ?I              CHOZ27                      OZ(27)
    ?I              CHOZ28                      OZ(28)
    ?I              CHOZ29                      OZ(29)
    ?I              CHOZ30                      OZ(30)
    ?I              CHOZ31                      OZ(31)
    ?I              CHOZ32                      OZ(32)
    ?I              CHOZ33                      OZ(33)
    ?I              CHOZ34                      OZ(34)
    ?I              CHOZ35                      OZ(35)
    ?I              CHOZ36                      OZ(36)
    ?I              CHOZ37                      OZ(37)
    ?I              CHOZ38                      OZ(38)
    ?I              CHOZ39                      OZ(39)
    ?I              CHOZ40                      OZ(40)
    ? ** GET ML
    ?I              CHML1                       ML(1)
    ?I              CHML2                       ML(2)
    ?I              CHML3                       ML(3)
    ?I              CHML4                       ML(4)
    ?I              CHML5                       ML(5)
    ?I              CHML6                       ML(6)
    ?I              CHML7                       ML(7)
    ?I              CHML8                       ML(8)
    ?I              CHML9                       ML(9)
    ?I              CHML10                      ML(10)
    ?I              CHML11                      ML(11)
    ?I              CHML12                      ML(12)
    ?I              CHML13                      ML(13)
    ?I              CHML14                      ML(14)
    ?I              CHML15                      ML(15)
    ?I              CHML16                      ML(16)
    ?I              CHML17                      ML(17)
    ?I              CHML18                      ML(18)
    ?I              CHML19                      ML(19)
    ?I              CHML20                      ML(20)
    ?I              CHML21                      ML(21)
    ?I              CHML22                      ML(22)
    ?I              CHML23                      ML(23)
    ?I              CHML24                      ML(24)
    ?I              CHML25                      ML(25)
    ?I              CHML26                      ML(26)
    ?I              CHML27                      ML(27)
    ?I              CHML28                      ML(28)
    ?I              CHML29                      ML(29)
    ?I              CHML30                      ML(30)
    ?I              CHML31                      ML(31)
    ?I              CHML32                      ML(32)
    ?I              CHML33                      ML(33)
    ?I              CHML34                      ML(34)
    ?I              CHML35                      ML(35)
    ?I              CHML36                      ML(36)
    ?I              CHML37                      ML(37)
    ?I              CHML38                      ML(38)
    ?I              CHML39                      ML(39)
    ?I              CHML40                      ML(40)
      ***********************
      ** START OR RESTART  **
      ***********************
    ?C     STRDAT        CHAIN     FFCMCTL                            90
     C   90              SETON                                        LR
     C   90              RETURN

      ** GET DATA ******
     C                   Z-ADD     1             X                 5 0
    ?C     NXTX          TAG
     C                   DoW       X <= 40 and IT(X) <> *Blanks
    ?C     ItemKey       Chain     FMINVT
    ?C     ItemKey       KList
    ?C                   KFld                    IT(X)
    ?C                   KFld                    SZ700

     C                   If        IMDES2 = *Blanks
    ?C                   ExSr      Write1Chem
     C                   Else
    ?C                   ExSr      Write2Chem
     C                   EndIf

     C                   Eval      X = X + 1
     C                   EndDo

     C                   Eval      *InLR = *On
     C                   Return

    ?C     FCR900        PList
    ?C                   Parm                    COITEM           12
    ?C                   Parm      '700'         CO700             3
    ?C                   Parm                    PPPM              7 2
    ?C                   Parm      *Zero         PGAL              6 2
    ?C                   Parm                    POZ               9 3
    ?C                   Parm                    POZG              7 3
    ?C                   Parm                    PML               9 3
    ?C                   Parm                    PMLG              7 3

    ?C     Write1Chem    BegSr
     C                   MOVEL     IT(X)         COITEM
     C                   Z-ADD     PM(X)         COPPM
     C                   Z-ADD     OZ(X)         COOUNS
     C                   Z-ADD     ML(X)         COPPML
    ?C                   WRITE     RCHMOZS
    ?C                   EndSr

    ?C     Write2Chem    BegSr
     C                   Eval      COITEM   = %subst(IMDES2:27:04)
     C                   Eval      COPPM    = %dec(%subst(IMDES2:19:07):6:2)
     C                   Eval      PPPM     = COPPM
    ?C                   Call      'FCR900'      FCR900
     C                   Eval      COOUNS   = POZG
     C                   Eval      COPPML   = PMLG
    ?C                   WRITE     RCHMOZS

     C                   Eval      COITEM   = %subst(IMDES3:27:04)
     C                   Eval      COPPM    = %dec(%subst(IMDES3:19:07):6:2)
     C                   Eval      PPPM     = COPPM
    ?C                   Call      'FCR900'      FCR900
     C                   Eval      COOUNS   = POZG
     C                   Eval      COPPML   = PMLG
    ?C                   WRITE     RCHMOZS
    ?C                   EndSr
