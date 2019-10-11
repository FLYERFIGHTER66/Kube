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
      **PROGRAM NAME-------- CHR020
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ENTER/UPDATE PARTS PER MILLION TABLES
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FCHR020FM  CF   E             WORKSTN
     F                                     SFILE(PPMSFL:R)
     FFMINVT    IF   E           K DISK
     FFCHMPPM   UF A E           K DISK
      *
      *
      ** PPM NUMBER ARRAY
     D PPM             S              4  0 DIM(45)                              PARTS PER MILLION
      ** FILE ARRAYS
     D COZ             S              7  3 DIM(45)                              FILE PPM OUNCE
     D CML             S              7  3 DIM(45)                              FILE PPM M.L.
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
      ** REDEFINE FCHMPPM
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
      ****************
      * START HERE   *
      ****************
     C     RSTART        TAG
     C                   MOVEL     '700'         IMSIZE
     C                   MOVE      *BLANKS       VITEM
     C                   SETOFF                                       121319                   ARC38
     C                   UNLOCK    FCHMPPM
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                       121319                   ARC38
      ** SEE IF WE NEED ALPHA SEARCH
     C     1             SUBST     VITEM:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     VITEM:2       IMLOOK
     C                   MOVE      *BLANKS       IMWHSE
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
     C                   MOVEL     IMITEM        VITEM
     C                   GOTO      NXTA
     C                   ENDIF
      ** CHECK IF ITEM IS VALID
     C                   MOVE      *BLANKS       IMWHSE
     C                   MOVEL     VITEM         IMITEM
     C     ITMKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C     ITMKEY        CHAIN     FMINVT                             90
     C   90              SETON                                        1219
     C   12              GOTO      NXTA
     C     IMSTAT        IFEQ      'D'
     C                   SETON                                        1319
     C                   GOTO      NXTA
     C                   ENDIF
      ** IF HERE SCREEN A OK
     C     ITMKEY        CHAIN     FCHMPPM                            57
     C   57              DO
     C                   CLEAR                   RCHMPPM
     C                   MOVEL     IMITEM        CMITEM
     C                   MOVEL     IMSIZE        CMSIZE
     C                   MOVEL     IMWHSE        CMWHSE
     C                   Z-ADD     1             CMCOMP
     C                   MOVEL     'A'           CMSTAT
     C                   ENDDO                                                  57 DO
      ** DISPLAY SCREEN
     C                   EXSR      BLDSFL
     C                   SETOFF                                       98
     C     NXTFMT        TAG
     C   99              SETOFF                                       98
     C                   EXFMT     PPMCTL
      ** CHECK F KEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
      ** CHECK SUB FILE
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTFMT
     C  NKA              GOTO      NXTFMT
     C                   EXSR      PUTSFL
     C                   GOTO      RSTART
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      *********************
      **   BUILD SUB FILE *
      *********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     PPMCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             R                 5 0
     C     NXTBLD        TAG
     C                   ADD       1             R
     C     R             IFLE      45
     C                   Z-ADD     PPM(R)        PARTSM
     C                   Z-ADD     COZ(R)        OUNCE
     C                   Z-ADD     CML(R)        MILS
     C                   WRITE     PPMSFL
     C                   GOTO      NXTBLD
     C                   END                                                    R<45
     C     ENDBLD        ENDSR
      *********************
      **  CHECK SUB FILE **
      *********************
     C     CHKSFL        BEGSR
     C                   SETOFF                                       102099
     C                   Z-ADD     0             R                 5 0
     C                   Z-ADD     0             LSTOZ             7 3
     C                   Z-ADD     0             LSTML             7 3
     C     NXTCHK        TAG
     C                   ADD       1             R
     C                   SETOFF                                       1121
     C     R             IFLE      45
     C     R             CHAIN     PPMSFL                             90
     C   90              GOTO      NXTCHK
     C     OUNCE         IFGT      0
     C     OUNCE         ANDLE     LSTOZ
     C                   SETON                                        101199
     C                   END
     C     MILS          IFGT      0
     C     MILS          ANDLE     LSTML
     C                   SETON                                        202199
     C                   END
     C                   Z-ADD     OUNCE         LSTOZ
     C                   Z-ADD     MILS          LSTML
     C                   UPDATE    PPMSFL
     C                   GOTO      NXTCHK
     C                   END                                                    R<45
     C     ENDCHK        TAG
     C  N99              SETON                                        98
     C                   ENDSR
      *********************
      **    PUT SUB FILE **
      *********************
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             R                 5 0
     C     NXTPUT        TAG
     C                   ADD       1             R
     C     R             IFLE      45
     C     R             CHAIN     PPMSFL                             90
     C   90              GOTO      NXTPUT
     C                   Z-ADD     OUNCE         COZ(R)
     C                   Z-ADD     MILS          CML(R)
     C                   GOTO      NXTPUT
     C                   END                                                    R<45
     C     ENDPUT        TAG
     C  N57              UPDATE    RCHMPPM
     C   57              WRITE     RCHMPPM
     C                   ENDSR
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
     C                   ENDSR
