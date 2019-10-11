      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME--------- APC330
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *APPLICATION---------- CHECK PRINT PROMPT SCREEN
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 10/26/99 EFD LOG #14 ALLOW REUSE OF CHECK NUMBERS ON RERUN Y.
      *
      *
     FFAPCTL    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFAPCHK    IF   E           K DISK
     FAPC330FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
     D MSG             S             52    DIM(2) CTDATA PERRCD(1)
      *
      * MAPER ARRAYS
     D BEG             S              6  0 DIM(13)                              BEG DATES
     D DNE             S              6  0 DIM(13)                              END DATES
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
     D                UDS
     D  LCO                    1      2  0
     D  LPROG                 29     36
     D  LNAME                 37     60
     D  LDATE                 61     66  0
     D  LCHECK                67     72  0
     D  LVOID                 73     74  0
     D  LRERUN                76     76
     D  LPRTR1                81     90
     D  LPRTR2               100    109
     D  LCOPY                114    115  0
     D  LJOB                 116    116
     D  LHOLD                117    120
     D  LSAVE                121    124
     D  LCANCL               133    133
     D  JAMRCV               150    150
      * FIRST CHECK IN CURRENT RUN
     D  FSTCHK               151    156  0
      * LAST CHECK IN CURRENT RUN
     D  LSTCHK               157    162  0
     D  LFORM1               163    172
     D  LFORM2               173    182
      * LAST GOOD CHECK PRINTED
     D  LSTGDC               183    188  0
     D  SCDATE               201    205  0
     D  YRBEG                211    215  0
      *
     IRMAPER
     I              ACST01                      BEG(1)
     I              ACST02                      BEG(2)
     I              ACST03                      BEG(3)
     I              ACST04                      BEG(4)
     I              ACST05                      BEG(5)
     I              ACST06                      BEG(6)
     I              ACST07                      BEG(7)
     I              ACST08                      BEG(8)
     I              ACST09                      BEG(9)
     I              ACST10                      BEG(10)
     I              ACST11                      BEG(11)
     I              ACST12                      BEG(12)
     I              ACST13                      BEG(13)
     I              ACEN01                      DNE(1)
     I              ACEN02                      DNE(2)
     I              ACEN03                      DNE(3)
     I              ACEN04                      DNE(4)
     I              ACEN05                      DNE(5)
     I              ACEN06                      DNE(6)
     I              ACEN07                      DNE(7)
     I              ACEN08                      DNE(8)
     I              ACEN09                      DNE(9)
     I              ACEN10                      DNE(10)
     I              ACEN11                      DNE(11)
     I              ACEN12                      DNE(12)
     I              ACEN13                      DNE(13)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     TDATE         VDATE
     C                   MOVEL     'N'           VRERUN
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     0             FIRST             2 0
     C                   Z-ADD     0             WARN              2 0
      *
     C     LCO           CHAIN     FAPCTL                             90
      *
     C                   Z-ADD     AZCHEK        VCHECK
     C     AZLSCK        IFEQ      0
     C     AZCHEK        SUB       1             LSTCHK
     C                   ELSE
     C                   Z-ADD     AZLSCK        LSTCHK
     C                   ENDIF
     C                   MOVEL     AZPRTC        VPRTR1
     C                   MOVEL     AZPRTR        VPRTR2
      *
      *
     C     NXTA          TAG
     C                   Z-ADD     0             CNT               2 0
      *
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C                   SETOFF                                       101112
     C                   SETOFF                                       1516
     C                   SETOFF                                       202122
     C                   SETOFF                                       304050
     C                   SETOFF                                       521563
     C                   SETOFF                                       606296
      *
     C     AZOKC         IFNE      'Y'
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     VDATE         LDATE
     C                   MOVEL     VRERUN        LRERUN
     C                   Z-ADD     VCHECK        LCHECK
     C                   Z-ADD     VVOID         LVOID
     C                   MOVEL     VPRTR1        LPRTR1
     C                   MOVEL     VPRTR2        LPRTR2
      *
     C                   Z-ADD     VDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         SCDATE            5 0
      *
     C     AZGL          IFEQ      'N'
     C                   GOTO      NOGL
     C                   ENDIF
      *
     C     SCDATE        IFLT      YRBEG
     C                   SETON                                        1015
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   ADD       1             WARN              2 0
     C     SCDATE        IFGT      YREND
     C     WARN          ANDEQ     1
     C                   SETON                                        1016
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     NOGL          TAG
      *
     C     VCHECK        IFEQ      *ZEROS                                                   OS
     C                   SETON                                        2021
     C   21              GOTO      NXTA
     C                   ENDIF
      *
     C     VRERUN        IFNE      'Y'
     C     VRERUN        ANDNE     'N'
     C                   SETON                                        50
     C   50              GOTO      NXTA
     C                   ENDIF
      * SEE IF PREVIOUS CHECK RUN HAS BEEN POSTED
      *
     C     AZCKR         IFEQ      'Y'
     C     VRERUN        IFEQ      'N'
     C                   SETON                                            62    10
     C                   GOTO      NXTA
     C                   ENDIF
     C                   ELSE
     C     VRERUN        IFEQ      'Y'
     C                   SETON                                            63    50
     C                   GOTO      NXTA
     C                   ENDIF
     C                   END
      *
      * IF RERUN NO USE CHECK # FROM CONTROL FILE
     C     VRERUN        IFEQ      'N'
     C     VCHECK        IFLT      LSTCHK                                                   OS
     C                   SETON                                        2022
     C   22              GOTO      NXTA
     C                   ENDIF
      *
     C                   ADD       1             FIRST
     C     VCHECK        SUB       LSTCHK        CKDIFF            6 0
     C     CKDIFF        IFGT      10
     C     FIRST         ANDEQ     1
     C                   SETON                                        9698
     C                   MOVEL     MSG(2)        MESAGE           52
     C   96              GOTO      NXTA
     C                   ENDIF
     C                   END
      *
      * IF RERUN YES USE FIRST CHECK # FROM APCHECK FILE
      *
     C     VRERUN        IFEQ      'Y'
     C     VCHECK        IFLT      FSTCHK                                                   OS
     C                   SETON                                        2022
     C   22              GOTO      NXTA
     C                   ENDIF
     C                   END
      *
     C     LFORM1        IFEQ      *BLANKS                                                  K
     C                   SETON                                        30
     C   30              GOTO      NXTA
     C                   ENDIF
      *
     C     LFORM1        IFNE      OFORM1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM1        OFORM1           10
      *
     C     LFORM2        IFNE      OFORM2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM2        OFORM2           10
      *
     C     VPRTR1        IFEQ      *BLANKS                                                  K
     C                   SETON                                        52
     C   52              GOTO      NXTA
     C                   ENDIF
      *
     C     VPRTR1        IFNE      OPRTR1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VPRTR1        OPRTR1           10
      *
     C     VPRTR2        IFNE      OPRTR2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VPRTR2        OPRTR2           10
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        53
     C   53              GOTO      NXTA
     C                   ENDIF
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
     C     VOUT          IFNE      OOUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VOUT          OOUT              1 0
      *
     C     VDATE         IFNE      ODATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VDATE         ODATE             6 0
      *
     C     VCHECK        IFNE      OCHECK
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VCHECK        OCHECK            6 0
      *
     C     VVOID         IFNE      OVOID
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VVOID         OVOID             2 0
      *
     C     VRERUN        IFNE      ORERUN
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VRERUN        ORERUN            1
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   MOVEL     MSG(1)        MESAGE           52
     C   98              GOTO      NXTA
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     0             FSTCHK
     C                   Z-ADD     0             LSTCHK
     C                   Z-ADD     0             LSTGDC
     C                   MOVEL     'Y'           JAMRCV
     C     APCKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    ACCHEK
     C                   Z-ADD     0             ACCHEK
     C     APCKEY        SETLL     FAPCHK
     C     NXTINZ        TAG
     C     LCO           READE     FAPCHK                                 90
     C   90              GOTO      ENDINZ
     C     FSTCHK        IFLE      0
     C                   Z-ADD     ACCHEK        FSTCHK
     C                   END
     C                   GOTO      NXTINZ
     C     ENDINZ        TAG
     C                   Z-ADD     ACCHEK        LSTCHK
     C     FSTCHK        IFGT      0
     C     FSTCHK        SUB       1             LSTGDC
     C                   ELSE
     C                   Z-ADD     0             LSTGDC
     C                   END
     C     LCO           CHAIN     FAPCTL                             90
      *
     C                   Z-ADD     0             VCHECK
     C                   MOVEL     AZPRTC        LPRTR1
     C                   MOVEL     AZPRTR        LPRTR2
      *
     C                   MOVEL     'APCHECK#'    LFORM1
     C                   MOVE      LCO           LFORM1
     C                   MOVEL     '*NAR'        LFORM2
     C                   Z-ADD     TDATE         LDATE
     C                   MOVEL     'N'           LRERUN
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     1             LCOPY
     C                   Z-ADD     0             FIRST             2 0
      *
      *
      * GET EARLIEST AND LAST ACCTG PERIOD DATE
      *
     C     AZGL          IFEQ      'Y'
     C                   DO
     C     LCO           CHAIN     FMAPER                             90
     C                   Z-ADD     BEG(1)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         YRBEG             5 0
      *
     C     ACMPCN        IFEQ      'M'
     C                   Z-ADD     DNE(12)       ##MDY
     C                   ELSE
     C                   Z-ADD     DNE(13)       ##MDY
     C                   ENDIF
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         YREND             5 0
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *
**  BOTTOM OF SCREEN MESSAGES
  Validate Data - Change or Press Enter to Accept
 Change Check Number - or - Press Enter to Continue
