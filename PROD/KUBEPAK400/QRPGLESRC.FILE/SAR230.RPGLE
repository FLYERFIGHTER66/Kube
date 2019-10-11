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
      *PROGRAM NAME-------- SAR230
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- DETAIL CUSTOMER INQUIRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSAR230FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFSHIDCI   IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
      *
     D MSG             S             29    DIM(1) CTDATA PERRCD(1)
      * SHIST ARRAYS
     D CS$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
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
     IRSHIST
      *
     I              SICS01                      CS$(1)
     I              SICS02                      CS$(2)
     I              SICS03                      CS$(3)
     I              SICS04                      CS$(4)
     I              SICS05                      CS$(5)
     I              SICS06                      CS$(6)
     I              SICS07                      CS$(7)
     I              SICS08                      CS$(8)
     I              SICS09                      CS$(9)
     I              SICS10                      CS$(10)
     I              SICS11                      CS$(11)
     I              SICS12                      CS$(12)
     I              SICS13                      CS$(13)
      *
     I              SILS01                      PS$(1)
     I              SILS02                      PS$(2)
     I              SILS03                      PS$(3)
     I              SILS04                      PS$(4)
     I              SILS05                      PS$(5)
     I              SILS06                      PS$(6)
     I              SILS07                      PS$(7)
     I              SILS08                      PS$(8)
     I              SILS09                      PS$(9)
     I              SILS10                      PS$(10)
     I              SILS11                      PS$(11)
     I              SILS12                      PS$(12)
     I              SILS13                      PS$(13)
      *
     I              SICQ01                      CSQ(1)
     I              SICQ02                      CSQ(2)
     I              SICQ03                      CSQ(3)
     I              SICQ04                      CSQ(4)
     I              SICQ05                      CSQ(5)
     I              SICQ06                      CSQ(6)
     I              SICQ07                      CSQ(7)
     I              SICQ08                      CSQ(8)
     I              SICQ09                      CSQ(9)
     I              SICQ10                      CSQ(10)
     I              SICQ11                      CSQ(11)
     I              SICQ12                      CSQ(12)
     I              SICQ13                      CSQ(13)
      *
     I              SILQ01                      PSQ(1)
     I              SILQ02                      PSQ(2)
     I              SILQ03                      PSQ(3)
     I              SILQ04                      PSQ(4)
     I              SILQ05                      PSQ(5)
     I              SILQ06                      PSQ(6)
     I              SILQ07                      PSQ(7)
     I              SILQ08                      PSQ(8)
     I              SILQ09                      PSQ(9)
     I              SILQ10                      PSQ(10)
     I              SILQ11                      PSQ(11)
     I              SILQ12                      PSQ(12)
     I              SILQ13                      PSQ(13)
      *
      *  MAIN FLOW OF PROGRAM
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   SETOFF                                       99
     C     RSTRTA        TAG
     C                   Z-ADD     0             CSMTD
     C                   Z-ADD     0             CSYTD
     C                   Z-ADD     0             LSYTD
     C                   Z-ADD     0             CQMTD
     C                   Z-ADD     0             CQYTD
     C                   Z-ADD     0             LQYTD
     C                   Z-ADD     0             TCSM
     C                   Z-ADD     0             TCSY
     C                   Z-ADD     0             TLSY
     C                   Z-ADD     0             TCQM
     C                   Z-ADD     0             TCQY
     C                   Z-ADD     0             TLQY
     C                   MOVEL     *BLANKS       CMNAME
     C                   Z-ADD     *ZEROS        VCUST
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131417
     C                   SETOFF                                       819918
     C                   SETOFF                                       30
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
     C     VCUST         IFEQ      0
     C     VALPHA        ANDEQ     *BLANKS
     C                   SETON                                        1011
     C   11              GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         IFGT      0
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        1011
     C   11              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VCUST         IFEQ      0
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     CMCUST        VCUST
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         CHAIN     FMCUST                             31
     C   31              SETON                                        131499
     C   13
     CAN 99              GOTO      RSTRTA
      *
     C     VACTP         IFEQ      *ZEROS
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
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
     C                   Z-ADD     VACTP         P                 2 0
      *
      * SET FSHIST BACK TO BEGINING OF CUSTOMER
      *
     C     VCUST         SETLL     FSHIDCI
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     RSTRTB        TAG
     C                   SETOFF                                       90
     C     NXTI          TAG
     C     VCUST         READE     FSHIDCI                                90
     C   90              GOTO      DSPL
      *
     C     SIITEM        IFEQ      *BLANKS
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C                   Z-ADD     CS$(P)        CSMTD
     C                   XFOOT     CS$           CSYTD
     C                   XFOOT     PS$           LSYTD
     C                   Z-ADD     CSQ(P)        CQMTD             8 0
     C                   XFOOT     CSQ           CQYTD             8 0
     C                   XFOOT     PSQ           LQYTD             8 0
      *
     C     CSMTD         IFEQ      0
     C     CSYTD         ANDEQ     0
     C     LSYTD         ANDEQ     0
     C     CQMTD         ANDEQ     0
     C     CQYTD         ANDEQ     0
     C     LQYTD         ANDEQ     0
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C                   ADD       CSMTD         TCSM              9 2
     C                   ADD       CSYTD         TCSY              9 2
     C                   ADD       LSYTD         TLSY              9 2
     C                   ADD       CQMTD         TCQM              8 0
     C                   ADD       CQYTD         TCQY              8 0
     C                   ADD       LQYTD         TLQY              8 0
      *
     C     KEY18         KLIST
     C                   KFLD                    SIITEM
     C                   KFLD                    SISIZE
     C     KEY18         CHAIN     FMINVT                             90
     C  N90              EXSR      GETDES
     C   90              MOVEL     MSG(1)        DESC
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     0             CS$
     C                   MOVEL     *BLANKS       SIITEM
     C                   MOVEL     *BLANKS       SISIZE
     C                   MOVEL     *BLANKS       DESC
     C                   Z-ADD     TCSM          CSMTD
     C                   Z-ADD     TCSY          CSYTD
     C                   Z-ADD     TLSY          LSYTD
     C                   Z-ADD     TCQM          CQMTD
     C                   Z-ADD     TCQY          CQYTD
     C                   Z-ADD     TLQY          LQYTD
     C                   MOVEL     '* Totals'    DESC1            16
     C                   MOVE      ' *      '    DESC1
     C                   MOVEL     DESC1         DESC
     C                   WRITE     RECSFL
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      EOJ
     C                   GOTO      RSTRTA
      *
     C     EOJ           TAG
     C                   SETON                                        LR
      *
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC             29
     C                   ENDSR
      *
**  BOTTOM OF SCREEN MESSAGES
  ** Item Not On File **
