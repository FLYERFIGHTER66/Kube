     H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')
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
      **PROGRAM NAME-------- CHR100
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SCAN GREENHOUSE TRAYS FOR WEEKLY SPRAY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *   1/16/03  CAB  CHANGED MOVE IMDES1 TO CJLOOK (30 ALPHA)
      *
     FCHR100FM  CF   E             WORKSTN
     FFTRAY     IF   E           K DISK
     F                                     RENAME(RTRAY:TRAYI)
     FFTRAYC    IF   E           K DISK
     FFSOWSCHJ  IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMINSER   IF   E           K DISK
     F                                     RENAME(RMINSER:MINSER)
     FFMINSERS  IF   E           K DISK
     FFCHMCTL   UF   E           K DISK
     FFCHMLOCP  IF   E           K DISK
     F                                     RENAME(RCHMLOC:CHMLOC)
     FFCHMLOC   UF A E           K DISK
     FFCHMJOB   UF A E           K DISK
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:ICALEN)
     FFCHMDFT   UF A E           K DISK
      *
      ** CONTROL FILE ARRAYS
     D IT              S             12    DIM(40)                              ITEM NUMBERS
     D SZ              S              3    DIM(40)                              SIZE CODES
     D PM              S              7  2 DIM(40)                              PPM
     D OZ              S              7  3 DIM(40)                              OZ/GAL
     D ML              S              7  3 DIM(40)                              ML/GAL
     D SS              S              6  0 DIM(40)                              SCREEN PPM (SAVED)
     D SDS             S             10    DIM(40)                              SCREEN CHEM DESC.(SA
     D DS              S             12    DIM(40)                              SCREEN CHEM ITEM
      ** SCREEN B ARRAY
     D SCRNB_DS        DS
     D  SECT                          2S 0 INZ(0)
     D  BAY                           2S 0 INZ(0)
     D  NORS                          1A   INZ
     D  LOCATE                        5A   OVERLAY(SCRNB_DS)
      ** SCREEN PPM ARRAY
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
     D  SC                            6  2
     D                                     DIM(40) OVERLAY(SPPM)                SCREEN PPM
      ** SCREEN PPM ARRAY
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
      *
WJB  D*          IDS
WJB  D*                                       1   5 SBNS
WJB  D*                                       1   20SECT
WJB  D*                                       3   40BAY
WJB  D*                                       5   5 NORS
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
      ***********************
     D  tr5565         S              2s 0
      /include QFunctDefn,$_DATES
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
      ****************
      *   LDA        *
      ****************
     I*          UDS
     I*                                       1   20LCO                   ARC380
      **
      ***********************
      ** START OR RESTART  **
      ***********************
      /Free
        // Start with monday date
        FRMDAT =  CLDATE;
        // Start with today's date instead
        FRMDAT = $MDYDate($Date(0));
        // no...  Start with latest control file date instead
        Exec SQL  //  Get the later of current date or last chem run date
          select mdy6 into :FRMDAT
          from FCHMCTL join fcalen_all on chwkdt = cymd7
          order by chwkdt desc
          fetch first row only;
      /End-Free
      /End-free
     C     RSTART        TAG
     C*                    Z-ADD0         FRMDAT
     C*                    Z-ADD0         BEGYY
     C*                    Z-ADD0         BEGWW
     C                   EVAL      *IN35 = *On
     C                   MOVE      *BLANKS       OPROD
     C                   MOVE      *BLANKS       UPDATE            1
     C                   Z-ADD     0             OPPM
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
     C   KB              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       1299
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
      ** CHECK CONTROL FILE
     C     STRDAT        CHAIN(N)  FCHMCTL                            12
     C   12              DO
     C                   SETON                                        102099
     C                   GOTO      NXTA
     C                   ENDDO
      ******************
      ** SCREEN B     **
      ******************
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
      ** CHK F KEYS
     C                   If        *In04
      /Free
        *In35 = not *In35;
      /End-Free
     C                   GOTO      NXTB
     C                   ENDIF
     C   KF              GOTO      RSTART
     C   KB              GOTO      NXTA
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       1015
     C                   SETOFF                                       202122
      *** CHECK SECTION
     C     SECT          IFLT      1
     C     SECT          ORGT      15
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   END
      ** CHECK BAY
     C     BAY           IFLE      0
     C     BAY           ORGT      63
     C                   SETON                                        2022
     C                   GOTO      NXTB
     C                   END
      ** CHECK BAY/SECTION
     C     SECT          IFEQ      1
     C     BAY           IFGT      13
     C                   SETON                                        2021
     C                   GOTO      NXTB
     C                   END
     C                   END
     C     SECT          IFEQ      2
     C     BAY           IFLT      14
     C     BAY           ORGT      25
     C                   SETON                                        2021
     C                   GOTO      NXTB
     C                   END
     C                   END
     C     SECT          IFEQ      3
     C     BAY           IFLT      26
     C     BAY           ORGT      38
     C                   SETON                                        2021
     C                   GOTO      NXTB
     C                   END
     C                   END
     C     SECT          IFEQ      4
     C     BAY           IFLT      39
     C     BAY           ORGT      50
     C                   SETON                                        2021
     C                   GOTO      NXTB
     C                   END
     C                   END
     C     SECT          IFEQ      5
     C     BAY           IFLT      51
     C     BAY           ORGT      63
     C                   SETON                                        2021
     C                   GOTO      NXTB
     C                   END
     C                   END
     C     SECT          IFEQ      6
     C     BAY           IFGT      16
     C                   SETON                                        2021
     C                   GOTO      NXTB
     C                   END
     C                   END
     C     SECT          IFEQ      7
     C     BAY           IFLT      17
     C     BAY           ORGT      28
     C                   SETON                                        2021
     C                   GOTO      NXTB
     C                   END
     C                   END
     C     SECT          IFEQ      8
     C     BAY           IFLT      29
     C     BAY           ORGT      40
     C                   SETON                                        2021
     C                   GOTO      NXTB
     C                   END
     C                   END
     C     SECT          IFEQ      9
     C     BAY           IFLT      41
     C     BAY           ORGT      50
     C                   SETON                                        2021
     C                   GOTO      NXTB
     C                   END
     C                   END
     C     SECT          IFEQ      10
     C     BAY           IFLT      51
     C     BAY           ORGT      61
     C                   SETON                                        2021
     C                   GOTO      NXTB
     C                   END
     C                   END
     C     SECT          IFEQ      11
     C     BAY           IFLT      01
     C     BAY           ORGT      12
     C                   SETON                                        2021
     C                   GOTO      NXTB
     C                   END
     C                   END
      *** CHECK NORTH OR SOUTH
     C     NORS          IFNE      'N'
     C     NORS          ANDNE     'S'
     C                   SETON                                        15
     C                   GOTO      NXTB
     C                   END
     C     NORS          IFEQ      'N'
     C                   MOVEL     'North'       DIRECT
     C                   ELSE
     C                   MOVEL     'South'       DIRECT
     C                   END
WJB  C                   Z-ADD     *ZERO         CLTRAY
WJB  C                   Z-ADD     1             NXPOLE
WJB  C                   MOVE      'L'           NXLOR
      /Free
        Select;
          When SECT >= 1 and SECT <= 10;
            tr5565 = 55;
          When SECT = 11;
            tr5565 = 65;
          Other;
            tr5565 = 55;
        ENDSL;
      /End-Free
      ******************
      ** SCREEN C     **
      ******************
     C     NXTC          TAG
WJB   **  IF THIS POLE IS FILLED, GET THE NEXT POLE
WJB  C*    CLTRAY        IFEQ      55
WJB  C     CLTRAY        IFEQ      tr5565
WJB   **  IF YOU ARE ON THE LEFT, ADD POLES: ON RIGHT SUBTRACT POLES
WJB  C     LORR          IFEQ      'L'
WJB  C                   ADD       1             NXPOLE
WJB   **  IF YOU ARE ON THE LEFT GO TO RIGHT IF LEFT IS FILLED
WJB  C     SECT          IFGE      1
WJB  C     SECT          ANDLE     5
WJB  C     NXPOLE        ANDGT     12
WJB  C                   MOVE      'R'           NXLOR
WJB  C                   Z-ADD     12            NXPOLE
WJB  C                   ELSE
WJB  C     SECT          IFGE      6
WJB  C     SECT          ANDLE     10
WJB  C     NXPOLE        ANDGT     14
WJB  C                   MOVE      'R'           NXLOR
WJB  C                   Z-ADD     14            NXPOLE
WJB  C                   ENDIF
WJB  C     SECT          IFGE      11
WJB  C     SECT          ANDLE     11
WJB  C     NXPOLE        ANDGT     10
WJB  C                   MOVE      'R'           NXLOR
WJB  C                   Z-ADD     10            NXPOLE
WJB  C                   ENDIF
WJB  C                   ENDIF
WJB  C                   ELSE
WJB   **  IF YOU ARE ON THE RIGHT SUBTRACT POLES
WJB  C                   SUB       1             NXPOLE
WJB  C                   ENDIF
WJB  C                   ENDIF
WJB   **  INITIALIZE SCREEN FIELDS WITH WORK FIELDS
WJB  C                   Z-ADD     NXPOLE        POLE
WJB  C                   MOVE      NXLOR         LORR
     C     ERRC          TAG
     C*                  MOVEL     '1 -   '      POLEDS
     C*    SECT          IFLE      5
     C*                  MOVE      '12'          POLEDS
     C*                  ELSE
     C*                  MOVE      '14'          POLEDS
     C*                  END
      /Free
        Select;
          When SECT >=  1 and SECT <= 5;
            POLEDS = '1 - 12';
          When SECT >=  5 and SECT <= 10;
            POLEDS = '1 - 14';
          When SECT >= 11 and SECT <= 11;
            POLEDS = '1 - 10';
          Other;
            POLEDS = '1 - 14';
        ENDSL;
      /End-Free
     C                   WRITE     SCRNC
     C                   READ      SCRNC                                  90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KB              GOTO      NXTB
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       102024
     C                   SETOFF                                       212223
      *** CHECK FOR 1 OR 2
     C     LORR          IFEQ      '1'
     C                   MOVEL     'L'           LORR
     C                   END
     C     LORR          IFEQ      '2'
     C                   MOVEL     'R'           LORR
     C                   END
      *** CHECK LEFT OR RIGHT
     C     LORR          IFNE      'L'
     C     LORR          ANDNE     'R'
     C                   SETON                                        10
     C                   GOTO      ERRC
     C                   END
      ** CHECK POLES
     C     POLE          IFLE      0
     C                   SETON                                        2021
     C                   GOTO      ERRC
     C                   END
     C     SECT          IFLE      5
     C     POLE          ANDGT     12
     C                   SETON                                        2022
     C                   GOTO      ERRC
     C                   END
     C     SECT          IFGE      6
WJB  C     SECT          ANDLE     10
     C     POLE          ANDGT     14
     C                   SETON                                        2023
     C                   GOTO      ERRC
     C                   END
WJB  C     SECT          IFGE      11
WJB  C     SECT          ANDLE     11
WJB  C     POLE          ANDGT     10
WJB  C                   SETON                                        2023
WJB  C                   GOTO      ERRC
WJB  C                   END
WJB  C     SECT          IFGE      12
WJB  C     SECT          ANDLE     15
WJB  C     POLE          ANDGT     12
WJB  C                   SETON                                        2023
WJB  C                   GOTO      ERRC
WJB  C                   END
     C     SECT          IFLE      5
WJB  C     SECT          ORGE      11
     C                   Z-ADD     24            TOTPOL            3 0
     C                   Z-ADD     1             CJHSE
     C                   ELSE
     C                   Z-ADD     28            TOTPOL
     C                   Z-ADD     2             CJHSE
     C                   END
      /Free

        Select;
          When SECT >=  1 and SECT <= 5;
            TOTPOL = 24;
            CJHSE  =  1;
          When SECT >=  5 and SECT <= 10;
            TOTPOL = 28;
            CJHSE  =  2;
          When SECT >= 11 and SECT <= 11;
            TOTPOL = 20;
            CJHSE  =  3;
          Other;
            TOTPOL = 28;
            CJHSE  =  3;
        ENDSL;

      /End-Free
      ** CHECK LOCATION FILE
     C     LOCKEY        KLIST
     C                   KFLD                    STRDAT
     C                   KFLD                    SECT
     C                   KFLD                    BAY
     C                   KFLD                    NORS
     C                   KFLD                    LORR
     C                   KFLD                    POLE
     C     LOCKEY        CHAIN(N)  FCHMLOC                            92
     C   92              DO
     C                   CLEAR                   RCHMLOC
     C                   Z-ADD     STRDAT        CLWKDT
     C                   Z-ADD     SECT          CLSECT
     C                   Z-ADD     BAY           CLBAY
     C                   MOVEL     NORS          CLNOS
     C                   MOVEL     LORR          CLLOR
     C                   Z-ADD     POLE          CLPOLE
     C     LORR          IFEQ      'L'
     C                   Z-ADD     CLPOLE        CLPLKY
     C                   ELSE
     C     50            SUB       CLPOLE        CLPLKY
     C                   END
     C                   TIME                    CLTIME
     C                   Z-ADD     TDATE         CLDTLA
     C                   MOVEL     USERID        CLUSER
     C                   WRITE     RCHMLOC
     C                   ENDDO                                                  92 DO
     C*    CLTRAY        IFGE      55                                            55=MAX TRAY
     C*                  If           (CLTRAY > 55 and SECT <  11)
     C*                            or (CLTRAY > 65 and SECT >= 11)
     C     CLTRAY        IFGE      tr5565                                        MAX TRAY
     C                   SETON                                        2024
     C                   GOTO      ERRC
     C                   END
     C*    55            SUB       CLTRAY        CPAVL             3 0
     C     tr5565        SUB       CLTRAY        CPAVL             3 0
     C                   Z-ADD     CLPLKY        CURPOL            2 0
      ******************
      ** SCREEN D     **
      ******************
     C     NXTD          TAG
     C                   WRITE     SCRND
     C                   READ      SCRND                                  90
      ** CHK F KEYS
     C   KB              GOTO      NXTC                                         F2=Previous
     C   KC              GOTO      END                                          F3=Exit
     C   KE              Do                                                     F5=New Pole
      /Free
        If LORR = 'L';
          POLE += 1;
         Else;
          POLE -= 1;
        ENDIF;
        If LORR = 'L' and POLE > (TOTPOL * .5);
          POLE -= 1;
          LORR = 'R';
        ENDIF;
        If POLE = 0;
          *INKD = *On;
        ENDIF;
      /End-Free
     C  NKD              GOTO      NXTD
     C                   ENDDO
     C   KD              GOTO      NXTB                                         F4=New Location
     C   KF              GOTO      RSTART                                       F6=Restart
     C   KG              GOTO      END                                          F7=Exit
     C                   SETOFF                                       1020
     C                   SETOFF                                       212223
      ** CHECK TAG #
     C     TAG#          IFLE      0
     C                   SETON                                        10
     C                   GOTO      NXTD
     C                   END
     C     TAG#          CHAIN     FTRAY                              10
WJB  C   10              MOVE      *BLANKS       SVITEM
WJB  C   10              MOVE      *BLANKS       SVSIZE
     C   10              GOTO      NXTD
WJB  C  N10              MOVE      TRITEM        SVITEM
WJB  C  N10              MOVE      TRSIZE        SVSIZE
WJB  C     *LIKE         DEFINE    TRITEM        SVITEM
WJB  C     *LIKE         DEFINE    TRSIZE        SVSIZE
     C                   Z-ADD     TRORDT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         CJRDYD
      ** GET NUMBER OF TRAYS ETC
     C                   EXSR      GETNUM
     C                   Z-ADD     0             POLEIN
     C                   Z-ADD     SOSOWQ        TRAYIN
     C                   Z-ADD     SOSOWQ        SOWQ
     C                   MOVEL     IMDES1        DES1
      ******************
      ** SCREEN E     **
      ******************
     C     NXTE          TAG
     C                   WRITE     SCRNE
     C                   READ      SCRNE                                  90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KB              GOTO      NXTD
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       1020
     C                   SETOFF                                       111213
      ** CHECK FLATS
     C     TRAYIN        IFLE      0
     C     POLEIN        ANDLE     0
     C                   SETON                                        102011
     C                   GOTO      NXTE
     C                   END
     C     TRAYIN        IFGT      0
     C     POLEIN        ANDGT     0
     C                   SETON                                        102012
     C                   GOTO      NXTE
     C                   END
     C     TRAYIN        IFGT      POLFLT
     C**         TRAYIN    IFGT OPNFLT
     C                   SETON                                        102013
     C                   GOTO      NXTE
     C                   END
     C     POLEIN        IFGT      POLEFT
     C     POLEIN        ORGT      OPNPOL
     C                   SETON                                        2021
     C                   GOTO      NXTE
     C                   END
      ******************
      ** SCREEN F     **
      ******************
     C                   MOVE      *BLANKS       OPROD             4
     C                   Z-ADD     0             OPPM              7 2
     C                   MOVE      *BLANKS       SPDES1
     C     NXTF          TAG
WJB  C     DFTKEY        KLIST
WJB  C                   KFLD                    SVITEM
WJB  C                   KFLD                    SVSIZE
WJB  C     DFTKEY        CHAIN     FCHMDFT                            31
WJB  C   31              MOVE      *BLANKS       PROD
WJB  C  N31              MOVEL     CDCHEM        PROD
WJB  C     CHMKEY        KLIST
WJB  C                   KFLD                    CDCHEM
WJB  C                   KFLD                    CDCSIZ
WJB  C  N31CHMKEY        CHAIN     FMINVT                             32
     C  N31
WJB  CANN32              MOVEL     IMDES1        SPDES1
     C     ERRF          TAG
     C                   WRITE     SCRNF
     C                   READ      SCRNF                                  90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KB              GOTO      NXTE
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       102021
     C                   SETOFF                                       111213
     C     PROD          IFLE      *BLANKS
WJB  C                   EXSR      DISPG
WJB  C   KC
WJB  COR KG              GOTO      END
WJB  C     PROD          IFLE      *BLANKS
     C                   SETON                                        1011
     C                   MOVE      *BLANKS       OPROD
     C                   GOTO      ERRF
WJB  C                   END
     C                   END
     C     PPM           IFLE      0
WJB  C                   EXSR      DISPH
WJB  C   KC
WJB  COR KG              GOTO      END
WJB  C     PPM           IFLE      0
     C                   SETON                                        2021
     C                   Z-ADD     0             OPPM
     C                   GOTO      ERRF
WJB  C                   END
     C                   END
     C                   MOVE      PPM           PPMI              7 2
     C                   MOVE      *BLANKS       IMITEM
     C                   MOVEL     PROD          IMITEM
     C                   MOVEL     '700'         IMSIZE
     C     ITMKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     ITMKEY        CHAIN     FMINVT                             13
     C   13              DO
     C                   SETON                                        10
     C                   MOVE      *BLANKS       OPROD
     C                   MOVE      *BLANKS       SPDES1
     C                   GOTO      ERRF
     C                   ENDDO                                                  13 DO
     C                   MOVEL     IMDES1        SPDES1
      ** NOW SEE IF ON SCHEDULE
     C                   Z-ADD     0             X                 3 0
     C     NXTX          TAG
     C                   ADD       1             X
     C     X             IFLE      40
     C     PROD          IFEQ      IT(X)
     C     PPMI          ANDEQ     PM(X)
     C                   GOTO      XOK
     C                   END
     C                   GOTO      NXTX
     C                   END                                                    X<=40
      ** IF HERE ERROR
     C                   SETON                                        102012
     C                   MOVE      *BLANKS       OPROD
     C                   Z-ADD     0             OPPM
     C                   GOTO      ERRF
      ** IF HERE PROD/PPM OK
     C     XOK           TAG
     C     PROD          IFNE      OPROD
     C     PPMI          ORNE      OPPM
     C                   MOVEL     PROD          OPROD
     C                   Z-ADD     PPMI          OPPM
     C                   GOTO      ERRF
     C                   END
      ** IF HERE ALL OK UPDATE FILES
WJB  C   31              DO
WJB  C                   MOVE      SVITEM        CDITEM
WJB  C                   MOVE      SVSIZE        CDSIZE
WJB  C                   MOVEL     PROD          CDCHEM
WJB  C                   MOVE      '700'         CDCSIZ
WJB  C                   WRITE     RCHMDFT
WJB  C                   ENDDO
      * GET JOB NUMBER
     C     UPDATE        IFNE      'Y'
     C     STRDAT        CHAIN     FCHMCTL                            91
     C                   Z-ADD     CHNJOB        JOB#              6 0
     C                   ADD       1             CHNJOB
     C  N91              UPDATE    RCHMCTL
      ** DO NOT CLEAR JOB RECORD FIELDS HAVE BEEN UPDATED PRIOR TO THIS
      ** FILL KEY FIELDS
     C**********           CLEARRCHMJOB
     C                   Z-ADD     JOB#          CJJOB#
     C                   Z-ADD     STRDAT        CJWKDT
     C                   END                                                    UPDATE><Y
      ** NOW GET OTHER FIELDS
     C                   MOVE      *BLANKS       CJSPIT
     C                   MOVEL     PROD          CJSPIT
     C                   MOVEL     '700'         CJSPSZ
     C                   Z-ADD     PPMI          CJPPM
     C     POLEIN        IFGT      0
     C     POLEIN        SUB       1             WRKPOL            3 0
     C*    55            MULT      WRKPOL        WRKTRY            5 0
     C     tr5565        MULT      WRKPOL        WRKTRY            5 0
     C                   ADD       CPAVL         WRKTRY
     C                   ELSE
     C                   Z-ADD     TRAYIN        WRKTRY
     C                   END                                                    POLEIN>0
     C                   Z-ADD     WRKTRY        CJTRAY
     C                   Z-ADD     SECT          CJSECT
     C                   Z-ADD     BAY           CJBAY
     C                   MOVEL     NORS          CJNOS
      ** GET POLE INFO
     C                   Z-ADD     POLE          CJSPOL
     C                   MOVEL     LORR          CJSLOR
     C     LORR          IFEQ      'L'
     C                   Z-ADD     POLE          CJSPKY
     C                   ELSE
     C     50            SUB       POLE          CJSPKY
     C                   END
      ** ALL SAME POLE?
     C     CJTRAY        IFLE      CPAVL
     C                   Z-ADD     CJTRAY        CJTRBP
     C                   Z-ADD     CJSPOL        CJEPOL
     C                   Z-ADD     CJSPKY        CJEPKY
     C                   MOVEL     CJSLOR        CJELOR
     C                   Z-ADD     CJTRAY        CJTREP
     C                   MOVEL     'Y'           SINPOL            1
     C                   ELSE
     C                   Z-ADD     CPAVL         CJTRBP
     C                   MOVEL     'N'           SINPOL            1
     C                   END
      ** GET LOC FILE
     C                   Z-ADD     STRDAT        CLWKDT
     C                   Z-ADD     CJSECT        CLSECT
     C                   Z-ADD     CJBAY         CLBAY
     C                   MOVEL     CJNOS         CLNOS
     C                   Z-ADD     CJSPOL        CLPOLE
     C                   Z-ADD     CJSPKY        CLPLKY
     C                   MOVEL     CJSLOR        CLLOR
     C                   Z-ADD     CJTRBP        CLWKTR            3 0
     C                   EXSR      GETLOC
     C     SINPOL        IFEQ      'Y'
      ** OUTPUT JOB RECORD
     C                   TIME                    CJTIME
     C                   Z-ADD     TDATE         CJDTLA
     C                   MOVEL     USERID        CJUSER
     C                   WRITE     RCHMJOB
     C                   GOTO      ENDINP
     C                   END
      ** SPLIT UP REMAINING TRAYS
     C     CJTRAY        SUB       CJTRBP        TRYLFT            5 0
     C     TOTPOL        DIV       2             BAYPOL            2 0
     C     NXTRY         TAG
     C     TRYLFT        IFLE      0
      ** OUTPUT JOBFILE
     C                   Z-ADD     CLPOLE        CJEPOL
     C                   Z-ADD     CLPLKY        CJEPKY
     C                   MOVEL     CLLOR         CJELOR
     C                   Z-ADD     CLWKTR        CJTREP
     C                   TIME                    CJTIME
     C                   Z-ADD     TDATE         CJDTLA
     C                   MOVEL     USERID        CJUSER
     C                   WRITE     RCHMJOB
     C                   GOTO      ENDINP
     C                   END
      ** GET NEXT POLE NUMBER
     C     CLLOR         IFEQ      'L'
     C                   ADD       1             CLPOLE
     C                   Z-ADD     CLPOLE        CLPLKY
     C                   ELSE
     C                   SUB       1             CLPOLE
     C     50            SUB       CLPOLE        CLPLKY
     C                   END
     C     CLPOLE        IFGT      BAYPOL
     C                   Z-ADD     BAYPOL        CLPOLE
     C     50            SUB       CLPOLE        CLPLKY
     C                   MOVEL     'R'           CLLOR
     C                   END
      **
     C*    TRYLFT        IFGE      55
     C     TRYLFT        IFGE      tr5565
     C*                  Z-ADD     55            CLWKTR
     C                   Z-ADD     tr5565        CLWKTR
     C                   Z-ADD     STRDAT        CLWKDT
     C                   Z-ADD     CJSECT        CLSECT
     C                   Z-ADD     CJBAY         CLBAY
     C                   MOVEL     CJNOS         CLNOS
     C                   EXSR      GETLOC
     C*                  SUB       55            TRYLFT
     C                   SUB       tr5565        TRYLFT
     C                   GOTO      NXTRY
     C                   END                                                    TRYLFT>=tr5565
      ** TRYLFT LESS THAN tr5565
     C                   Z-ADD     TRYLFT        CLWKTR
     C                   Z-ADD     STRDAT        CLWKDT
     C                   Z-ADD     CJSECT        CLSECT
     C                   Z-ADD     CJBAY         CLBAY
     C                   MOVEL     CJNOS         CLNOS
     C                   EXSR      GETLOC
     C                   Z-ADD     0             TRYLFT
     C                   GOTO      NXTRY
      ******************
      ** END INPUT    **
      ******************
     C     ENDINP        TAG
      ** CLEAR FIELDS
     C                   Z-ADD     0             TAG#
     C                   Z-ADD     0             TRAYIN
     C                   Z-ADD     0             POLEIN
     C                   MOVE      *BLANKS       PROD
     C                   Z-ADD     0             PPM
     C                   Z-ADD     0             PPMI
     C                   MOVE      *BLANKS       SPDES1
      ** DECIDE WHERE TO GO
     C     LOCKEY        CHAIN(N)  FCHMLOC                            92
     C*    CLTRAY        IFLT      55
     C     CLTRAY        IFLT      tr5565
     C*    55            SUB       CLTRAY        CPAVL             3 0
     C     tr5565        SUB       CLTRAY        CPAVL             3 0
     C                   Z-ADD     CLPLKY        CURPOL            2 0
      ** IF HERE, THERE'S MORE ROOM IN THIS POLE... GET NEXT TAG
     C                   GOTO      NXTD
     C                   END                                                    CLTRAY<tr5565
      ** IF HERE NEED AT LEAST NEW POLE
      ** IF YOU'VE JUST FILLED THE REST OF POLE ONE ON THE RIGHT SIDE,
      ** PROMPT FOR A NEW BAY.
WJB  C*wjb LORR          IFEQ      'R'
WJB  C     CJELOR        IFEQ      'R'
WJB  C*wjb POLE          ANDEQ     1
WJB  C     CJEPOL        ANDEQ     1
WJB   **   IF YOU WERE ON THE NORTH SIDE, DEFAULT THE BAY TO THE SOUTH
WJB   **   AND TO THE NORTH SIDE IF YOU WERE ON THE BAY TO THE SOUTH
WJB   **   ALSO ASSUME WORK WILL BEGIN ON THE LEFT POLE 01
WJB  C     NORS          IFEQ      'N'
WJB  C                   MOVE      'S'           NORS
WJB  C                   ELSE
WJB  C                   MOVE      'N'           NORS
WJB  C                   ENDIF
WJB  C                   MOVE      'L'           LORR
WJB  C                   Z-ADD     1             POLE
     C                   GOTO      NXTB
     C                   ENDIF
      *
WJB  C*                    MOVE *BLANKS   LORR
WJB  C*                    Z-ADD0         POLE
     C                   GOTO      NXTC
      ******************
      ** END PROGRAM  **
      ******************
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** SCREEN "G" LOGIC  **
      ***********************
     C     DISPG         BEGSR
     C                   Z-ADD     1             X
     C                   Z-ADD     1             Y                 2 0
     C     X             DOUGT     40
     C     IT(X)         IFNE      SVIT
     C     IT(X)         ANDNE     *BLANKS
     C                   MOVE      IT(X)         SVIT             12
     C                   MOVE      SVIT          ITKEY            12
     C                   MOVE      '700'         SZKEY             3
     C     SCMKEY        KLIST                                                  SCREEN CHEM KEY
     C                   KFLD                    ITKEY            12
     C                   KFLD                    SZKEY             3
     C     SCMKEY        CHAIN     FMINVT                             33
     C   33              MOVEL     *BLANKS       SD(Y)
     C   33              MOVEL     *BLANKS       SDS(Y)
     C  N33              MOVEL     IMDES1        SD(Y)
     C  N33              MOVEL     IMDES1        SDS(Y)
     C  N33              MOVE      IMITEM        DS(Y)
     C                   ADD       1             Y
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
      *  Process Screen G until F-Key or CHEMICAL selected
     C     *INKB         DOUEQ     *ON
     C     *INKC         OREQ      *ON
     C     CSRFLD        ORGE      'CHM01'
     C     CSRFLD        ANDLE     'CHM40'
     C     PROD          ANDNE     *BLANKS
      *
     C                   EXFMT     SCRNG
      *
     C     CSRFLD        IFGE      'CHM01'
     C     CSRFLD        ANDLE     'CHM40'
     C     *INKB         ANDNE     *ON
     C     *INKC         ANDNE     *ON
     C                   MOVE      CSRFL#        X
     C                   MOVEL     DS(X)         PROD
     C                   MOVEL     SDS(X)        SPDES1
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      ***********************
      ** SCREEN "H" LOGIC  **
      ***********************
     C     DISPH         BEGSR
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
      *  Process Screen H until F-Key or PPM selected
     C     *INKB         DOUEQ     *ON
     C     *INKC         OREQ      *ON
     C     CSRFLD        ORGE      'PPM01'
     C     CSRFLD        ANDLE     'PPM40'
     C     PPM           ANDNE     *ZERO
      *
     C                   EXFMT     SCRNH
      *
     C     CSRFLD        IFGE      'PPM01'
     C     CSRFLD        ANDLE     'PPM40'
     C     *INKB         ANDNE     *ON
     C     *INKC         ANDNE     *ON
     C                   MOVE      CSRFL#        X
     C                   Z-ADD     SS(X)         PPM
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      ***********************
      ** GET POSSIBLE NUMB **
      ***********************
     C     GETNUM        BEGSR
     C     MINKEY        KLIST
     C                   KFLD                    TRITEM
     C                   KFLD                    TRSIZE
     C     MINKEY        CHAIN     FMINVT                             90
CAB  C***                  MOVELIMLOOK    CJLOOK
CAB  C                   MOVEL     IMDES1        CJLOOK
     C                   MOVEL     IMITEM        CJITEM
     C                   MOVEL     IMSIZE        CJSIZE
     C     JOBKEY        KLIST
     C                   KFLD                    TRSCYM
     C                   KFLD                    TRJOB#
     C     JOBKEY        CHAIN     FSOWSCHJ                           90
     C                   Z-ADD     TRORDT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         RDYDAT
      ** GET HOW MANY BY SERIES
     C     TRITEM        CHAIN     FMINSER                            91
     C                   Z-ADD     0             SERTOT
     C   91              GOTO      ENDSER
     C                   MOVEL     ISCODE        CJSERI
     C     ISCODE        SETLL     FMINSERS
     C     NXTSER        TAG
     C     ISCODE        READE     FMINSERS                               91
     C   91              GOTO      ENDSER
      ** GET TRAY FILE
     C     TRYKEY        KLIST
     C                   KFLD                    ISITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    TRSCYW
     C     TRYKEY        SETLL     FTRAYC
     C     NXTTRS        TAG
     C     TRYKEY        READE     FTRAYC                                 92
     C   92              GOTO      NXTSER
     C                   ADD       1             SERTOT
     C                   GOTO      NXTTRS
     C     ENDSER        TAG
      * NOW I HAVE ALL SOWN HOW MANY POLES LEFT?
     C     LORR          IFEQ      'L'
     C                   Z-ADD     POLE          POLEW             2 0
     C                   ELSE
      /Free
       //c TOTPOL        IFEQ      24
       //c 12            SUB       POLE          SUBPOL            2 0
       //c 13            ADD       SUBPOL        POLEW
       //c               ELSE
       //c 14            SUB       POLE          SUBPOL            2 0
       //c 15            ADD       SUBPOL        POLEW
       //c               END
        SUBPOL = (TOTPOL*.5) - POLE;
        POLEW  =  TOTPOL     - POLE;
      /End-Free
     C                   END
     C     TOTPOL        SUB       POLEW         POLEFT
     C*    POLEFT        MULT      55            POLFLT
     C     POLEFT        MULT      tr5565        POLFLT
      ** GET REST OF THIS POLE
     C                   ADD       CPAVL         POLFLT
     C                   ADD       1             POLEFT
      ** CHECK NEXT RECORD
     C     LOPKEY        KLIST
     C                   KFLD                    STRDAT
     C                   KFLD                    SECT
     C                   KFLD                    BAY
     C                   KFLD                    NORS
     C                   KFLD                    TSTPOL
     C     LOCTST        KLIST
     C                   KFLD                    STRDAT
     C                   KFLD                    SECT
     C                   KFLD                    BAY
     C                   KFLD                    NORS
     C     CURPOL        ADD       1             TSTPOL            2 0
     C     LOPKEY        SETLL     FCHMLOCP
     C     LOCTST        READE     FCHMLOCP                               94
     C   94              DO
     C                   Z-ADD     POLEFT        OPNPOL            3 0
     C                   Z-ADD     POLFLT        OPNFLT            3 0
     C                   ENDDO                                                  94  DO
      ** N94 MEANS A RECORD AFTER CURRENT ONE IS USED
     C  N94              DO
     C     CLLOR         IFEQ      'L'
     C                   Z-ADD     CLPOLE        POLEW             2 0
     C                   ELSE
     C     TOTPOL        IFEQ      24
     C     12            SUB       CLPOLE        SUBPOL            2 0
     C     13            ADD       SUBPOL        POLEW
     C                   ELSE
     C     14            SUB       CLPOLE        SUBPOL            2 0
     C     15            ADD       SUBPOL        POLEW
     C                   END
     C                   END
     C                   Z-ADD     POLEW         OPNPOL            3 0
     C*    55            MULT      OPNPOL        OPNFLT            3 0
     C     tr5565        MULT      OPNPOL        OPNFLT            3 0
     C                   ADD       CPAVL         OPNFLT
     C                   ADD       1             OPNPOL
     C                   ENDDO                                                  N94  DO
     C                   ENDSR
      ***********************
      ** UPDATE LOCATION   **
      ***********************
     C     GETLOC        BEGSR
     C     LOCOUT        KLIST
     C                   KFLD                    CLWKDT
     C                   KFLD                    CLSECT
     C                   KFLD                    CLBAY
     C                   KFLD                    CLNOS
     C                   KFLD                    CLLOR
     C                   KFLD                    CLPOLE
     C     LOCOUT        CHAIN     FCHMLOC                            92
     C   92              Z-ADD     0             CLTRAY
     C                   ADD       CLWKTR        CLTRAY
     C                   TIME                    CLTIME
     C                   Z-ADD     TDATE         CLDTLA
     C                   MOVEL     USERID        CLUSER
     C   92              WRITE     RCHMLOC
     C  N92              UPDATE    RCHMLOC
     C     *LIKE         DEFINE    CLSECT        NXSECT                         |SECTION #
     C     *LIKE         DEFINE    CLBAY         NXBAY                          |BAY #
     C     *LIKE         DEFINE    CLNOS         NXNOS                          |NORTH/SOUTH
     C     *LIKE         DEFINE    CLPOLE        NXPOLE                         |POLE #
     C     *LIKE         DEFINE    CLPLKY        NXPLKY                         |POLE KEY #
     C     *LIKE         DEFINE    CLLOR         NXLOR                          |L/R
     C                   Z-ADD     CLSECT        NXSECT
     C                   Z-ADD     CLBAY         NXBAY
     C                   MOVE      CLNOS         NXNOS
     C                   Z-ADD     CLPOLE        NXPOLE
     C                   Z-ADD     CLPLKY        NXPLKY
     C                   MOVE      CLLOR         NXLOR
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
     C*     CALKY1        CHAIN     FCALEX                             92     /Dont get Monday
     C                   Z-ADD     CLDATE        FRMDAT
     C                   MOVEL     CLCENT        BEGYY
     C                   MOVE      CLYEAR        BEGYY
     C                   Z-ADD     CLWEEK        BEGWW
      ** TEMP DUMMY CHAIN TO JOB FILE
     C     CLCYMD        CHAIN(N)  FCHMJOB                            92
     C                   ENDSR
