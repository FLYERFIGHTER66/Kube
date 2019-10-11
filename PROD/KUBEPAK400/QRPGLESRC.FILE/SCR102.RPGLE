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
      **PROGRAM NAME-------- SCR100
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SCANNER INPUT FOR ORDER VERIFICATION
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/14/02 EFD USE 75 TAG NUMBERS FROM SCREEN B
      *  3/28/02 EFD USE 168 TAG NUMBERS FROM SCREEN B
      *
     FSCR102FM  CF   E             WORKSTN
     FFCALEN    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFTRAY     IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFPUTORDO  UF   E           K DISK                                         SHPD MAST ORD# ITEM+
     F                                     RENAME(RPUTORD:PUTORD)               SIZE
     FFPUTORD   UF   E           K DISK                                         ORD# SEQ# SHPD MAST
     FFTROREO   UF A E           K DISK                                         SHDT ORD# TAG#
     FFTRORD    UF A E           K DISK                                         TAG#
     FFTRORDI   UF   E           K DISK                                         SHDT ORD# ITEM SIZE
     F                                     RENAME(RTRORD:TRORDI)
     FFTRORDOT  UF   E           K DISK                                         SHDT ORD# TAG#
     F                                     RENAME(RTRORD:RTRORDOT)
     FFWKORD    UF A E           K DISK                                         ORD# SHDT MAST
     FFPLGSCTL  IF   E           K DISK
      *
      *SCREEN ARRAY
     D TG              S              8  0 DIM(168)                             TAGS
      *
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

     D  SimpleMode     S               N                                        ARC380

      *? Function Prototypes
    ?D/COPY QFunctDefn,$_Dates
      *
      *RENAME SCREEN FIELDS
     ISCRNB
     I              TAG01                       TG(1)
     I              TAG02                       TG(2)
     I              TAG03                       TG(3)
     I              TAG04                       TG(4)
     I              TAG05                       TG(5)
     I              TAG06                       TG(6)
     I              TAG07                       TG(7)
     I              TAG08                       TG(8)
     I              TAG09                       TG(9)
     I              TAG10                       TG(10)
     I              TAG11                       TG(11)
     I              TAG12                       TG(12)
     I              TAG13                       TG(13)
     I              TAG14                       TG(14)
     I              TAG15                       TG(15)
     I              TAG16                       TG(16)
     I              TAG17                       TG(17)
     I              TAG18                       TG(18)
     I              TAG19                       TG(19)
     I              TAG20                       TG(20)
     I              TAG21                       TG(21)
     I              TAG22                       TG(22)
     I              TAG23                       TG(23)
     I              TAG24                       TG(24)
     I              TAG25                       TG(25)
     I              TAG26                       TG(26)
     I              TAG27                       TG(27)
     I              TAG28                       TG(28)
     I              TAG29                       TG(29)
     I              TAG30                       TG(30)
     I              TAG31                       TG(31)
     I              TAG32                       TG(32)
     I              TAG33                       TG(33)
     I              TAG34                       TG(34)
     I              TAG35                       TG(35)
     I              TAG36                       TG(36)
     I              TAG37                       TG(37)
     I              TAG38                       TG(38)
     I              TAG39                       TG(39)
     I              TAG40                       TG(40)
     I              TAG41                       TG(41)
     I              TAG42                       TG(42)
     I              TAG43                       TG(43)
     I              TAG44                       TG(44)
     I              TAG45                       TG(45)
     I              TAG46                       TG(46)
     I              TAG47                       TG(46)
     I              TAG48                       TG(48)
     I              TAG49                       TG(49)
     I              TAG50                       TG(50)
     I              TAG51                       TG(51)
     I              TAG52                       TG(52)
     I              TAG53                       TG(53)
     I              TAG54                       TG(54)
     I              TAG55                       TG(55)
     I              TAG56                       TG(56)
     I              TAG57                       TG(57)
     I              TAG58                       TG(58)
     I              TAG59                       TG(59)
     I              TAG60                       TG(60)
     I              TAG61                       TG(61)
     I              TAG62                       TG(62)
     I              TAG63                       TG(63)
     I              TAG64                       TG(64)
     I              TAG65                       TG(65)
     I              TAG66                       TG(66)
     I              TAG67                       TG(67)
     I              TAG68                       TG(68)
     I              TAG69                       TG(69)
     I              TAG70                       TG(70)
     I              TAG71                       TG(71)
     I              TAG72                       TG(72)
     I              TAG73                       TG(73)
     I              TAG74                       TG(74)
     I              TAG75                       TG(75)
     I              TAG76                       TG(76)
     I              TAG77                       TG(77)
     I              TAG78                       TG(78)
     I              TAG79                       TG(79)
     I              TAG80                       TG(80)
     I              TAG81                       TG(81)
     I              TAG82                       TG(82)
     I              TAG83                       TG(83)
     I              TAG84                       TG(84)
     I              TAG85                       TG(85)
     I              TAG86                       TG(86)
     I              TAG87                       TG(87)
     I              TAG88                       TG(88)
     I              TAG89                       TG(89)
     I              TAG90                       TG(90)
     I              TAG91                       TG(91)
     I              TAG92                       TG(92)
     I              TAG93                       TG(93)
     I              TAG94                       TG(94)
     I              TAG95                       TG(95)
     I              TAG96                       TG(96)
     I              TAG97                       TG(97)
     I              TAG98                       TG(98)
     I              TAG99                       TG(99)
     I              TAG100                      TG(100)
     I              TAG101                      TG(101)
     I              TAG102                      TG(102)
     I              TAG103                      TG(103)
     I              TAG104                      TG(104)
     I              TAG105                      TG(105)
     I              TAG106                      TG(106)
     I              TAG107                      TG(107)
     I              TAG108                      TG(108)
     I              TAG109                      TG(109)
     I              TAG110                      TG(110)
     I              TAG111                      TG(111)
     I              TAG112                      TG(112)
     I              TAG113                      TG(113)
     I              TAG114                      TG(114)
     I              TAG115                      TG(115)
     I              TAG116                      TG(116)
     I              TAG117                      TG(117)
     I              TAG118                      TG(118)
     I              TAG119                      TG(119)
     I              TAG120                      TG(120)
     I              TAG121                      TG(121)
     I              TAG122                      TG(122)
     I              TAG123                      TG(123)
     I              TAG124                      TG(124)
     I              TAG125                      TG(125)
     I              TAG126                      TG(126)
     I              TAG127                      TG(127)
     I              TAG128                      TG(128)
     I              TAG129                      TG(129)
     I              TAG130                      TG(130)
     I              TAG131                      TG(131)
     I              TAG132                      TG(132)
     I              TAG133                      TG(133)
     I              TAG134                      TG(134)
     I              TAG135                      TG(135)
     I              TAG136                      TG(136)
     I              TAG137                      TG(137)
     I              TAG138                      TG(138)
     I              TAG139                      TG(139)
     I              TAG140                      TG(140)
     I              TAG141                      TG(141)
     I              TAG142                      TG(142)
     I              TAG143                      TG(143)
     I              TAG144                      TG(144)
     I              TAG145                      TG(145)
     I              TAG146                      TG(146)
     I              TAG147                      TG(147)
     I              TAG148                      TG(148)
     I              TAG149                      TG(149)
     I              TAG150                      TG(150)
     I              TAG151                      TG(151)
     I              TAG152                      TG(152)
     I              TAG153                      TG(153)
     I              TAG154                      TG(154)
     I              TAG155                      TG(155)
     I              TAG156                      TG(156)
     I              TAG157                      TG(157)
     I              TAG158                      TG(158)
     I              TAG159                      TG(159)
     I              TAG160                      TG(160)
     I              TAG161                      TG(161)
     I              TAG162                      TG(162)
     I              TAG163                      TG(163)
     I              TAG164                      TG(164)
     I              TAG165                      TG(165)
     I              TAG166                      TG(166)
     I              TAG167                      TG(167)
     I              TAG168                      TG(168)
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   UNLOCK    FPUTORD
     C                   UNLOCK    FPUTORDO
     C                   UNLOCK    FTROREO
     C                   UNLOCK    FTRORD
     C                   UNLOCK    FTRORDI
     C                   UNLOCK    FWKORD

     C                   If        USERID >= 'SCANORD' and
     C                             USERID <= 'SCANORD999'
     C                   Eval      SimpleMode = *Off
     C                   Else
     C                   Eval      SimpleMode = *On
     C                   ENDIF

      ** IF THURSDAY OR LATER USE NEXT WEEK ELSE USE THIS WEEK
     C*    TODAY         IFGE      4
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
     C                   If        not SimpleMode
     C                   EXFMT     SCRNH                                         How many screen
     C                   Else
     C                   Eval      HowMany = 4
     C                   EndIf
     C                   MOVEA     '0000'        *In(41)
     C                   Eval      *In(40 + HowMany) = '1'
      ** WRITE SCRNA1
     C     RSTRT1        TAG
     C                   UNLOCK    FPUTORD
     C                   UNLOCK    FPUTORDO
     C                   UNLOCK    FTROREO
     C                   UNLOCK    FTRORD
     C                   UNLOCK    FTRORDI
     C                   UNLOCK    FWKORD
     C*                  Z-ADD     0             CLR
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
      ** NOW CHECK ORDER NUMBER
     C     ORDNO         IFLE      0
     C                   SETON                                        2021
     C                   GOTO      NXTA1
     C                   END
     C     ORDNO         CHAIN(N)  FPUTORD                            20
     C   20              DO
     C                   SETON                                        21
     C                   GOTO      NXTA1
     C                   END
     C     PDSHPD        IFNE      SHPCYM
     C                   SETON                                        2021
     C                   GOTO      NXTA1
     C                   END
     C     ORDNO         CHAIN     FHORDR                             90
      ** IF HERE SCREEN A OK BUILD FWKORD
     C     WRKKEY        KLIST
     C                   KFLD                    ORDNO
     C                   KFLD                    SHPCYM
     C                   MOVE      *BLANKS       OSTAT             1
     C     WRKKEY        CHAIN     FWKORD                             91
     C  N91OWSTAT        IFEQ      'S'
     C                   SETON                                        2023
     C                   GOTO      NXTA1
     C                   END
     C  N91              DO
     C                   MOVEL     OWSTAT        OSTAT
     C                   MOVEL     'P'           OWSTAT
     C                   MOVEL     USERID        OWUSER
     C                   TIME                    OWTIME
     C                   Z-ADD     TDATE         OWDTLA
     C                   UPDATE    RWKORD
     C                   ENDDO
     C   91              DO
     C                   MOVEL     'P'           OWSTAT
     C                   Z-ADD     ORDNO         OWORD#
     C                   Z-ADD     SHPCYM        OWSHDT
     C                   MOVEL     USERID        OWUSER
     C                   TIME                    OWTIME
     C                   Z-ADD     TDATE         OWDTLA
     C                   WRITE     RWKORD
     C                   ENDDO
     C* N91      OWSTAT    IFEQ 'A'
     C*                    SETON                     2024
     C*                    GOTO NXTA1
     C*                    END
      ** WRITE SCRNA2
     C     OSTAT         IFLE      *BLANKS
     C                   GOTO      NXTB
     C                   END
     C*                  Z-ADD     0             CLR
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
     C*    CLR           IFLT      0
     C*    CLR           ORGT      1
     C*                  SETON                                        30
     C*                  GOTO      NXTA2
     C*                  END
     C     CLR           IFEQ      2
     C                   EXSR      CLRORD
     C                   END
     C     CLR           IFEQ      3
     C                   ExFmt     SCRNJ
     C                   EXSR      CLRTAG
     C                   GOTO      RSTRT1
     C                   END
     C     NXTB          TAG
     C                   Z-ADD     0             TG
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C                   SETOFF                                       203031
     C                   Z-ADD     0             X                 5 0
     C     NXTX          TAG
     C                   ADD       1             X
     C     X             IFGT      168
     C                   GOTO      ENDX
     C                   END
     C     TG(X)         IFGT      0
     C                   Z-ADD     TG(X)         TAG#              8 0
     C                   ELSE
     C                   GOTO      NXTX
     C                   END
      ** CHECK FOR VALID BAR CODE
     C     TAG#          CHAIN     FTRAY                              22
     C   22              GOTO      NXTX
      ** SEE IF ALREADY READ
     C     TAG#          CHAIN(N)  FTRORD                             92
     C     TAGITM        CHAIN     FMINVT
     C     TAGITM        KLIST
     C                   KFLD                    TRITEM
     C                   KFLD                    TRSIZE
      ** IF ON SAME ORDER NO CHECK NEEDED
     C  N92TOORD#        IFEQ      ORDNO
     C                   Z-ADD     TAG#          LSTBAR            8 0
     C                   Z-ADD     0             TAG#
     C                   GOTO      NXTX
     C                   END
      ** IF ON ANOTHER ORDER
     C  N92TOORD#        IFNE      ORDNO
     C     TOORD#        ANDGT     0
     C                   EXFMT     SCRNG
     C                   If        KeepDup = 1
     C                   MOVEL     'A'           TESTAT
     C                   Z-ADD     TAG#          TETAG#
     C                   MOVEL     'DUP'         TEERR
     C                   Z-ADD     ORDNO         TEORD#
     C                   Z-ADD     SHPCYM        TESHDT
     C                   Z-ADD     TDATE         TEDTLA
     C                   Z-ADD     TIMOD         TETIME
     C                   MOVEL     USERID        TEUSER
     C                   WRITE     RTRORE
     C                   Endif
     C                   GOTO      NXTX
     C                   END
      ** SEE IF ITEM NEEDED ON THIS ORDER
      **CHANGED
     C                   EXSR      GETORD
      ** IF HERE UPDATE RECORDS GOOD TAG
     C                   If        KeepBad <> 2
     C     TAG#          CHAIN     FTRORD                             92
     C                   MOVEL     'A'           TOSTAT
     C                   Z-ADD     TAG#          TOTAG#
     C                   Z-ADD     ORDNO         TOORD#
     C                   Z-ADD     0             TOSEQ#
     C     ##ERR         IFNE      'Y'
     C                   Z-ADD     PDSEQ#        TOSEQ#
     C                   END
     C                   Z-ADD     1             TOPART
     C                   MOVEL     TRITEM        TOITEM
     C                   MOVEL     TRSIZE        TOSIZE
     C                   Z-ADD     SHPCYM        TOSHDT
     C                   Z-ADD     TDATE         TODTLA
     C                   TIME                    TOTIME
     C                   MOVEL     USERID        TOUSER
     C   92              WRITE     RTRORD
     C  N92              UPDATE    RTRORD
     C                   Z-ADD     TAG#          LSTBAR
     C                   Z-ADD     0             TAG#
     C                   EndIf
     C                   GOTO      NXTX
     C     ENDX          TAG
      ** CHECK F KEYS
     C   KF              DO
     C     WRKKEY        CHAIN     FWKORD                             91
     C   91              DO
     C                   Z-ADD     SHPCYM        OWSHDT
     C                   Z-ADD     ORDNO         OWORD#
     C                   ENDDO
     C                   MOVEL     'P'           OWSTAT
     C                   Z-ADD     TDATE         OWDTLA
     C                   Z-ADD     TIMOD         OWTIME
     C                   MOVEL     USERID        OWUSER
     C  N91              UPDATE    RWKORD
     C   91              WRITE     RWKORD
     C                   GOTO      RSTRT1
     C                   ENDDO
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG  DO
     C   KA              DO
     C                   Z-ADD     ORDNO         LSTORD
     C                   SETOFF                                       5556
     C                   EXSR      CHKORD
     C   99              DO
     C     WRKKEY        CHAIN     FWKORD                             91
     C   91              DO
     C                   Z-ADD     SHPCYM        OWSHDT
     C                   Z-ADD     ORDNO         OWORD#
     C                   ENDDO
     C                   MOVEL     'E'           OWSTAT
     C                   Z-ADD     TDATE         OWDTLA
     C                   Z-ADD     TIMOD         OWTIME
     C                   MOVEL     USERID        OWUSER
     C  N91              UPDATE    RWKORD
     C   91              WRITE     RWKORD
     C                   If        not SimpleMode
     C                   EXFMT     SCRNF
     C                   Else
     C                   Eval      ERRORT = 10
     C                   EndIf
     C                   SUB       1             ERRORT
     C                   MOVE      ERRORT        AREA1             1
     C                   MOVE      AREA1         AREA              6
     C                   If        ErrorT <> 11
     C                   CALL      'SCR301CL'
     C                   PARM                    ORDNO
     C                   PARM                    SHPCYM
     C                   PARM                    SMASTER
     C                   PARM                    AREA
     C*                                   AREA 9 = ALL AREAS
     C                   EndIf
     C                   SETON                                        56
     C                   Z-ADD     0             ORDNO
     C                   GOTO      RSTRT1
     C                   ENDDO                                                  99 DO
     C     WRKKEY        CHAIN     FWKORD                             91
     C   91              DO
     C                   Z-ADD     SHPCYM        OWSHDT
     C                   Z-ADD     ORDNO         OWORD#
     C                   ENDDO
     C                   MOVEL     'A'           OWSTAT
     C                   Z-ADD     TDATE         OWDTLA
     C                   Z-ADD     TIMOD         OWTIME
     C                   MOVEL     USERID        OWUSER
     C  N91              UPDATE    RWKORD
     C   91              WRITE     RWKORD
     C                   Z-ADD     0             ORDNO
     C                   SETON                                        55
     C                   GOTO      RSTRT1
     C                   ENDDO                                                  KA DO
     C                   GOTO      NXTB
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** GET QTY ON ORDER  **
      ***********************
     C     GETORD        BEGSR
     C     PUTKEY        KLIST
     C                   KFLD                    SHPCYM
     C                   KFLD                    SMASTER           2 0
     C                   KFLD                    ORDNO
     C                   KFLD                    TRITEMP          12
     C                   KFLD                    TRSIZE
     C                   Z-ADD     0             QTYORD           11 1
     C                   Z-ADD     0             COUNT             5 0
     C                   MOVE      *BLANKS       ##ERR             1
     C                   If        TRSTAT = 'P' or
     C                             TRSTAT = 'S' and TRREAS = 'PRT'
     C                   Eval      TRITEMP = TRITEM
     C                   Eval      %SubSt(TRITEMP:12:1) = 'P'
     C                   Else
     C                   Eval      TRITEMP = TRITEM
     C                   ENDIF
     C     PUTKEY        SETLL     FPUTORDO
     C     NXTORD        TAG
     C     PUTKEY        READE     FPUTORDO                               90
     C   90              GOTO      ENDEOR
     C                   ADD       1             COUNT
     C     PDQORD        IFGT      PDQSCN
     C                   ADD       1             PDQSCN
     C                   UPDATE    PUTORD
     C                   GOTO      ENDORD
     C                   END
     C                   GOTO      NXTORD
      ** IF HERE ERROR
     C     ENDEOR        TAG
     C                   ExFmt     SCRNI
     C                   If        KeepBad = 2
      ** GET COMMON FIELDS
     C                   MOVEL     'Y'           ##ERR
     C                   MOVEL     'A'           TESTAT
     C                   Z-ADD     TAG#          TETAG#
     C                   Z-ADD     ORDNO         TEORD#
     C                   Z-ADD     SHPCYM        TESHDT
     C                   Z-ADD     TDATE         TEDTLA
     C                   Z-ADD     TIMOD         TETIME
     C                   MOVEL     USERID        TEUSER
      ** IF COUNT > 0 TO MANY SELECTED
     C     COUNT         IFGT      0
     C                   MOVEL     'OVR'         TEERR
     C                   ELSE
     C                   MOVEL     'NO '         TEERR
     C                   END
     C                   WRITE     RTRORE
     C                   EndIf
     C                   Eval      KeepBad = 0
     C     ENDORD        TAG
     C                   ENDSR
      ***********************
      ** CHECK ORDER       **
      ***********************
     C     CHKORD        BEGSR
     C                   SETOFF                                       99
     C                   MOVE      *BLANKS       ##ERR             1
     C     TROOKY        KLIST
     C                   KFLD                    SHPCYM
     C                   KFLD                    SMASTER
     C                   KFLD                    ORDNO
     C     TROOKY2       KLIST
     C                   KFLD                    SHPCYM
     C                   KFLD                    ORDNO
     C     TROOKY        SETLL     FPUTORDO
     C     NXTCHK        TAG
     C     TROOKY        READE(N)  FPUTORDO                               90
     C   90              GOTO      ENDCHK
      ** CHECK QTYS IF ANY ERROR GOTO ENDCHK
     C     PDQORD        IFNE      PDQSCN
     C                   SETON                                        99
     C                   MOVEL     'Y'           ##ERR
     C                   GOTO      ENDCK1
     C                   END
     C                   GOTO      NXTCHK
      ** CHECK IF ANY ERROR RECORDS
     C     ENDCHK        TAG
     C     ##ERR         IFEQ      'Y'
     C                   GOTO      ENDCK1
     C                   END
     C     TROOKY2       SETLL     FTROREO
     C     TROOKY2       READE     FTROREO                                90
     C   90              GOTO      ENDCK1
      ** IF HERE AT LEAST 1 ERROR RECORD
     C                   SETON                                        99
     C                   MOVEL     'Y'           ##ERR
     C                   GOTO      ENDCK1
     C     ENDCK1        TAG
     C                   ENDSR
      ***********************
      ** CLEAR ORDER       **
      ***********************
     C     CLRORD        BEGSR
      ** GET ALL ORDER #  & SEQ # SET TO ZERO
     C     TROOKY2       SETLL     FTRORDI
     C     NXTCLR        TAG
     C     TROOKY2       READE     FTRORDI                                90
     C   90              GOTO      ENDCLR
     C                   Z-ADD     0             TOSEQ#
     C                   Z-ADD     0             TOORD#
     C                   UPDATE    TRORDI
     C                   GOTO      NXTCLR
     C     ENDCLR        TAG
      ** GET ALL QTY SCANNED SET TO ZERO
     C     ORDNO         SETLL     FPUTORD
     C     NXTCL1        TAG
     C     ORDNO         READE     FPUTORD                                90
     C   90              GOTO      ENDCL1
     C     PDSHPD        IFEQ      SHPCYM
     C                   Z-ADD     0             PDQSCN
     C                   UPDATE    RPUTORD
     C                   END
     C                   GOTO      NXTCL1
     C     ENDCL1        TAG
      ** DELETE ALL ERROR RECORDS
     C     TROOKY2       SETLL     FTROREO
     C     NXTCL3        TAG
     C     TROOKY2       READE     FTROREO                                90
     C   90              GOTO      ENDCL3
     C                   DELETE    RTRORE
     C                   GOTO      NXTCL3
     C     ENDCL3        TAG
     C                   ENDSR
      ***********************
      ** CLEAR TRAY        **
      ***********************
      /Free

         BegSr CLRTAG;

         // Delete FTRORD Record for Selected Tray.
         Chain (SHPCYM: ORDNO: TAG#) FTRORDOT;
         If %Found(FTRORDOT);
           Delete RTRORDOT;
           // GET ALL QTY SCANNED SET TO ZERO
           Chain (TOORD#: TOSEQ#: SHPCYM) FPUTORD;
           If %Found(FPUTORD);
             PDQSCN = PDQSCN - 1;
             Update RPUTORD;
           ENDIF;
           // DELETE ALL ERROR RECORDS
           SetLL (SHPCYM: TOORD#: TOTAG#) FTROREO;
           ReadE (SHPCYM: TOORD#: TOTAG#) FTROREO;
           DoW Not %EOF(FTROREO);
             Delete RTRORE;
             ReadE (SHPCYM: TOORD#: TOTAG#) FTROREO;
           EndDo;
         ENDIF;

       EndSr;

      /End-Free


      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
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
