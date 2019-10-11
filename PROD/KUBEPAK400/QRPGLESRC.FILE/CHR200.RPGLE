      *--------------------------------------------------------------
      *
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- CHR200
      **SYSTEM-------------- TGMS
      **APPLICATION--------- REVIEW WEEKLY SPRAY INPUT
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FCHR200FM  CF   E             WORKSTN
     F                                     SFILE(SPYSFL:RECNO)
     F                                     SFILE(RECSFL:RECN1)
     FFCHMCTL   IF   E           K DISK
rpaddFFCHMJOBS  IF   E           K DISK
     F                                     RENAME(RCHMJOB:CHMJOB)
rpchgFFCHMJOB   UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:ICALEN)
      *
      ** MESSSAGE ARRAY
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)              MESSAGES
      ** CONTROL FILE ARRAYS
     D IT              S             12    DIM(40)                              ITEM NUMBERS
     D SZ              S              3    DIM(40)                              SIZE CODES
     D GL              S              5  0 DIM(40)                              PPM
     D PM              S              7  2 DIM(40)                              PPM
     D OZ              S              7  3 DIM(40)                              OZ/GAL
     D ML              S              7  3 DIM(40)                              ML/GAL
     D PL              S              5  0 DIM(40)                              ML/GAL
     D SP              S              4    DIM(40)                              SPRAY
     D TR              S              5  0 DIM(40)                              PPM
      ** SCREEN DESCRIPTION ARRAY
     D DC              S             10    DIM(40)                              DESC 10
     D SDES            S             10    DIM(40)                              DESC 10
     D SPPM            S              7  2 DIM(40)                              PPM 7.2
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
      *
      ** REDEFINE FCHMCTL
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
     ISCRNC
      ** GET ITEM NUMBERS
     I              DES01                       SDES(1)
     I              DES02                       SDES(2)
     I              DES03                       SDES(3)
     I              DES04                       SDES(4)
     I              DES05                       SDES(5)
     I              DES06                       SDES(6)
     I              DES07                       SDES(7)
     I              DES08                       SDES(8)
     I              DES09                       SDES(9)
     I              DES10                       SDES(10)
     I              DES11                       SDES(11)
     I              DES12                       SDES(12)
     I              DES13                       SDES(13)
     I              DES14                       SDES(14)
     I              DES15                       SDES(15)
     I              DES16                       SDES(16)
     I              DES17                       SDES(17)
     I              DES18                       SDES(18)
     I              DES19                       SDES(19)
     I              DES20                       SDES(20)
     I              DES21                       SDES(21)
     I              DES22                       SDES(22)
     I              DES23                       SDES(23)
     I              DES24                       SDES(24)
     I              DES25                       SDES(25)
     I              DES26                       SDES(26)
     I              DES27                       SDES(27)
     I              DES28                       SDES(28)
     I              DES29                       SDES(29)
     I              DES30                       SDES(30)
     I              DES31                       SDES(31)
     I              DES32                       SDES(32)
     I              DES33                       SDES(33)
     I              DES34                       SDES(34)
     I              DES35                       SDES(35)
     I              DES36                       SDES(36)
     I              DES37                       SDES(37)
     I              DES38                       SDES(38)
     I              DES39                       SDES(39)
     I              DES40                       SDES(40)
     I              PPM01                       SPPM(01)
     I              PPM02                       SPPM(02)
     I              PPM03                       SPPM(03)
     I              PPM04                       SPPM(04)
     I              PPM05                       SPPM(05)
     I              PPM06                       SPPM(06)
     I              PPM07                       SPPM(07)
     I              PPM08                       SPPM(08)
     I              PPM09                       SPPM(09)
     I              PPM10                       SPPM(10)
     I              PPM11                       SPPM(11)
     I              PPM12                       SPPM(12)
     I              PPM13                       SPPM(13)
     I              PPM14                       SPPM(14)
     I              PPM15                       SPPM(15)
     I              PPM16                       SPPM(16)
     I              PPM17                       SPPM(17)
     I              PPM18                       SPPM(18)
     I              PPM19                       SPPM(19)
     I              PPM20                       SPPM(20)
     I              PPM21                       SPPM(21)
     I              PPM22                       SPPM(22)
     I              PPM23                       SPPM(23)
     I              PPM24                       SPPM(24)
     I              PPM25                       SPPM(25)
     I              PPM26                       SPPM(26)
     I              PPM27                       SPPM(27)
     I              PPM28                       SPPM(28)
     I              PPM29                       SPPM(29)
     I              PPM30                       SPPM(30)
     I              PPM31                       SPPM(31)
     I              PPM32                       SPPM(32)
     I              PPM33                       SPPM(33)
     I              PPM34                       SPPM(34)
     I              PPM35                       SPPM(35)
     I              PPM36                       SPPM(36)
     I              PPM37                       SPPM(37)
     I              PPM38                       SPPM(38)
     I              PPM39                       SPPM(39)
     I              PPM40                       SPPM(40)
      ****************
      *   LDA        *
      ****************
     I*          UDS
     I*                                       1   20LCO                   ARC380
      **
      *
      ***********************
      ** START OR RESTART  **
      ***********************
     C**
     C*****       KEYS all keys added by rep
     C**
     C*          RU4KEY    KLIST
     C*                    KFLD           CJWKDT
     C*                    KFLD           CJJOB#
     C**
     C     RUNKEY        KLIST
     C                   KFLD                    CJWKDT
     C                   KFLD                    CJSPRY
     C                   KFLD                    CJSPIT
     C                   KFLD                    CJSPSZ
     C                   KFLD                    CJPPM
     C     JOBKEY        KLIST
     C                   KFLD                    STRDAT
     C                   KFLD                    CJJOB#
     C**
     C*          OZSKEY    KLIST
     C*                    KFLD           COITEM
     C*                    KFLD           COPPM
     C**
     C     MINJOB        KLIST
     C                   KFLD                    CJSPIT
     C                   KFLD                    CJSPSZ
     C********************************************************************
     C     RSTART        TAG
     C                   SETOFF                                       636450
     C                   SETOFF                                       9899
      ** DISPLAY SCREEN
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KB              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       636450
     C                   SETOFF                                       99
      **
      ** CHECK DATE
      **
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
      ** CHECK CONTROL FILE
     C     STRDAT        CHAIN     FCHMCTL                            12
     C   12              DO
     C                   SETON                                        102099
     C                   GOTO      NXTA
     C                   ENDDO
     C                   EXSR      BLDSPY
      ******************
      ** SPRAY SUBFILE *
      ******************
     C     NXTSPY        TAG
     C                   EXFMT     SPYCTL
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
     C                   EXSR      CHKSPY
     C                   EXSR      BLDSPY
     C                   GOTO      NXTSPY
      ******************
      ** END PROGRAM  **
      ******************
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SPRAY SFILE **
      ***********************
     C     BLDSPY        BEGSR
     C                   SETON                                        80
     C                   WRITE     SPYCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             X                 5 0
     C                   MOVE      *BLANKS       DISP
     C     PASS          TAG
     C                   ADD       1             X
     C     X             IFLE      40
     C     SPYKEY        KLIST
     C                   KFLD                    IT(X)
     C                   KFLD                    SZ(X)
     C                   MOVEL     '700'         SZ(X)
     C     IT(X)         IFLE      *BLANKS
     C     IT(X)         OREQ      '7208'
     C*    IT(X)         OREQ      '7207'
     C                   GOTO      PASS
     C                   END
     C     SPYKEY        CHAIN     FMINVT                             91
     C                   MOVEL     IMDES1        DESC1
     C                   MOVEL     IMDES1        DC(X)
     C                   Z-ADD     PM(X)         PPM
      ** GET TOTAL NEED
     C                   EXSR      GETNED
     C                   ADD       1             RECNO
     C                   WRITE     SPYSFL
     C                   GOTO      PASS
     C                   END
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   MOVEL     MSG(1)        DESC1
     C                   Z-ADD     0             MILL
     C                   Z-ADD     0             OUNCE
     C                   Z-ADD     0             GAL
     C                   Z-ADD     0             PPM
     C                   Z-ADD     0             TRAYS
     C                   ADD       2             RECNO
     C                   WRITE     SPYSFL
     C                   ENDSR
      ***********************
      **  CHECK SPRAY      **
      ***********************
     C     CHKSPY        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C                   MOVE      *BLANKS       OPTION
     C     RECNO         IFLE      LSTREC
     C     RECNO         CHAIN     SPYSFL                             90
     C   90              GOTO      NXTCHK
     C     DISP          IFEQ      'R'
     C                   MOVEL     '700'         SZ(X)
     C     SPYKEY        CHAIN     FMINVT                             91
     C                   MOVEL     IMDES1        DES
     C                   MOVEL     IMITEM        ITEM
