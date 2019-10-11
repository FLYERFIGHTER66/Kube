    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- SCR200
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SCANNER INPUT FOR GREENHOUSE CART ENTRY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSCR201FM  CF   E             WORKSTN
     FFCALEN    IF   E           K DISK
     FFTRAY     IF   E           K DISK
     FFPLGSCTL  IF   E           K DISK
     FFCARTST   UF A E           K DISK
      *
      *SCREEN ARRAY
     D TAG             S              8  0 DIM(140)                             TAGS
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  CRMDY                  1      6  0                                      ARC380
     D  CRCYMD                 7     13  0                                      ARC380
     D  CRYEAR                14     17  0                                      ARC380
     D  CRWEEK                18     19  0                                      ARC380
     D  NXMDY                 20     25  0                                      ARC380
     D  NXCYMD                26     32  0                                      ARC380
     D  NXYEAR                33     36  0                                      ARC380
     D  NXWEEK                37     38  0                                      ARC380
     D  LCANCL               133    133                                         ARC380
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate

     D  Rotation       S               N   Inz(*Off)

      *RENAME SCREEN FIELDS
     ISCRNB
     I              TAG001                      TAG(01)
     I              TAG002                      TAG(02)
     I              TAG003                      TAG(03)
     I              TAG004                      TAG(04)
     I              TAG005                      TAG(05)
     I              TAG006                      TAG(06)
     I              TAG007                      TAG(07)
     I              TAG008                      TAG(08)
     I              TAG009                      TAG(09)
     I              TAG010                      TAG(10)
     I              TAG011                      TAG(11)
     I              TAG012                      TAG(12)
     I              TAG013                      TAG(13)
     I              TAG014                      TAG(14)
     I              TAG015                      TAG(15)
     I              TAG016                      TAG(16)
     I              TAG017                      TAG(17)
     I              TAG018                      TAG(18)
     I              TAG019                      TAG(19)
     I              TAG020                      TAG(20)
     I              TAG021                      TAG(21)
     I              TAG022                      TAG(22)
     I              TAG023                      TAG(23)
     I              TAG024                      TAG(24)
     I              TAG025                      TAG(25)
     I              TAG026                      TAG(26)
     I              TAG027                      TAG(27)
     I              TAG028                      TAG(28)
     I              TAG029                      TAG(29)
     I              TAG030                      TAG(30)
     I              TAG031                      TAG(31)
     I              TAG032                      TAG(32)
     I              TAG033                      TAG(33)
     I              TAG034                      TAG(34)
     I              TAG035                      TAG(35)
     I              TAG036                      TAG(36)
     I              TAG037                      TAG(37)
     I              TAG038                      TAG(38)
     I              TAG039                      TAG(39)
     I              TAG040                      TAG(40)
     I              TAG041                      TAG(41)
     I              TAG042                      TAG(42)
     I              TAG043                      TAG(43)
     I              TAG044                      TAG(44)
     I              TAG045                      TAG(45)
     I              TAG046                      TAG(46)
     I              TAG047                      TAG(47)
     I              TAG048                      TAG(48)
     I              TAG049                      TAG(49)
     I              TAG050                      TAG(50)
     I              TAG051                      TAG(51)
     I              TAG052                      TAG(52)
     I              TAG053                      TAG(53)
     I              TAG054                      TAG(54)
     I              TAG055                      TAG(55)
     I              TAG056                      TAG(56)
     I              TAG057                      TAG(57)
     I              TAG058                      TAG(58)
     I              TAG059                      TAG(59)
     I              TAG060                      TAG(60)
     I              TAG061                      TAG(61)
     I              TAG062                      TAG(62)
     I              TAG063                      TAG(63)
     I              TAG064                      TAG(64)
     I              TAG065                      TAG(65)
     I              TAG066                      TAG(66)
     I              TAG067                      TAG(67)
     I              TAG068                      TAG(68)
     I              TAG069                      TAG(69)
     I              TAG070                      TAG(70)
     I              TAG071                      TAG(71)
     I              TAG072                      TAG(72)
     I              TAG073                      TAG(73)
     I              TAG074                      TAG(74)
     I              TAG075                      TAG(75)
     I              TAG076                      TAG(76)
     I              TAG077                      TAG(77)
     I              TAG078                      TAG(78)
     I              TAG079                      TAG(79)
     I              TAG080                      TAG(80)
     I              TAG081                      TAG(81)
     I              TAG082                      TAG(82)
     I              TAG083                      TAG(83)
     I              TAG084                      TAG(84)
     I              TAG085                      TAG(85)
     I              TAG086                      TAG(86)
     I              TAG087                      TAG(87)
     I              TAG088                      TAG(88)
     I              TAG089                      TAG(89)
     I              TAG090                      TAG(90)
     I              TAG091                      TAG(91)
     I              TAG092                      TAG(92)
     I              TAG093                      TAG(93)
     I              TAG094                      TAG(94)
     I              TAG095                      TAG(95)
     I              TAG096                      TAG(96)
     I              TAG097                      TAG(97)
     I              TAG098                      TAG(98)
     I              TAG099                      TAG(99)
     I              TAG100                      TAG(100)
     I              TAG101                      TAG(101)
     I              TAG102                      TAG(102)
     I              TAG103                      TAG(103)
     I              TAG104                      TAG(104)
     I              TAG105                      TAG(105)
     I              TAG106                      TAG(106)
     I              TAG107                      TAG(107)
     I              TAG108                      TAG(108)
     I              TAG109                      TAG(109)
     I              TAG110                      TAG(110)
     I              TAG111                      TAG(111)
     I              TAG112                      TAG(112)
     I              TAG113                      TAG(113)
     I              TAG114                      TAG(114)
     I              TAG115                      TAG(115)
     I              TAG116                      TAG(116)
     I              TAG117                      TAG(117)
     I              TAG118                      TAG(118)
     I              TAG119                      TAG(119)
     I              TAG120                      TAG(120)
     I              TAG121                      TAG(121)
     I              TAG122                      TAG(122)
     I              TAG123                      TAG(123)
     I              TAG124                      TAG(124)
     I              TAG125                      TAG(125)
     I              TAG126                      TAG(126)
     I              TAG127                      TAG(127)
     I              TAG128                      TAG(128)
     I              TAG129                      TAG(129)
     I              TAG130                      TAG(130)
     I              TAG131                      TAG(131)
     I              TAG132                      TAG(132)
     I              TAG133                      TAG(133)
     I              TAG134                      TAG(134)
     I              TAG135                      TAG(135)
     I              TAG136                      TAG(136)
     I              TAG137                      TAG(137)
     I              TAG138                      TAG(138)
     I              TAG139                      TAG(139)
     I              TAG140                      TAG(140)
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
      ** IF WEDNESDAY OR LATER USE NEXT WEEK ELSE USE THIS WEEK
     C*    TODAY         IFGE      3
     C*                  Z-ADD     NXMDY         SHPDAT
     C*                  ELSE
     C*                  Z-ADD     CRMDY         SHPDAT
     C*                  END
      ** WRITE SCRNA
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG  DO
      ** CHECK INPUT
     C                   SETOFF                                       101112
     C                   SETOFF                                       202122
     C                   SETOFF                                       2324
     C     SHPDAT        IFLE      0
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   END
     C     SHPDAT        CHAIN     FCALEN                             10
     C   10              DO
     C                   SETON                                        11
     C                   GOTO      NXTA
     C                   ENDDO                                                  10  DO
     C     CL#Y          IFNE      1
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     CLCYMD        SHPCYM            7 0
     C                   SETOFF                                       5556
     C                   Z-ADD     0             CARTNO
      ** WRITE SCRNA1
     C     RSTRT1        TAG
     C                   Z-ADD     0             CLR
     C                   Z-ADD     CARTNO        LSTCRT
     C                   Z-ADD     0             CARTNO
     C**                   Z-ADD0         QTY
     C     NXTA1         TAG
     C                   WRITE     SCRNA1
     C                   READ      SCRNA1                                 90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG  DO
     C                   SETOFF                                       202122
     C                   SETOFF                                       232430
      ** NOW CHECK CART NUMBER
     C     CARTNO        IFLE      0
     C                   SETON                                        2021
     C                   GOTO      NXTA1
     C                   END
      ** SKIP CLEAR QUESTION
     C                   GOTO      NOCLR
     C     NXTA2         TAG
     C                   WRITE     SCRNA2
     C                   READ      SCRNA2                                 90
      ** CHECK F KEYS
     C   KF              GOTO      RSTRT1
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C     CLR           IFLT      0
     C     CLR           ORGT      1
     C                   SETON                                        30
     C                   GOTO      NXTA2
     C                   END
     C     CLR           IFEQ      1
     C**                   EXSR CLRORD
     C                   END
     C     NOCLR         TAG
     C                   Z-ADD     0             TAG
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C                   SETOFF                                       203031
     C                   Z-ADD     0             X                 3 0
     C     NXTX          TAG
     C                   ADD       1             X
     C     X             IFGT      140
     C                   GOTO      ENDX
     C                   END
     C     TAG(X)        IFGT      0
     C                   Z-ADD     TAG(X)        TAG#
     C                   ELSE
     C                   GOTO      NXTX
     C                   END
      ** CHECK FOR VALID BAR CODE
     C     TAG#          CHAIN     FTRAY                              22
     C   22              GOTO      NXTX
      ** SEE IF ALREADY READ
     C     TAG#          CHAIN     FCARTST                            92
      ** IF THERE UPDATE
     C  N92              DO
     C                   Z-ADD     CARTNO        CTCART
     C                   Z-ADD     SMASTER       CTMAST
     C                   Z-ADD     SHPCYM        CTSHDT
     C                   UPDATE    RCARTS
     C                   GOTO      NXTX
     C                   END
      ** IF NOT THERE ADD
     C   92              DO
     C                   CLEAR                   RCARTS
     C     TAG#          CHAIN     FTRAY                              93
     C                   Z-ADD     CARTNO        CTCART
