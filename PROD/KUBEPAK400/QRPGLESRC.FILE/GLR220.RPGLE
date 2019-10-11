      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- GLR220
      *APPLICATION--------- GENERAL LEDGER
      *DESCRIPTION--------- VIDEO TRIAL BALANCE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/02/00 EFD ADD LOGIC TO DISPLAY LAST YEAR NUMBERS.
      * 11/12/02 EFD02 SCREEN POSITION CHANGES
      *
     FGLR220FM  CF   E             WORKSTN
     F                                     SFILE(DSPSFL:RECNO)
     FFMGLCH    IF   E           K DISK
     FFGLBAL    IF   E           K DISK
     FFGLCTL    IF   E           K DISK
     FFMCORG    IF   E           K DISK
      *
     D CR              S             11  2 DIM(13)
     D LY              S             11  2 DIM(13)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
      *
     IRGLBAL
      *
     I              GLT01                       CR(1)
     I              GLT02                       CR(2)
     I              GLT03                       CR(3)
     I              GLT04                       CR(4)
     I              GLT05                       CR(5)
     I              GLT06                       CR(6)
     I              GLT07                       CR(7)
     I              GLT08                       CR(8)
     I              GLT09                       CR(9)
     I              GLT10                       CR(10)
     I              GLT11                       CR(11)
     I              GLT12                       CR(12)
     I              GLT13                       CR(13)
      * LAST YEAR
     I              GLL01                       LY(1)
     I              GLL02                       LY(2)
     I              GLL03                       LY(3)
     I              GLL04                       LY(4)
     I              GLL05                       LY(5)
     I              GLL06                       LY(6)
     I              GLL07                       LY(7)
     I              GLL08                       LY(8)
     I              GLL09                       LY(9)
     I              GLL10                       LY(10)
     I              GLL11                       LY(11)
     I              GLL12                       LY(12)
     I              GLL13                       LY(13)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FGLCTL                             90
     C     LCO           CHAIN     FMCORG                             90
     C                   Z-ADD     LCO           VCO               2 0
      *
     C     GLKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GLNO
      *
     C                   SETOFF                                       99
     C     RSTRTA        TAG
     C**                   MOVEL*BLANKS   VDESC1
     C**                   MOVEL*BLANKS   VDESC2
     C                   MOVEL     *BLANKS       VBALPH
     C                   MOVEL     *BLANKS       VEALPH
     C                   MOVEL     'T'           YEAR
     C**                   Z-ADD0         VBGL
     C**                   Z-ADD0         VEGL
     C**                   Z-ADD0         VACTP
     C                   Z-ADD     0             TOTCUR
     C                   Z-ADD     0             TOTBAL           11 2
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       203040
     C                   SETOFF                                       45
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C   KB              DO
     C                   Z-ADD     LCO           ACCOMP            2 0
     C                   CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    VACTP
     C                   GOTO      NXTA
     C                   ENDDO
      *
     C     VBGL          IFEQ      0
     C     VBALPH        ANDEQ     *BLANKS
     C*                    SETON                     1011
     C*                    GOTO RSTRTA
     C                   Z-ADD     0             VBGL
     C                   Z-ADD     99999999      VEGL
     C                   GOTO      NOLIST
     C                   ENDIF
      *
     C     VBGL          IFGT      0
     C     VBALPH        ANDGT     *BLANKS
     C                   SETON                                        1011
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBGL          IFEQ      0
     C     VBALPH        ANDGT     *BLANKS
     C                   MOVEL     VBALPH        GCLOOK
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    VCO
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   MOVEL     *BLANKS       VBALPH
     C                   MOVEL     GCGLNO        VBGL
     C                   MOVEL     GCDESC        VDESC1
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VEGL          IFEQ      0
     C     VEALPH        ANDEQ     *BLANKS
     C                   SETON                                        20
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VEGL          IFGT      0
     C     VEALPH        ANDGT     *BLANKS
     C                   SETON                                        20
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VEGL          IFEQ      0
     C     VEALPH        ANDGT     *BLANKS
     C                   Z-ADD     LCO           GCCOMP
     C                   MOVEL     VEALPH        GCLOOK
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    GCCOMP
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   MOVEL     *BLANKS       VEALPH
     C                   MOVEL     GCGLNO        VEGL
     C                   MOVEL     GCDESC        VDESC2
     C                   MOVEL     GCCOMP        CO2               2 0
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VEGL          IFLT      VBGL
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     NOLIST        TAG
      *
     C     VACTP         IFLE      0                                                        K
     C     VACTP         ORGT      13                                                       K
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     VACTP         P                 2 0
      ** CHECK THIS YEAR OR LAST YEAR
     C     YEAR          IFNE      'T'
     C     YEAR          ANDNE     'L'
     C                   SETON                                        45
     C                   GOTO      NXTA
     C                   END
      ** 71 DETERMINES YEAR IF ON LAST YEAR
     C     YEAR          IFEQ      'L'
     C                   SETON                                        71
     C                   ELSE
     C                   SETOFF                                       71
     C                   END
      *
      * GET PERIOD DATES
      *
     C                   Z-ADD     LCO           CONO
     C                   Z-ADD     VACTP         ACTPER
     C                   CALL      'GETPDAT'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     BEGDAT        BEGDTE
     C                   Z-ADD     ENDDAT        ENDDTE
     C   71              DO
     C                   MOVE      BEGDTE        YY                3 0
     C                   SUB       1             YY
     C                   MOVE      YY            YY2               2 0
     C                   MOVE      YY2           BEGDTE
     C                   MOVE      ENDDTE        YY                3 0
     C                   SUB       1             YY
     C                   MOVE      YY            YY2               2 0
     C                   MOVE      YY2           ENDDTE
     C                   ENDDO
      *
      * SET FMGLCH BACK TO BEGINING OF CHART OF ACCOUNTS
      *
     C                   Z-ADD     VBGL          GLNO              8 0
     C     GLKEY         SETLL     FMGLCH
     C                   MOVE      '1'           *IN80
     C                   WRITE     DSPCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTB          TAG
     C                   Z-ADD     0             CURBAL
     C                   SETOFF                                       90
     C     LCO           READE     FMGLCH                                 90
     C   90              GOTO      DSPL
      *
     C     GCSTAT        IFEQ      'D'
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     GCGLNO        IFLT      VBGL
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     GCGLNO        IFGT      VEGL
     C                   GOTO      DSPL
     C                   ENDIF
      *
      * READ GLBAL
      *
     C     BALKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GCGLNO
     C     BALKEY        CHAIN     FGLBAL                             90
     C   90              GOTO      NXTB
      *
     C  N71              Z-ADD     CR(P)         CUR
     C   71              Z-ADD     LY(P)         CUR
      *
     C  N71              ADD       CR(P)         TOTCUR           11 2
     C   71              ADD       LY(P)         TOTCUR           11 2
      *
     C  N71              ADD       GLBALT        CURBAL           11 2
     C   71              ADD       GLBALL        CURBAL           11 2
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C  N71              ADD       CR(X)         CURBAL
     C   71              ADD       LY(X)         CURBAL
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   ADD       CURBAL        TOTBAL
      *
     C                   ADD       1             RECNO
     C                   WRITE     DSPSFL
     C                   GOTO      NXTB
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   MOVEL     *BLANKS       GLGLNO
     C                   MOVEL     *BLANKS       GCDESC
     C                   Z-ADD     TOTCUR        CUR
     C                   Z-ADD     TOTBAL        CURBAL
     C                   MOVEL     'Total =>'    DESC1             8
     C*                    MOVE ' Data * 'DESC1
     C                   MOVE      DESC1         GCDESC
     C                   WRITE     DSPSFL
     C                   EXFMT     DSPCTL
     C   KC
     COR KG              GOTO      EOJ
     C                   GOTO      RSTRTA
      *
     C     EOJ           TAG
     C                   SETON                                        LR
      *