RPADDC     *IN75         IFEQ      *OFF
     C                   Z-ADD     GAL           C1GAL
     C                   Z-ADD     TRAYS         C1TRAY
     C                   Z-ADD     OUNCE         C1OUZ
     C                   Z-ADD     MILL          C1MILL
     C                   ENDIF
     C**
     C                   SETON                                        80
     C                   WRITE     RECCTL
     C                   SETOFF                                       8075
     C**
     C                   Z-ADD     0             RECN1             5 0
     C                   MOVEL     IMITEM        SPITEM           12
     C     RECKEY        KLIST
     C                   KFLD                    STRDAT
     C                   KFLD                    SPITEM
     C                   KFLD                    PPM
     C     RECKEY        SETLL     FCHMJOBS
     C     NXTNCK        TAG
     C     RECKEY        READE     FCHMJOBS                               91
     C  N91              DO
     C**
     C     MINJOB        CHAIN     FMINVT                             91
     C     CJNOS         IFEQ      'N'
     C                   MOVEL     'North'       DIRECT
     C                   ELSE
     C                   MOVEL     'South'       DIRECT
     C                   END
     C**
     C                   ADD       1             RECN1
     C                   WRITE     RECSFL
     C                   GOTO      NXTNCK
     C                   ENDDO                                                  N91 DO
     C**
     C     RECN1         IFGE      1
     C                   Z-ADD     RECN1         LSTN1             5 0
     C     NXTNC1        TAG
     C                   EXFMT     RECCTL
     C   KF              GOTO      ENDCHK
     C                   Z-ADD     0             CHNG              5 0
     C                   Z-ADD     0             RECN1
     C     NXTNC2        TAG
     C                   ADD       1             RECN1
     C     RECN1         IFLE      LSTN1
     C     RECN1         CHAIN     RECSFL                             90
     C   90              GOTO      NXTNC2