WJB  C*                  MOVEL     'A'           CTSTAT
WJB  C                   MOVEL     TRSTAT        CTSTAT
     C                   Z-ADD     TAG#          CTTAG#
     C                   MOVEL     TRITEM        CTITEM
     C                   MOVEL     TRSIZE        CTSIZE
     C                   Z-ADD     TRCRDT        CTSHDT
     C                   Z-ADD     SMASTER       CTMAST
WJB  C                   If        TRSTAT = 'P'
WJB  C                   Eval      CTITEM = %subst(CTITEM:1:11)+'P'
WJB  C                   EndIf
     C                   WRITE     RCARTS
     C**                   ADD  1         QTY
     C                   GOTO      NXTX
     C                   ENDDO
     C     ENDX          TAG
      ** CHECK F KEYS
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG  DO
      ** SEE IF PRINT
     C   KA              DO
     C                   Z-ADD     0             CONTRL            6 0
     C                   CALL      'SCR230CL'
     C                   PARM                    CARTNO
     C                   PARM                    SHPCYM
     C                   PARM                    SMASTER
     C                   PARM                    CONTRL
     C                   PARM                    MODE
     C                   GOTO      RSTRT1
     C                   END
     C                   GOTO      NXTB
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C     *Entry        PList
     C                   Parm                    Mode              1
     C                   If        Mode = 'R'
     C                   Eval      Rotation = *On
     C                   Else
     C                   Eval      Rotation = *Off
     C                   EndIf
     C                   Eval      *in60 = Rotation
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     TDATE         CHAIN     FCALEN                             90
     C                   Z-ADD     CL#Y          TODAY             1 0
     C                   MOVE      *BLANKS       LCANCL
      /Free

         Chain (0) FPLGSCTL;
         If %Found(FPLGSCTL);
           SHPDAT = $MDYDate($Date(PSFILD));
           SMASTER = PSFILM;
         ENDIF;

      /End-Free
     C                   ENDSR