CAB  C                   CLEAR                   XXJOB#
CAB  C                   CLEAR                   XXSECT
CAB  C                   CLEAR                   XXBAY
CAB  C                   CLEAR                   XXNOS
CAB  C                   CLEAR                   XXSPOL
CAB  C                   CLEAR                   XXSLOR
CAB  C                   CLEAR                   XXEPOL
CAB  C                   CLEAR                   XXELOR
     C     OPTION        IFEQ      'C'
rpaddC                   MOVE      CJJOB#        XXJOB#            6 0
rpaddC                   MOVE      CJSECT        XXSECT            2 0
rpaddC                   MOVE      CJNOS         XXNOS             1
rpaddC                   MOVE      CJBAY         XXBAY             2 0
rpaddC                   MOVE      CJSPOL        XXSPOL            2 0
rpaddC                   MOVE      CJSLOR        XXSLOR            1
rpaddC                   MOVE      CJEPOL        XXEPOL            2 0
rpaddC                   MOVE      CJELOR        XXELOR            1
     C                   EXSR      RECCHG
RPADDC                   MOVE      *ON           *IN75
     C                   ADD       1             CHNG
     C                   ENDIF                                                  OPTION=C
     C     CHNG          IFGT      0
     C                   SUB       1             RECNO
     C                   GOTO      NXTCHK
     C                   END                                                    CHNG>1
     C                   GOTO      NXTNC2
     C                   END                                                    RECN1<LSTN1
     C                   GOTO      NXTNC1
     C                   END
     C                   END
     C                   GOTO      NXTCHK
     C                   END
     C     ENDCHK        ENDSR
     C***********************
     C** GET CHANGES        *
     C***********************
     C     RECCHG        BEGSR
     C     JOBKEY        CHAIN     FCHMJOB                            91
      ** BUILD BOTTOM OF SCREEN
      /Free
         For x = 1 to 40;
           *In(x)  = *Off;
           If DC(x) > *Blanks;
             SL# = x;
             SDES(x) = DC(x);
             SPPM(x) = PM(x);
             *In(x)  = *On;
           EndIf;
         EndFor;
      /End-Free
      ** GET OPEN FLATS AND POLES
     C                   Z-ADD     CJSECT        SECT
     C                   Z-ADD     CJBAY         BAY
     C                   MOVEL     CJNOS         NORS
     C                   Z-ADD     CJSPOL        BPOLE
     C                   MOVEL     CJSLOR        BLORR
     C                   Z-ADD     CJEPOL        EPOLE
     C                   MOVEL     CJELOR        ELORR
     C                   CALL      'CHR300'
     C                   PARM                    STRDAT            7 0
     C                   PARM                    SECT              2 0
     C                   PARM                    BAY               2 0
     C                   PARM                    NORS              1
     C                   PARM                    BPOLE             2 0
     C                   PARM                    BLORR             1
     C                   PARM                    EPOLE             2 0
     C                   PARM                    ELORR             1
     C                   PARM                    OPNPOL            3 0
     C                   PARM                    OPNFLT            5 0
     C                   PARM                    CPAVL             3 0
     C                   ADD       CJTRAY        OPNFLT
     C     OPNFLT        DIV(H)    55            OPNPOL
     C                   Z-ADD     0             NEWNUM
     C                   Z-ADD     0             NEWSL
      ** DISPLAY RECORD
     C     NXTC          TAG
     C                   EXFMT     SCRNC
     C*                  WRITE     SCRNC
     C*                  READ      SCRNC                                  90
     C   KC              GOTO      ENDC
     C                   SETOFF                                       6364
      ** CHECK NUMBER OF FLATS
     C     NEWNUM        IFGT      0
     C     NEWNUM        ANDGT     OPNFLT
     C                   SETON                                        63
     C                   GOTO      NXTC
     C                   END
     C     NEWNUM        IFGT      0
     C                   EXSR      ADJTRY
     C                   ENDIF
      ** CHECK NEW CHEMICAL
     C     NEWSL         IFGT      0
     C     NEWSL         ANDGT     SL#
     C                   SETON                                        64
     C                   GOTO      NXTC
     C                   END
     C     NEWSL         IFGT      0
     C                   EXSR      SUBRUN
     C                   ENDIF
     C     ENDC          TAG
     C                   SETOFF                                       6364
     C                   ENDSR
      ***********************
      ** ADJTRY SUBROUTINE ** next two subroutines added by rep
      ***********************
     C     ADJTRY        BEGSR
     C**
     C     JOBKEY        CHAIN     FCHMJOB                            88
     C                   Z-ADD     NEWNUM        CJTRAY
     C                   UPDATE    RCHMJOB
     C                   EXSR      GETNED
     C                   ENDSR
      ***********************
      ** GET GALLONS NEEDED *
      ***********************
     C     GETNED        BEGSR
     C     NEDKEY        KLIST
     C                   KFLD                    STRDAT
     C                   KFLD                    IMITEM
     C                   KFLD                    PPM
     C                   MOVEL     IMITEM        ITM4              4
     C     NEDKEY        SETLL     FCHMJOBS
     C                   Z-ADD     0             GAL
     C                   Z-ADD     0             TRAYS
     C     NXTNED        TAG
     C     NEDKEY        READE     FCHMJOBS                               91
     C  N91              DO
     C                   ADD       CJTRAY        TRAYS
     C                   GOTO      NXTNED
     C                   ENDDO                                                   N91  DO
     C                   Z-ADD     TRAYS         C1TRAY
     C**
      *** 55 TRAYS EQUAL 1/2 GALLON USE 100 TRAYS/GAL FOR 10% OVERAGE
     C     TRAYS         DIV       100           GALWRK            9 4
     C                   MOVEL     GALWRK        GAL
     C                   MOVE      GALWRK        TST44             4 4
     C     TST44         IFGT      .0000
     C                   ADD       1             GAL
     C                   END
     C                   Z-ADD     GAL           C1GAL
     C     OZ(X)         MULT      GAL           OUNCE
     C                   Z-ADD     OUNCE         C1OUZ
     C     ML(X)         MULT      GAL           MILL
     C                   Z-ADD     MILL          C1MILL
     C*
     C                   ENDSR
      ***********************
      ** SUBRUN SUBROUTINE **
      ***********************
     C     SUBRUN        BEGSR
     C**
     C                   Z-ADD     NEWSL         SL#               2 0
     C                   Z-ADD     XXJOB#        CJJOB#
     C                   MOVE      STRDAT        NRWKDT            7 0
     C                   MOVEL     IT(SL#)       NRSPIT           12
     C                   MOVEL     PM(SL#)       NRPPM             7 2
     C*                    MOVE CRJOB#    CJJOB#
     C     JOBKEY        CHAIN     FCHMJOB                            95
     C**
     C**
     C                   MOVEL     NRSPIT        CJSPIT
     C                   MOVEL     NRPPM         CJPPM
     C**
     C                   UPDATE    RCHMJOB
     C**
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
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
     C                   ENDSR
**  MESSAGES
  *** End of List ***                            1
